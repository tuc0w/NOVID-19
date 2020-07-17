part of 'database.dart';

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
