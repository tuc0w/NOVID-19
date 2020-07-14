import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class ExposureNotifications extends Table {
    IntColumn get id => integer().autoIncrement()();
    TextColumn get identifier => text().withLength(max: 17)();
    IntColumn get rssi => integer()();
    DateTimeColumn get date => dateTime().nullable()();
}

class DiscoveredContacts extends Table {
    IntColumn get id => integer().autoIncrement()();
    TextColumn get identifier => text().withLength(max: 17)();
    DateTimeColumn get date => dateTime().nullable()();

    @override
    List<String> get customConstraints => [
        'UNIQUE (id, identifier)'
    ];
}

@DataClassName('DiscoveredContactEntry')
class DiscoveredContactEntries extends Table {
    IntColumn get discoveredContact => integer()();
    IntColumn get exposureNotification => integer()();
}

class ContactWithNotifications {
    final DiscoveredContact contact;
    final List<ExposureNotification> notifications;

    ContactWithNotifications(this.contact, this.notifications);
}

LazyDatabase _openConnection() {
    return LazyDatabase(() async {
        final dbFolder = await getApplicationDocumentsDirectory();
        final dbPath = p.join(dbFolder.path, 'db.sqlite');
        return FlutterQueryExecutor.inDatabaseFolder(
            path: dbPath,
            logStatements: true
        );
    });
}

@UseMoor(
    tables: [
        ExposureNotifications,
        DiscoveredContacts,
        DiscoveredContactEntries
    ]
)
class Database extends _$Database {
    Database() : super(_openConnection());

    @override
    int get schemaVersion => 1;

    // ExposureNotifications
    Future<List<ExposureNotification>> getAllExposureNotifications() => select(exposureNotifications).get();
    Stream<List<ExposureNotification>> watchAllExposureNotifications() => select(exposureNotifications).watch();
    Future insertExposureNotification(ExposureNotification exposureNotification) => into(exposureNotifications).insert(exposureNotification);

    Future addExposureNotification({String identifier, int rssi}) async {
        int contactId;
        final DateTime date = new DateTime.now();
        final ExposureNotification exposureNotification = new ExposureNotification(
            identifier: identifier,
            rssi: rssi,
            date: date
        );

        final exposureId = await into(exposureNotifications).insert(exposureNotification);

        final discoveredContact = await (
            select(discoveredContacts)
                ..where((tbl) => tbl.identifier.equals(identifier))
            ).getSingle();

        if (discoveredContact == null) {
            contactId = await addDiscoveredContact(identifier: identifier);
        } else {
            contactId = discoveredContact.id;
        }

        await addDiscoveredContactEntry(discoveredContactId: contactId, exposureNotificationId: exposureId);
    }

    Future<List> getUniqueExposureNotifications({DateTime date}) async {
        final query = selectOnly(exposureNotifications)
            ..addColumns([exposureNotifications.identifier])
            ..groupBy([exposureNotifications.identifier]);
        
        if (date != null) {
            query..where(
                exposureNotifications.date.year.equals(date.year) &
                exposureNotifications.date.month.equals(date.month) &
                exposureNotifications.date.day.equals(date.day)
            );
        }
        
        return await query.get();
    }

    Future<int> getLowestExposureDistance({DateTime date}) async {
        final query = select(exposureNotifications)
            ..orderBy([
                (tbl) => OrderingTerm(
                    expression: tbl.rssi,
                    mode: OrderingMode.desc
                )
            ])
            ..limit(1);

        if (date != null) {
            query..where((a) => 
                exposureNotifications.date.year.equals(date.year) &
                exposureNotifications.date.month.equals(date.month) &
                exposureNotifications.date.day.equals(date.day)
            );
        }

        final result = await query.getSingle();

        return result?.rssi ?? 0;
    }

    // ConfirmedContacts
    Future<List<DiscoveredContact>> getAllConfirmedContacts() => select(discoveredContacts).get();
    Stream<List<DiscoveredContact>> watchAllConfirmedContacts() => select(discoveredContacts).watch();
    Future insertConfirmedContact(DiscoveredContact confirmedContact) => into(discoveredContacts).insert(confirmedContact);

    Future<int> addDiscoveredContact({String identifier, DateTime date}) async {
        final _date = date ?? new DateTime.now();
        final DiscoveredContact discoveredContact = new DiscoveredContact(
            identifier: identifier,
            date: _date
        );
        return await into(discoveredContacts).insert(discoveredContact, mode: InsertMode.insertOrIgnore);
    }

    // DiscoveredContactEntries
    Future addDiscoveredContactEntry({int discoveredContactId, int exposureNotificationId}) async {
        final DiscoveredContactEntry discoveredContactEntry = DiscoveredContactEntry(
            discoveredContact: discoveredContactId,
            exposureNotification: exposureNotificationId
        );
        await into(discoveredContactEntries).insert(discoveredContactEntry);
    }
}
