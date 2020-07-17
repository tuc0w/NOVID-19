import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:rxdart/rxdart.dart';

part 'database.g.dart';
part 'tables.dart';

@UseMoor(
    tables: [
        ExposureNotifications,
        DiscoveredContacts,
        DiscoveredContactEntries
    ]
)
class Database extends _$Database {
    Database() : super(VmDatabase.memory());

    // Isolate connect constructor
    Database.connect(DatabaseConnection connection) : super.connect(connection);

    @override
    int get schemaVersion => 1;

    // ExposureNotifications
    Future<List<ExposureNotification>> getAllExposureNotifications() => select(exposureNotifications).get();
    Stream<List<ExposureNotification>> watchAllExposureNotifications() => select(exposureNotifications).watch();
    Future insertExposureNotification(ExposureNotification exposureNotification) => into(exposureNotifications).insert(exposureNotification);

    Future<void> addExposureNotification({String identifier, int rssi}) async {
        int contactId;
        final discoveredContact = await (
            select(discoveredContacts)
                ..where((tbl) => tbl.identifier.equals(identifier))
                ..orderBy([
                    (tbl) => OrderingTerm(
                        expression: tbl.date,
                        mode: OrderingMode.desc
                    )
                ])
                ..limit(1) // this needs to be fixed, there cannot be more than one entry
            ).getSingle();

        if (discoveredContact != null) {
            contactId = discoveredContact.id;
            final DateTime date = new DateTime.now();
            final ExposureNotification exposureNotification = new ExposureNotification(
                identifier: identifier,
                rssi: rssi,
                date: date
            );
            final exposureId = await into(exposureNotifications).insert(exposureNotification);
            await addDiscoveredContactEntry(discoveredContactId: contactId, exposureNotificationId: exposureId);
        }
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

    Future<List<DiscoveredContact>> getAllDiscoveredContacts() => select(discoveredContacts).get();
    Stream<List<DiscoveredContact>> watchAllDiscoveredContacts() => select(discoveredContacts).watch();
    Future insertDiscoveredContact(DiscoveredContact discoveredContact) => into(discoveredContacts).insert(discoveredContact);

    Future<int> addDiscoveredContact({String identifier, DateTime date}) async {
        final _date = date ?? new DateTime.now();
        int contactId;

        final discoveredContact = await (
            select(discoveredContacts)
                ..where((tbl) => tbl.identifier.equals(identifier))
                ..orderBy([
                    (tbl) => OrderingTerm(
                        expression: tbl.date,
                        mode: OrderingMode.desc
                    )
                ])
                ..limit(1) // this needs to be fixed, there cannot be more than one entry
            ).getSingle();

        if (discoveredContact == null) {
            final DiscoveredContact discoveredContact = new DiscoveredContact(
                identifier: identifier,
                date: _date
            );
            contactId = await into(discoveredContacts).insert(discoveredContact, mode: InsertMode.insertOrIgnore);
        } else {
            contactId = discoveredContact.id;
        }
        return contactId;
    }

    Future addDiscoveredContactEntry({int discoveredContactId, int exposureNotificationId}) async {
        final DiscoveredContactEntry discoveredContactEntry = DiscoveredContactEntry(
            discoveredContact: discoveredContactId,
            exposureNotification: exposureNotificationId
        );
        await into(discoveredContactEntries).insert(discoveredContactEntry);
    }

    Stream<List<ContactWithNotifications>> watchAllContacts({DateTime from, DateTime to}) {
        final discoveredContactsStream = (select(discoveredContacts)
            ..where(
                (contact) => 
                    contact.date.isBetweenValues(from, to)
            )).watch();

        return discoveredContactsStream.switchMap((contacts) {
            final idToContact = {for (var contact in contacts) contact.id: contact};
            final ids = idToContact.keys;

            final entryQuery = select(discoveredContactEntries).join(
                [
                    innerJoin(
                        exposureNotifications,
                        exposureNotifications.id.equalsExp(discoveredContactEntries.exposureNotification),
                    )
                ],
            )..where(discoveredContactEntries.discoveredContact.isIn(ids));

            return entryQuery.watch().map((rows) {
                final idToNotifications = <int, List<ExposureNotification>>{};

                for (var row in rows) {
                    final notification = row.readTable(exposureNotifications);
                    final id = row.readTable(discoveredContactEntries).discoveredContact;

                    idToNotifications.putIfAbsent(id, () => []).add(notification);
                }

                return [
                    for (var id in ids)
                    ContactWithNotifications(idToContact[id], idToNotifications[id] ?? []),
                ];
            });
        });
    }
}
