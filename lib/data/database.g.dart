// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class ExposureNotification extends DataClass
    implements Insertable<ExposureNotification> {
  final int id;
  final String identifier;
  final int rssi;
  final DateTime date;
  ExposureNotification(
      {@required this.id,
      @required this.identifier,
      @required this.rssi,
      this.date});
  factory ExposureNotification.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return ExposureNotification(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      identifier: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}identifier']),
      rssi: intType.mapFromDatabaseResponse(data['${effectivePrefix}rssi']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || identifier != null) {
      map['identifier'] = Variable<String>(identifier);
    }
    if (!nullToAbsent || rssi != null) {
      map['rssi'] = Variable<int>(rssi);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    return map;
  }

  ExposureNotificationsCompanion toCompanion(bool nullToAbsent) {
    return ExposureNotificationsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      identifier: identifier == null && nullToAbsent
          ? const Value.absent()
          : Value(identifier),
      rssi: rssi == null && nullToAbsent ? const Value.absent() : Value(rssi),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
    );
  }

  factory ExposureNotification.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ExposureNotification(
      id: serializer.fromJson<int>(json['id']),
      identifier: serializer.fromJson<String>(json['identifier']),
      rssi: serializer.fromJson<int>(json['rssi']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'identifier': serializer.toJson<String>(identifier),
      'rssi': serializer.toJson<int>(rssi),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  ExposureNotification copyWith(
          {int id, String identifier, int rssi, DateTime date}) =>
      ExposureNotification(
        id: id ?? this.id,
        identifier: identifier ?? this.identifier,
        rssi: rssi ?? this.rssi,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('ExposureNotification(')
          ..write('id: $id, ')
          ..write('identifier: $identifier, ')
          ..write('rssi: $rssi, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(identifier.hashCode, $mrjc(rssi.hashCode, date.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ExposureNotification &&
          other.id == this.id &&
          other.identifier == this.identifier &&
          other.rssi == this.rssi &&
          other.date == this.date);
}

class ExposureNotificationsCompanion
    extends UpdateCompanion<ExposureNotification> {
  final Value<int> id;
  final Value<String> identifier;
  final Value<int> rssi;
  final Value<DateTime> date;
  const ExposureNotificationsCompanion({
    this.id = const Value.absent(),
    this.identifier = const Value.absent(),
    this.rssi = const Value.absent(),
    this.date = const Value.absent(),
  });
  ExposureNotificationsCompanion.insert({
    this.id = const Value.absent(),
    @required String identifier,
    @required int rssi,
    this.date = const Value.absent(),
  })  : identifier = Value(identifier),
        rssi = Value(rssi);
  static Insertable<ExposureNotification> custom({
    Expression<int> id,
    Expression<String> identifier,
    Expression<int> rssi,
    Expression<DateTime> date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (identifier != null) 'identifier': identifier,
      if (rssi != null) 'rssi': rssi,
      if (date != null) 'date': date,
    });
  }

  ExposureNotificationsCompanion copyWith(
      {Value<int> id,
      Value<String> identifier,
      Value<int> rssi,
      Value<DateTime> date}) {
    return ExposureNotificationsCompanion(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      rssi: rssi ?? this.rssi,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (identifier.present) {
      map['identifier'] = Variable<String>(identifier.value);
    }
    if (rssi.present) {
      map['rssi'] = Variable<int>(rssi.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExposureNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('identifier: $identifier, ')
          ..write('rssi: $rssi, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $ExposureNotificationsTable extends ExposureNotifications
    with TableInfo<$ExposureNotificationsTable, ExposureNotification> {
  final GeneratedDatabase _db;
  final String _alias;
  $ExposureNotificationsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _identifierMeta = const VerificationMeta('identifier');
  GeneratedTextColumn _identifier;
  @override
  GeneratedTextColumn get identifier => _identifier ??= _constructIdentifier();
  GeneratedTextColumn _constructIdentifier() {
    return GeneratedTextColumn('identifier', $tableName, false,
        maxTextLength: 17);
  }

  final VerificationMeta _rssiMeta = const VerificationMeta('rssi');
  GeneratedIntColumn _rssi;
  @override
  GeneratedIntColumn get rssi => _rssi ??= _constructRssi();
  GeneratedIntColumn _constructRssi() {
    return GeneratedIntColumn(
      'rssi',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, identifier, rssi, date];
  @override
  $ExposureNotificationsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'exposure_notifications';
  @override
  final String actualTableName = 'exposure_notifications';
  @override
  VerificationContext validateIntegrity(
      Insertable<ExposureNotification> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('identifier')) {
      context.handle(
          _identifierMeta,
          identifier.isAcceptableOrUnknown(
              data['identifier'], _identifierMeta));
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    if (data.containsKey('rssi')) {
      context.handle(
          _rssiMeta, rssi.isAcceptableOrUnknown(data['rssi'], _rssiMeta));
    } else if (isInserting) {
      context.missing(_rssiMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExposureNotification map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ExposureNotification.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ExposureNotificationsTable createAlias(String alias) {
    return $ExposureNotificationsTable(_db, alias);
  }
}

class DiscoveredContact extends DataClass
    implements Insertable<DiscoveredContact> {
  final int id;
  final String identifier;
  final DateTime date;
  DiscoveredContact({@required this.id, @required this.identifier, this.date});
  factory DiscoveredContact.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return DiscoveredContact(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      identifier: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}identifier']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || identifier != null) {
      map['identifier'] = Variable<String>(identifier);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    return map;
  }

  DiscoveredContactsCompanion toCompanion(bool nullToAbsent) {
    return DiscoveredContactsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      identifier: identifier == null && nullToAbsent
          ? const Value.absent()
          : Value(identifier),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
    );
  }

  factory DiscoveredContact.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DiscoveredContact(
      id: serializer.fromJson<int>(json['id']),
      identifier: serializer.fromJson<String>(json['identifier']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'identifier': serializer.toJson<String>(identifier),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  DiscoveredContact copyWith({int id, String identifier, DateTime date}) =>
      DiscoveredContact(
        id: id ?? this.id,
        identifier: identifier ?? this.identifier,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('DiscoveredContact(')
          ..write('id: $id, ')
          ..write('identifier: $identifier, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(identifier.hashCode, date.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DiscoveredContact &&
          other.id == this.id &&
          other.identifier == this.identifier &&
          other.date == this.date);
}

class DiscoveredContactsCompanion extends UpdateCompanion<DiscoveredContact> {
  final Value<int> id;
  final Value<String> identifier;
  final Value<DateTime> date;
  const DiscoveredContactsCompanion({
    this.id = const Value.absent(),
    this.identifier = const Value.absent(),
    this.date = const Value.absent(),
  });
  DiscoveredContactsCompanion.insert({
    this.id = const Value.absent(),
    @required String identifier,
    this.date = const Value.absent(),
  }) : identifier = Value(identifier);
  static Insertable<DiscoveredContact> custom({
    Expression<int> id,
    Expression<String> identifier,
    Expression<DateTime> date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (identifier != null) 'identifier': identifier,
      if (date != null) 'date': date,
    });
  }

  DiscoveredContactsCompanion copyWith(
      {Value<int> id, Value<String> identifier, Value<DateTime> date}) {
    return DiscoveredContactsCompanion(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (identifier.present) {
      map['identifier'] = Variable<String>(identifier.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiscoveredContactsCompanion(')
          ..write('id: $id, ')
          ..write('identifier: $identifier, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $DiscoveredContactsTable extends DiscoveredContacts
    with TableInfo<$DiscoveredContactsTable, DiscoveredContact> {
  final GeneratedDatabase _db;
  final String _alias;
  $DiscoveredContactsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _identifierMeta = const VerificationMeta('identifier');
  GeneratedTextColumn _identifier;
  @override
  GeneratedTextColumn get identifier => _identifier ??= _constructIdentifier();
  GeneratedTextColumn _constructIdentifier() {
    return GeneratedTextColumn('identifier', $tableName, false,
        maxTextLength: 17);
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, identifier, date];
  @override
  $DiscoveredContactsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'discovered_contacts';
  @override
  final String actualTableName = 'discovered_contacts';
  @override
  VerificationContext validateIntegrity(Insertable<DiscoveredContact> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('identifier')) {
      context.handle(
          _identifierMeta,
          identifier.isAcceptableOrUnknown(
              data['identifier'], _identifierMeta));
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiscoveredContact map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DiscoveredContact.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $DiscoveredContactsTable createAlias(String alias) {
    return $DiscoveredContactsTable(_db, alias);
  }
}

class DiscoveredContactEntry extends DataClass
    implements Insertable<DiscoveredContactEntry> {
  final int discoveredContact;
  final int exposureNotification;
  DiscoveredContactEntry(
      {@required this.discoveredContact, @required this.exposureNotification});
  factory DiscoveredContactEntry.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return DiscoveredContactEntry(
      discoveredContact: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}discovered_contact']),
      exposureNotification: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}exposure_notification']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || discoveredContact != null) {
      map['discovered_contact'] = Variable<int>(discoveredContact);
    }
    if (!nullToAbsent || exposureNotification != null) {
      map['exposure_notification'] = Variable<int>(exposureNotification);
    }
    return map;
  }

  DiscoveredContactEntriesCompanion toCompanion(bool nullToAbsent) {
    return DiscoveredContactEntriesCompanion(
      discoveredContact: discoveredContact == null && nullToAbsent
          ? const Value.absent()
          : Value(discoveredContact),
      exposureNotification: exposureNotification == null && nullToAbsent
          ? const Value.absent()
          : Value(exposureNotification),
    );
  }

  factory DiscoveredContactEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DiscoveredContactEntry(
      discoveredContact: serializer.fromJson<int>(json['discoveredContact']),
      exposureNotification:
          serializer.fromJson<int>(json['exposureNotification']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'discoveredContact': serializer.toJson<int>(discoveredContact),
      'exposureNotification': serializer.toJson<int>(exposureNotification),
    };
  }

  DiscoveredContactEntry copyWith(
          {int discoveredContact, int exposureNotification}) =>
      DiscoveredContactEntry(
        discoveredContact: discoveredContact ?? this.discoveredContact,
        exposureNotification: exposureNotification ?? this.exposureNotification,
      );
  @override
  String toString() {
    return (StringBuffer('DiscoveredContactEntry(')
          ..write('discoveredContact: $discoveredContact, ')
          ..write('exposureNotification: $exposureNotification')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(discoveredContact.hashCode, exposureNotification.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DiscoveredContactEntry &&
          other.discoveredContact == this.discoveredContact &&
          other.exposureNotification == this.exposureNotification);
}

class DiscoveredContactEntriesCompanion
    extends UpdateCompanion<DiscoveredContactEntry> {
  final Value<int> discoveredContact;
  final Value<int> exposureNotification;
  const DiscoveredContactEntriesCompanion({
    this.discoveredContact = const Value.absent(),
    this.exposureNotification = const Value.absent(),
  });
  DiscoveredContactEntriesCompanion.insert({
    @required int discoveredContact,
    @required int exposureNotification,
  })  : discoveredContact = Value(discoveredContact),
        exposureNotification = Value(exposureNotification);
  static Insertable<DiscoveredContactEntry> custom({
    Expression<int> discoveredContact,
    Expression<int> exposureNotification,
  }) {
    return RawValuesInsertable({
      if (discoveredContact != null) 'discovered_contact': discoveredContact,
      if (exposureNotification != null)
        'exposure_notification': exposureNotification,
    });
  }

  DiscoveredContactEntriesCompanion copyWith(
      {Value<int> discoveredContact, Value<int> exposureNotification}) {
    return DiscoveredContactEntriesCompanion(
      discoveredContact: discoveredContact ?? this.discoveredContact,
      exposureNotification: exposureNotification ?? this.exposureNotification,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (discoveredContact.present) {
      map['discovered_contact'] = Variable<int>(discoveredContact.value);
    }
    if (exposureNotification.present) {
      map['exposure_notification'] = Variable<int>(exposureNotification.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiscoveredContactEntriesCompanion(')
          ..write('discoveredContact: $discoveredContact, ')
          ..write('exposureNotification: $exposureNotification')
          ..write(')'))
        .toString();
  }
}

class $DiscoveredContactEntriesTable extends DiscoveredContactEntries
    with TableInfo<$DiscoveredContactEntriesTable, DiscoveredContactEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $DiscoveredContactEntriesTable(this._db, [this._alias]);
  final VerificationMeta _discoveredContactMeta =
      const VerificationMeta('discoveredContact');
  GeneratedIntColumn _discoveredContact;
  @override
  GeneratedIntColumn get discoveredContact =>
      _discoveredContact ??= _constructDiscoveredContact();
  GeneratedIntColumn _constructDiscoveredContact() {
    return GeneratedIntColumn(
      'discovered_contact',
      $tableName,
      false,
    );
  }

  final VerificationMeta _exposureNotificationMeta =
      const VerificationMeta('exposureNotification');
  GeneratedIntColumn _exposureNotification;
  @override
  GeneratedIntColumn get exposureNotification =>
      _exposureNotification ??= _constructExposureNotification();
  GeneratedIntColumn _constructExposureNotification() {
    return GeneratedIntColumn(
      'exposure_notification',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [discoveredContact, exposureNotification];
  @override
  $DiscoveredContactEntriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'discovered_contact_entries';
  @override
  final String actualTableName = 'discovered_contact_entries';
  @override
  VerificationContext validateIntegrity(
      Insertable<DiscoveredContactEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('discovered_contact')) {
      context.handle(
          _discoveredContactMeta,
          discoveredContact.isAcceptableOrUnknown(
              data['discovered_contact'], _discoveredContactMeta));
    } else if (isInserting) {
      context.missing(_discoveredContactMeta);
    }
    if (data.containsKey('exposure_notification')) {
      context.handle(
          _exposureNotificationMeta,
          exposureNotification.isAcceptableOrUnknown(
              data['exposure_notification'], _exposureNotificationMeta));
    } else if (isInserting) {
      context.missing(_exposureNotificationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  DiscoveredContactEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DiscoveredContactEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $DiscoveredContactEntriesTable createAlias(String alias) {
    return $DiscoveredContactEntriesTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ExposureNotificationsTable _exposureNotifications;
  $ExposureNotificationsTable get exposureNotifications =>
      _exposureNotifications ??= $ExposureNotificationsTable(this);
  $DiscoveredContactsTable _discoveredContacts;
  $DiscoveredContactsTable get discoveredContacts =>
      _discoveredContacts ??= $DiscoveredContactsTable(this);
  $DiscoveredContactEntriesTable _discoveredContactEntries;
  $DiscoveredContactEntriesTable get discoveredContactEntries =>
      _discoveredContactEntries ??= $DiscoveredContactEntriesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [exposureNotifications, discoveredContacts, discoveredContactEntries];
}
