// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PersonsTable extends Persons with TableInfo<$PersonsTable, PersonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncStatus>($PersonsTable.$convertersyncStatus);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relationMeta = const VerificationMeta(
    'relation',
  );
  @override
  late final GeneratedColumn<String> relation = GeneratedColumn<String>(
    'relation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSelfMeta = const VerificationMeta('isSelf');
  @override
  late final GeneratedColumn<bool> isSelf = GeneratedColumn<bool>(
    'is_self',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_self" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    createdAt,
    updatedAt,
    syncStatus,
    id,
    name,
    relation,
    phone,
    notes,
    isSelf,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persons';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('relation')) {
      context.handle(
        _relationMeta,
        relation.isAcceptableOrUnknown(data['relation']!, _relationMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_self')) {
      context.handle(
        _isSelfMeta,
        isSelf.isAcceptableOrUnknown(data['is_self']!, _isSelfMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonRow(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: $PersonsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      relation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isSelf: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_self'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $PersonsTable createAlias(String alias) {
    return $PersonsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class PersonRow extends DataClass implements Insertable<PersonRow> {
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String id;
  final String name;
  final String relation;
  final String? phone;
  final String? notes;
  final bool isSelf;
  final bool archived;
  const PersonRow({
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.id,
    required this.name,
    required this.relation,
    this.phone,
    this.notes,
    required this.isSelf,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
        $PersonsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['relation'] = Variable<String>(relation);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_self'] = Variable<bool>(isSelf);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  PersonsCompanion toCompanion(bool nullToAbsent) {
    return PersonsCompanion(
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      id: Value(id),
      name: Value(name),
      relation: Value(relation),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isSelf: Value(isSelf),
      archived: Value(archived),
    );
  }

  factory PersonRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonRow(
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $PersonsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      relation: serializer.fromJson<String>(json['relation']),
      phone: serializer.fromJson<String?>(json['phone']),
      notes: serializer.fromJson<String?>(json['notes']),
      isSelf: serializer.fromJson<bool>(json['isSelf']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
        $PersonsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'relation': serializer.toJson<String>(relation),
      'phone': serializer.toJson<String?>(phone),
      'notes': serializer.toJson<String?>(notes),
      'isSelf': serializer.toJson<bool>(isSelf),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  PersonRow copyWith({
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    String? id,
    String? name,
    String? relation,
    Value<String?> phone = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isSelf,
    bool? archived,
  }) => PersonRow(
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    id: id ?? this.id,
    name: name ?? this.name,
    relation: relation ?? this.relation,
    phone: phone.present ? phone.value : this.phone,
    notes: notes.present ? notes.value : this.notes,
    isSelf: isSelf ?? this.isSelf,
    archived: archived ?? this.archived,
  );
  PersonRow copyWithCompanion(PersonsCompanion data) {
    return PersonRow(
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      relation: data.relation.present ? data.relation.value : this.relation,
      phone: data.phone.present ? data.phone.value : this.phone,
      notes: data.notes.present ? data.notes.value : this.notes,
      isSelf: data.isSelf.present ? data.isSelf.value : this.isSelf,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonRow(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('relation: $relation, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes, ')
          ..write('isSelf: $isSelf, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    version,
    createdAt,
    updatedAt,
    syncStatus,
    id,
    name,
    relation,
    phone,
    notes,
    isSelf,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonRow &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.id == this.id &&
          other.name == this.name &&
          other.relation == this.relation &&
          other.phone == this.phone &&
          other.notes == this.notes &&
          other.isSelf == this.isSelf &&
          other.archived == this.archived);
}

class PersonsCompanion extends UpdateCompanion<PersonRow> {
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String> id;
  final Value<String> name;
  final Value<String> relation;
  final Value<String?> phone;
  final Value<String?> notes;
  final Value<bool> isSelf;
  final Value<bool> archived;
  final Value<int> rowid;
  const PersonsCompanion({
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.relation = const Value.absent(),
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSelf = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonsCompanion.insert({
    this.version = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    required String id,
    required String name,
    this.relation = const Value.absent(),
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSelf = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       id = Value(id),
       name = Value(name);
  static Insertable<PersonRow> custom({
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? relation,
    Expression<String>? phone,
    Expression<String>? notes,
    Expression<bool>? isSelf,
    Expression<bool>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (relation != null) 'relation': relation,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      if (isSelf != null) 'is_self': isSelf,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonsCompanion copyWith({
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<SyncStatus>? syncStatus,
    Value<String>? id,
    Value<String>? name,
    Value<String>? relation,
    Value<String?>? phone,
    Value<String?>? notes,
    Value<bool>? isSelf,
    Value<bool>? archived,
    Value<int>? rowid,
  }) {
    return PersonsCompanion(
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      id: id ?? this.id,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      isSelf: isSelf ?? this.isSelf,
      archived: archived ?? this.archived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $PersonsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (relation.present) {
      map['relation'] = Variable<String>(relation.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isSelf.present) {
      map['is_self'] = Variable<bool>(isSelf.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsCompanion(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('relation: $relation, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes, ')
          ..write('isSelf: $isSelf, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FundsTable extends Funds with TableInfo<$FundsTable, FundRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncStatus>($FundsTable.$convertersyncStatus);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FundKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FundKind>($FundsTable.$converterkind);
  static const VerificationMeta _ownerPersonIdMeta = const VerificationMeta(
    'ownerPersonId',
  );
  @override
  late final GeneratedColumn<String> ownerPersonId = GeneratedColumn<String>(
    'owner_person_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id)',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    createdAt,
    updatedAt,
    syncStatus,
    id,
    name,
    kind,
    ownerPersonId,
    description,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'funds';
  @override
  VerificationContext validateIntegrity(
    Insertable<FundRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('owner_person_id')) {
      context.handle(
        _ownerPersonIdMeta,
        ownerPersonId.isAcceptableOrUnknown(
          data['owner_person_id']!,
          _ownerPersonIdMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FundRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FundRow(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: $FundsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $FundsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      ownerPersonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_person_id'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $FundsTable createAlias(String alias) {
    return $FundsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
  static JsonTypeConverter2<FundKind, String, String> $converterkind =
      const EnumNameConverter<FundKind>(FundKind.values);
}

class FundRow extends DataClass implements Insertable<FundRow> {
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String id;
  final String name;
  final FundKind kind;
  final String? ownerPersonId;
  final String? description;
  final bool archived;
  const FundRow({
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.id,
    required this.name,
    required this.kind,
    this.ownerPersonId,
    this.description,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
        $FundsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>($FundsTable.$converterkind.toSql(kind));
    }
    if (!nullToAbsent || ownerPersonId != null) {
      map['owner_person_id'] = Variable<String>(ownerPersonId);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  FundsCompanion toCompanion(bool nullToAbsent) {
    return FundsCompanion(
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      ownerPersonId: ownerPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerPersonId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      archived: Value(archived),
    );
  }

  factory FundRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FundRow(
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $FundsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $FundsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      ownerPersonId: serializer.fromJson<String?>(json['ownerPersonId']),
      description: serializer.fromJson<String?>(json['description']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
        $FundsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(
        $FundsTable.$converterkind.toJson(kind),
      ),
      'ownerPersonId': serializer.toJson<String?>(ownerPersonId),
      'description': serializer.toJson<String?>(description),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  FundRow copyWith({
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    String? id,
    String? name,
    FundKind? kind,
    Value<String?> ownerPersonId = const Value.absent(),
    Value<String?> description = const Value.absent(),
    bool? archived,
  }) => FundRow(
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    ownerPersonId: ownerPersonId.present
        ? ownerPersonId.value
        : this.ownerPersonId,
    description: description.present ? description.value : this.description,
    archived: archived ?? this.archived,
  );
  FundRow copyWithCompanion(FundsCompanion data) {
    return FundRow(
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      ownerPersonId: data.ownerPersonId.present
          ? data.ownerPersonId.value
          : this.ownerPersonId,
      description: data.description.present
          ? data.description.value
          : this.description,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FundRow(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('ownerPersonId: $ownerPersonId, ')
          ..write('description: $description, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    version,
    createdAt,
    updatedAt,
    syncStatus,
    id,
    name,
    kind,
    ownerPersonId,
    description,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FundRow &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.ownerPersonId == this.ownerPersonId &&
          other.description == this.description &&
          other.archived == this.archived);
}

class FundsCompanion extends UpdateCompanion<FundRow> {
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String> id;
  final Value<String> name;
  final Value<FundKind> kind;
  final Value<String?> ownerPersonId;
  final Value<String?> description;
  final Value<bool> archived;
  final Value<int> rowid;
  const FundsCompanion({
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.ownerPersonId = const Value.absent(),
    this.description = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FundsCompanion.insert({
    this.version = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    required String id,
    required String name,
    required FundKind kind,
    this.ownerPersonId = const Value.absent(),
    this.description = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       id = Value(id),
       name = Value(name),
       kind = Value(kind);
  static Insertable<FundRow> custom({
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? ownerPersonId,
    Expression<String>? description,
    Expression<bool>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (ownerPersonId != null) 'owner_person_id': ownerPersonId,
      if (description != null) 'description': description,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FundsCompanion copyWith({
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<SyncStatus>? syncStatus,
    Value<String>? id,
    Value<String>? name,
    Value<FundKind>? kind,
    Value<String?>? ownerPersonId,
    Value<String?>? description,
    Value<bool>? archived,
    Value<int>? rowid,
  }) {
    return FundsCompanion(
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      ownerPersonId: ownerPersonId ?? this.ownerPersonId,
      description: description ?? this.description,
      archived: archived ?? this.archived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $FundsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $FundsTable.$converterkind.toSql(kind.value),
      );
    }
    if (ownerPersonId.present) {
      map['owner_person_id'] = Variable<String>(ownerPersonId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FundsCompanion(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('ownerPersonId: $ownerPersonId, ')
          ..write('description: $description, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LedgerAccountsTable extends LedgerAccounts
    with TableInfo<$LedgerAccountsTable, LedgerAccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncStatus>($LedgerAccountsTable.$convertersyncStatus);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LedgerAccountKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LedgerAccountKind>($LedgerAccountsTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<AccountClass, String>
  accountClass = GeneratedColumn<String>(
    'account_class',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<AccountClass>($LedgerAccountsTable.$converteraccountClass);
  @override
  late final GeneratedColumnWithTypeConverter<StorageType?, String>
  storageType = GeneratedColumn<String>(
    'storage_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<StorageType?>($LedgerAccountsTable.$converterstorageTypen);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameBnMeta = const VerificationMeta('nameBn');
  @override
  late final GeneratedColumn<String> nameBn = GeneratedColumn<String>(
    'name_bn',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _institutionMeta = const VerificationMeta(
    'institution',
  );
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
    'institution',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numberHintMeta = const VerificationMeta(
    'numberHint',
  );
  @override
  late final GeneratedColumn<String> numberHint = GeneratedColumn<String>(
    'number_hint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    createdAt,
    updatedAt,
    syncStatus,
    id,
    kind,
    accountClass,
    storageType,
    name,
    nameBn,
    institution,
    numberHint,
    icon,
    isSystem,
    archived,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LedgerAccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_bn')) {
      context.handle(
        _nameBnMeta,
        nameBn.isAcceptableOrUnknown(data['name_bn']!, _nameBnMeta),
      );
    }
    if (data.containsKey('institution')) {
      context.handle(
        _institutionMeta,
        institution.isAcceptableOrUnknown(
          data['institution']!,
          _institutionMeta,
        ),
      );
    }
    if (data.containsKey('number_hint')) {
      context.handle(
        _numberHintMeta,
        numberHint.isAcceptableOrUnknown(data['number_hint']!, _numberHintMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LedgerAccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerAccountRow(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: $LedgerAccountsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: $LedgerAccountsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      accountClass: $LedgerAccountsTable.$converteraccountClass.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}account_class'],
        )!,
      ),
      storageType: $LedgerAccountsTable.$converterstorageTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}storage_type'],
        ),
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameBn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_bn'],
      ),
      institution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution'],
      ),
      numberHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number_hint'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $LedgerAccountsTable createAlias(String alias) {
    return $LedgerAccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
  static JsonTypeConverter2<LedgerAccountKind, String, String> $converterkind =
      const EnumNameConverter<LedgerAccountKind>(LedgerAccountKind.values);
  static JsonTypeConverter2<AccountClass, String, String>
  $converteraccountClass = const EnumNameConverter<AccountClass>(
    AccountClass.values,
  );
  static JsonTypeConverter2<StorageType, String, String> $converterstorageType =
      const EnumNameConverter<StorageType>(StorageType.values);
  static JsonTypeConverter2<StorageType?, String?, String?>
  $converterstorageTypen = JsonTypeConverter2.asNullable($converterstorageType);
}

class LedgerAccountRow extends DataClass
    implements Insertable<LedgerAccountRow> {
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String id;
  final LedgerAccountKind kind;
  final AccountClass accountClass;
  final StorageType? storageType;
  final String name;
  final String? nameBn;
  final String? institution;

  /// Only the last digits are ever stored, never a full account number.
  final String? numberHint;
  final String? icon;
  final bool isSystem;
  final bool archived;
  final int sortOrder;
  const LedgerAccountRow({
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.id,
    required this.kind,
    required this.accountClass,
    this.storageType,
    required this.name,
    this.nameBn,
    this.institution,
    this.numberHint,
    this.icon,
    required this.isSystem,
    required this.archived,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
        $LedgerAccountsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['id'] = Variable<String>(id);
    {
      map['kind'] = Variable<String>(
        $LedgerAccountsTable.$converterkind.toSql(kind),
      );
    }
    {
      map['account_class'] = Variable<String>(
        $LedgerAccountsTable.$converteraccountClass.toSql(accountClass),
      );
    }
    if (!nullToAbsent || storageType != null) {
      map['storage_type'] = Variable<String>(
        $LedgerAccountsTable.$converterstorageTypen.toSql(storageType),
      );
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameBn != null) {
      map['name_bn'] = Variable<String>(nameBn);
    }
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    if (!nullToAbsent || numberHint != null) {
      map['number_hint'] = Variable<String>(numberHint);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['is_system'] = Variable<bool>(isSystem);
    map['archived'] = Variable<bool>(archived);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  LedgerAccountsCompanion toCompanion(bool nullToAbsent) {
    return LedgerAccountsCompanion(
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      id: Value(id),
      kind: Value(kind),
      accountClass: Value(accountClass),
      storageType: storageType == null && nullToAbsent
          ? const Value.absent()
          : Value(storageType),
      name: Value(name),
      nameBn: nameBn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameBn),
      institution: institution == null && nullToAbsent
          ? const Value.absent()
          : Value(institution),
      numberHint: numberHint == null && nullToAbsent
          ? const Value.absent()
          : Value(numberHint),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      isSystem: Value(isSystem),
      archived: Value(archived),
      sortOrder: Value(sortOrder),
    );
  }

  factory LedgerAccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerAccountRow(
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $LedgerAccountsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      id: serializer.fromJson<String>(json['id']),
      kind: $LedgerAccountsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      accountClass: $LedgerAccountsTable.$converteraccountClass.fromJson(
        serializer.fromJson<String>(json['accountClass']),
      ),
      storageType: $LedgerAccountsTable.$converterstorageTypen.fromJson(
        serializer.fromJson<String?>(json['storageType']),
      ),
      name: serializer.fromJson<String>(json['name']),
      nameBn: serializer.fromJson<String?>(json['nameBn']),
      institution: serializer.fromJson<String?>(json['institution']),
      numberHint: serializer.fromJson<String?>(json['numberHint']),
      icon: serializer.fromJson<String?>(json['icon']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      archived: serializer.fromJson<bool>(json['archived']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
        $LedgerAccountsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(
        $LedgerAccountsTable.$converterkind.toJson(kind),
      ),
      'accountClass': serializer.toJson<String>(
        $LedgerAccountsTable.$converteraccountClass.toJson(accountClass),
      ),
      'storageType': serializer.toJson<String?>(
        $LedgerAccountsTable.$converterstorageTypen.toJson(storageType),
      ),
      'name': serializer.toJson<String>(name),
      'nameBn': serializer.toJson<String?>(nameBn),
      'institution': serializer.toJson<String?>(institution),
      'numberHint': serializer.toJson<String?>(numberHint),
      'icon': serializer.toJson<String?>(icon),
      'isSystem': serializer.toJson<bool>(isSystem),
      'archived': serializer.toJson<bool>(archived),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  LedgerAccountRow copyWith({
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    String? id,
    LedgerAccountKind? kind,
    AccountClass? accountClass,
    Value<StorageType?> storageType = const Value.absent(),
    String? name,
    Value<String?> nameBn = const Value.absent(),
    Value<String?> institution = const Value.absent(),
    Value<String?> numberHint = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    bool? isSystem,
    bool? archived,
    int? sortOrder,
  }) => LedgerAccountRow(
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    id: id ?? this.id,
    kind: kind ?? this.kind,
    accountClass: accountClass ?? this.accountClass,
    storageType: storageType.present ? storageType.value : this.storageType,
    name: name ?? this.name,
    nameBn: nameBn.present ? nameBn.value : this.nameBn,
    institution: institution.present ? institution.value : this.institution,
    numberHint: numberHint.present ? numberHint.value : this.numberHint,
    icon: icon.present ? icon.value : this.icon,
    isSystem: isSystem ?? this.isSystem,
    archived: archived ?? this.archived,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  LedgerAccountRow copyWithCompanion(LedgerAccountsCompanion data) {
    return LedgerAccountRow(
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      accountClass: data.accountClass.present
          ? data.accountClass.value
          : this.accountClass,
      storageType: data.storageType.present
          ? data.storageType.value
          : this.storageType,
      name: data.name.present ? data.name.value : this.name,
      nameBn: data.nameBn.present ? data.nameBn.value : this.nameBn,
      institution: data.institution.present
          ? data.institution.value
          : this.institution,
      numberHint: data.numberHint.present
          ? data.numberHint.value
          : this.numberHint,
      icon: data.icon.present ? data.icon.value : this.icon,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      archived: data.archived.present ? data.archived.value : this.archived,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LedgerAccountRow(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('accountClass: $accountClass, ')
          ..write('storageType: $storageType, ')
          ..write('name: $name, ')
          ..write('nameBn: $nameBn, ')
          ..write('institution: $institution, ')
          ..write('numberHint: $numberHint, ')
          ..write('icon: $icon, ')
          ..write('isSystem: $isSystem, ')
          ..write('archived: $archived, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    version,
    createdAt,
    updatedAt,
    syncStatus,
    id,
    kind,
    accountClass,
    storageType,
    name,
    nameBn,
    institution,
    numberHint,
    icon,
    isSystem,
    archived,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerAccountRow &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.accountClass == this.accountClass &&
          other.storageType == this.storageType &&
          other.name == this.name &&
          other.nameBn == this.nameBn &&
          other.institution == this.institution &&
          other.numberHint == this.numberHint &&
          other.icon == this.icon &&
          other.isSystem == this.isSystem &&
          other.archived == this.archived &&
          other.sortOrder == this.sortOrder);
}

class LedgerAccountsCompanion extends UpdateCompanion<LedgerAccountRow> {
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String> id;
  final Value<LedgerAccountKind> kind;
  final Value<AccountClass> accountClass;
  final Value<StorageType?> storageType;
  final Value<String> name;
  final Value<String?> nameBn;
  final Value<String?> institution;
  final Value<String?> numberHint;
  final Value<String?> icon;
  final Value<bool> isSystem;
  final Value<bool> archived;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const LedgerAccountsCompanion({
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.accountClass = const Value.absent(),
    this.storageType = const Value.absent(),
    this.name = const Value.absent(),
    this.nameBn = const Value.absent(),
    this.institution = const Value.absent(),
    this.numberHint = const Value.absent(),
    this.icon = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.archived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LedgerAccountsCompanion.insert({
    this.version = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    required String id,
    required LedgerAccountKind kind,
    required AccountClass accountClass,
    this.storageType = const Value.absent(),
    required String name,
    this.nameBn = const Value.absent(),
    this.institution = const Value.absent(),
    this.numberHint = const Value.absent(),
    this.icon = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.archived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       id = Value(id),
       kind = Value(kind),
       accountClass = Value(accountClass),
       name = Value(name);
  static Insertable<LedgerAccountRow> custom({
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? accountClass,
    Expression<String>? storageType,
    Expression<String>? name,
    Expression<String>? nameBn,
    Expression<String>? institution,
    Expression<String>? numberHint,
    Expression<String>? icon,
    Expression<bool>? isSystem,
    Expression<bool>? archived,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (accountClass != null) 'account_class': accountClass,
      if (storageType != null) 'storage_type': storageType,
      if (name != null) 'name': name,
      if (nameBn != null) 'name_bn': nameBn,
      if (institution != null) 'institution': institution,
      if (numberHint != null) 'number_hint': numberHint,
      if (icon != null) 'icon': icon,
      if (isSystem != null) 'is_system': isSystem,
      if (archived != null) 'archived': archived,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LedgerAccountsCompanion copyWith({
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<SyncStatus>? syncStatus,
    Value<String>? id,
    Value<LedgerAccountKind>? kind,
    Value<AccountClass>? accountClass,
    Value<StorageType?>? storageType,
    Value<String>? name,
    Value<String?>? nameBn,
    Value<String?>? institution,
    Value<String?>? numberHint,
    Value<String?>? icon,
    Value<bool>? isSystem,
    Value<bool>? archived,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return LedgerAccountsCompanion(
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      id: id ?? this.id,
      kind: kind ?? this.kind,
      accountClass: accountClass ?? this.accountClass,
      storageType: storageType ?? this.storageType,
      name: name ?? this.name,
      nameBn: nameBn ?? this.nameBn,
      institution: institution ?? this.institution,
      numberHint: numberHint ?? this.numberHint,
      icon: icon ?? this.icon,
      isSystem: isSystem ?? this.isSystem,
      archived: archived ?? this.archived,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $LedgerAccountsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $LedgerAccountsTable.$converterkind.toSql(kind.value),
      );
    }
    if (accountClass.present) {
      map['account_class'] = Variable<String>(
        $LedgerAccountsTable.$converteraccountClass.toSql(accountClass.value),
      );
    }
    if (storageType.present) {
      map['storage_type'] = Variable<String>(
        $LedgerAccountsTable.$converterstorageTypen.toSql(storageType.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameBn.present) {
      map['name_bn'] = Variable<String>(nameBn.value);
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (numberHint.present) {
      map['number_hint'] = Variable<String>(numberHint.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerAccountsCompanion(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('accountClass: $accountClass, ')
          ..write('storageType: $storageType, ')
          ..write('name: $name, ')
          ..write('nameBn: $nameBn, ')
          ..write('institution: $institution, ')
          ..write('numberHint: $numberHint, ')
          ..write('icon: $icon, ')
          ..write('isSystem: $isSystem, ')
          ..write('archived: $archived, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ObligationsTable extends Obligations
    with TableInfo<$ObligationsTable, ObligationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ObligationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncStatus>($ObligationsTable.$convertersyncStatus);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ObligationKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ObligationKind>($ObligationsTable.$converterkind);
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
    'person_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id)',
    ),
  );
  static const VerificationMeta _fundIdMeta = const VerificationMeta('fundId');
  @override
  late final GeneratedColumn<String> fundId = GeneratedColumn<String>(
    'fund_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES funds (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _openedOnMeta = const VerificationMeta(
    'openedOn',
  );
  @override
  late final GeneratedColumn<int> openedOn = GeneratedColumn<int>(
    'opened_on',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueOnMeta = const VerificationMeta('dueOn');
  @override
  late final GeneratedColumn<int> dueOn = GeneratedColumn<int>(
    'due_on',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ObligationStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('open'),
      ).withConverter<ObligationStatus>($ObligationsTable.$converterstatus);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    createdAt,
    updatedAt,
    syncStatus,
    id,
    kind,
    personId,
    fundId,
    title,
    openedOn,
    dueOn,
    status,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'obligations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ObligationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('fund_id')) {
      context.handle(
        _fundIdMeta,
        fundId.isAcceptableOrUnknown(data['fund_id']!, _fundIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fundIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('opened_on')) {
      context.handle(
        _openedOnMeta,
        openedOn.isAcceptableOrUnknown(data['opened_on']!, _openedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_openedOnMeta);
    }
    if (data.containsKey('due_on')) {
      context.handle(
        _dueOnMeta,
        dueOn.isAcceptableOrUnknown(data['due_on']!, _dueOnMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ObligationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ObligationRow(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: $ObligationsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: $ObligationsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_id'],
      )!,
      fundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fund_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      openedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opened_on'],
      )!,
      dueOn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_on'],
      ),
      status: $ObligationsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ObligationsTable createAlias(String alias) {
    return $ObligationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
  static JsonTypeConverter2<ObligationKind, String, String> $converterkind =
      const EnumNameConverter<ObligationKind>(ObligationKind.values);
  static JsonTypeConverter2<ObligationStatus, String, String> $converterstatus =
      const EnumNameConverter<ObligationStatus>(ObligationStatus.values);
}

class ObligationRow extends DataClass implements Insertable<ObligationRow> {
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String id;
  final ObligationKind kind;
  final String personId;
  final String fundId;
  final String? title;
  final int openedOn;
  final int? dueOn;
  final ObligationStatus status;
  final String? notes;
  const ObligationRow({
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.id,
    required this.kind,
    required this.personId,
    required this.fundId,
    this.title,
    required this.openedOn,
    this.dueOn,
    required this.status,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
        $ObligationsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['id'] = Variable<String>(id);
    {
      map['kind'] = Variable<String>(
        $ObligationsTable.$converterkind.toSql(kind),
      );
    }
    map['person_id'] = Variable<String>(personId);
    map['fund_id'] = Variable<String>(fundId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['opened_on'] = Variable<int>(openedOn);
    if (!nullToAbsent || dueOn != null) {
      map['due_on'] = Variable<int>(dueOn);
    }
    {
      map['status'] = Variable<String>(
        $ObligationsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ObligationsCompanion toCompanion(bool nullToAbsent) {
    return ObligationsCompanion(
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      id: Value(id),
      kind: Value(kind),
      personId: Value(personId),
      fundId: Value(fundId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      openedOn: Value(openedOn),
      dueOn: dueOn == null && nullToAbsent
          ? const Value.absent()
          : Value(dueOn),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory ObligationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ObligationRow(
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $ObligationsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      id: serializer.fromJson<String>(json['id']),
      kind: $ObligationsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      personId: serializer.fromJson<String>(json['personId']),
      fundId: serializer.fromJson<String>(json['fundId']),
      title: serializer.fromJson<String?>(json['title']),
      openedOn: serializer.fromJson<int>(json['openedOn']),
      dueOn: serializer.fromJson<int?>(json['dueOn']),
      status: $ObligationsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
        $ObligationsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(
        $ObligationsTable.$converterkind.toJson(kind),
      ),
      'personId': serializer.toJson<String>(personId),
      'fundId': serializer.toJson<String>(fundId),
      'title': serializer.toJson<String?>(title),
      'openedOn': serializer.toJson<int>(openedOn),
      'dueOn': serializer.toJson<int?>(dueOn),
      'status': serializer.toJson<String>(
        $ObligationsTable.$converterstatus.toJson(status),
      ),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ObligationRow copyWith({
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    String? id,
    ObligationKind? kind,
    String? personId,
    String? fundId,
    Value<String?> title = const Value.absent(),
    int? openedOn,
    Value<int?> dueOn = const Value.absent(),
    ObligationStatus? status,
    Value<String?> notes = const Value.absent(),
  }) => ObligationRow(
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    id: id ?? this.id,
    kind: kind ?? this.kind,
    personId: personId ?? this.personId,
    fundId: fundId ?? this.fundId,
    title: title.present ? title.value : this.title,
    openedOn: openedOn ?? this.openedOn,
    dueOn: dueOn.present ? dueOn.value : this.dueOn,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
  );
  ObligationRow copyWithCompanion(ObligationsCompanion data) {
    return ObligationRow(
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      personId: data.personId.present ? data.personId.value : this.personId,
      fundId: data.fundId.present ? data.fundId.value : this.fundId,
      title: data.title.present ? data.title.value : this.title,
      openedOn: data.openedOn.present ? data.openedOn.value : this.openedOn,
      dueOn: data.dueOn.present ? data.dueOn.value : this.dueOn,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ObligationRow(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('personId: $personId, ')
          ..write('fundId: $fundId, ')
          ..write('title: $title, ')
          ..write('openedOn: $openedOn, ')
          ..write('dueOn: $dueOn, ')
          ..write('status: $status, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    version,
    createdAt,
    updatedAt,
    syncStatus,
    id,
    kind,
    personId,
    fundId,
    title,
    openedOn,
    dueOn,
    status,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ObligationRow &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.personId == this.personId &&
          other.fundId == this.fundId &&
          other.title == this.title &&
          other.openedOn == this.openedOn &&
          other.dueOn == this.dueOn &&
          other.status == this.status &&
          other.notes == this.notes);
}

class ObligationsCompanion extends UpdateCompanion<ObligationRow> {
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String> id;
  final Value<ObligationKind> kind;
  final Value<String> personId;
  final Value<String> fundId;
  final Value<String?> title;
  final Value<int> openedOn;
  final Value<int?> dueOn;
  final Value<ObligationStatus> status;
  final Value<String?> notes;
  final Value<int> rowid;
  const ObligationsCompanion({
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.personId = const Value.absent(),
    this.fundId = const Value.absent(),
    this.title = const Value.absent(),
    this.openedOn = const Value.absent(),
    this.dueOn = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ObligationsCompanion.insert({
    this.version = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    required String id,
    required ObligationKind kind,
    required String personId,
    required String fundId,
    this.title = const Value.absent(),
    required int openedOn,
    this.dueOn = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       id = Value(id),
       kind = Value(kind),
       personId = Value(personId),
       fundId = Value(fundId),
       openedOn = Value(openedOn);
  static Insertable<ObligationRow> custom({
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? personId,
    Expression<String>? fundId,
    Expression<String>? title,
    Expression<int>? openedOn,
    Expression<int>? dueOn,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (personId != null) 'person_id': personId,
      if (fundId != null) 'fund_id': fundId,
      if (title != null) 'title': title,
      if (openedOn != null) 'opened_on': openedOn,
      if (dueOn != null) 'due_on': dueOn,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ObligationsCompanion copyWith({
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<SyncStatus>? syncStatus,
    Value<String>? id,
    Value<ObligationKind>? kind,
    Value<String>? personId,
    Value<String>? fundId,
    Value<String?>? title,
    Value<int>? openedOn,
    Value<int?>? dueOn,
    Value<ObligationStatus>? status,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return ObligationsCompanion(
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      id: id ?? this.id,
      kind: kind ?? this.kind,
      personId: personId ?? this.personId,
      fundId: fundId ?? this.fundId,
      title: title ?? this.title,
      openedOn: openedOn ?? this.openedOn,
      dueOn: dueOn ?? this.dueOn,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $ObligationsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $ObligationsTable.$converterkind.toSql(kind.value),
      );
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (fundId.present) {
      map['fund_id'] = Variable<String>(fundId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (openedOn.present) {
      map['opened_on'] = Variable<int>(openedOn.value);
    }
    if (dueOn.present) {
      map['due_on'] = Variable<int>(dueOn.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ObligationsTable.$converterstatus.toSql(status.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObligationsCompanion(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('personId: $personId, ')
          ..write('fundId: $fundId, ')
          ..write('title: $title, ')
          ..write('openedOn: $openedOn, ')
          ..write('dueOn: $dueOn, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SamitiesTable extends Samities
    with TableInfo<$SamitiesTable, SamityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SamitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncStatus>($SamitiesTable.$convertersyncStatus);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SamityMode, String> mode =
      GeneratedColumn<String>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SamityMode>($SamitiesTable.$convertermode);
  static const VerificationMeta _fundIdMeta = const VerificationMeta('fundId');
  @override
  late final GeneratedColumn<String> fundId = GeneratedColumn<String>(
    'fund_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES funds (id)',
    ),
  );
  static const VerificationMeta _contributionAmountMeta =
      const VerificationMeta('contributionAmount');
  @override
  late final GeneratedColumn<int> contributionAmount = GeneratedColumn<int>(
    'contribution_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('monthly'),
  );
  static const VerificationMeta _startOnMeta = const VerificationMeta(
    'startOn',
  );
  @override
  late final GeneratedColumn<int> startOn = GeneratedColumn<int>(
    'start_on',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    createdAt,
    updatedAt,
    syncStatus,
    id,
    name,
    mode,
    fundId,
    contributionAmount,
    frequency,
    startOn,
    notes,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'samities';
  @override
  VerificationContext validateIntegrity(
    Insertable<SamityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('fund_id')) {
      context.handle(
        _fundIdMeta,
        fundId.isAcceptableOrUnknown(data['fund_id']!, _fundIdMeta),
      );
    }
    if (data.containsKey('contribution_amount')) {
      context.handle(
        _contributionAmountMeta,
        contributionAmount.isAcceptableOrUnknown(
          data['contribution_amount']!,
          _contributionAmountMeta,
        ),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    if (data.containsKey('start_on')) {
      context.handle(
        _startOnMeta,
        startOn.isAcceptableOrUnknown(data['start_on']!, _startOnMeta),
      );
    } else if (isInserting) {
      context.missing(_startOnMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SamityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SamityRow(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: $SamitiesTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      mode: $SamitiesTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mode'],
        )!,
      ),
      fundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fund_id'],
      ),
      contributionAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contribution_amount'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      startOn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_on'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $SamitiesTable createAlias(String alias) {
    return $SamitiesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
  static JsonTypeConverter2<SamityMode, String, String> $convertermode =
      const EnumNameConverter<SamityMode>(SamityMode.values);
}

class SamityRow extends DataClass implements Insertable<SamityRow> {
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String id;
  final String name;
  final SamityMode mode;
  final String? fundId;
  final int contributionAmount;

  /// `monthly` or `weekly`.
  final String frequency;
  final int startOn;
  final String? notes;
  final bool archived;
  const SamityRow({
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.id,
    required this.name,
    required this.mode,
    this.fundId,
    required this.contributionAmount,
    required this.frequency,
    required this.startOn,
    this.notes,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
        $SamitiesTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['mode'] = Variable<String>($SamitiesTable.$convertermode.toSql(mode));
    }
    if (!nullToAbsent || fundId != null) {
      map['fund_id'] = Variable<String>(fundId);
    }
    map['contribution_amount'] = Variable<int>(contributionAmount);
    map['frequency'] = Variable<String>(frequency);
    map['start_on'] = Variable<int>(startOn);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  SamitiesCompanion toCompanion(bool nullToAbsent) {
    return SamitiesCompanion(
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      id: Value(id),
      name: Value(name),
      mode: Value(mode),
      fundId: fundId == null && nullToAbsent
          ? const Value.absent()
          : Value(fundId),
      contributionAmount: Value(contributionAmount),
      frequency: Value(frequency),
      startOn: Value(startOn),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      archived: Value(archived),
    );
  }

  factory SamityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SamityRow(
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $SamitiesTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mode: $SamitiesTable.$convertermode.fromJson(
        serializer.fromJson<String>(json['mode']),
      ),
      fundId: serializer.fromJson<String?>(json['fundId']),
      contributionAmount: serializer.fromJson<int>(json['contributionAmount']),
      frequency: serializer.fromJson<String>(json['frequency']),
      startOn: serializer.fromJson<int>(json['startOn']),
      notes: serializer.fromJson<String?>(json['notes']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
        $SamitiesTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'mode': serializer.toJson<String>(
        $SamitiesTable.$convertermode.toJson(mode),
      ),
      'fundId': serializer.toJson<String?>(fundId),
      'contributionAmount': serializer.toJson<int>(contributionAmount),
      'frequency': serializer.toJson<String>(frequency),
      'startOn': serializer.toJson<int>(startOn),
      'notes': serializer.toJson<String?>(notes),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  SamityRow copyWith({
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    String? id,
    String? name,
    SamityMode? mode,
    Value<String?> fundId = const Value.absent(),
    int? contributionAmount,
    String? frequency,
    int? startOn,
    Value<String?> notes = const Value.absent(),
    bool? archived,
  }) => SamityRow(
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    id: id ?? this.id,
    name: name ?? this.name,
    mode: mode ?? this.mode,
    fundId: fundId.present ? fundId.value : this.fundId,
    contributionAmount: contributionAmount ?? this.contributionAmount,
    frequency: frequency ?? this.frequency,
    startOn: startOn ?? this.startOn,
    notes: notes.present ? notes.value : this.notes,
    archived: archived ?? this.archived,
  );
  SamityRow copyWithCompanion(SamitiesCompanion data) {
    return SamityRow(
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mode: data.mode.present ? data.mode.value : this.mode,
      fundId: data.fundId.present ? data.fundId.value : this.fundId,
      contributionAmount: data.contributionAmount.present
          ? data.contributionAmount.value
          : this.contributionAmount,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      startOn: data.startOn.present ? data.startOn.value : this.startOn,
      notes: data.notes.present ? data.notes.value : this.notes,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SamityRow(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mode: $mode, ')
          ..write('fundId: $fundId, ')
          ..write('contributionAmount: $contributionAmount, ')
          ..write('frequency: $frequency, ')
          ..write('startOn: $startOn, ')
          ..write('notes: $notes, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    version,
    createdAt,
    updatedAt,
    syncStatus,
    id,
    name,
    mode,
    fundId,
    contributionAmount,
    frequency,
    startOn,
    notes,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SamityRow &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.id == this.id &&
          other.name == this.name &&
          other.mode == this.mode &&
          other.fundId == this.fundId &&
          other.contributionAmount == this.contributionAmount &&
          other.frequency == this.frequency &&
          other.startOn == this.startOn &&
          other.notes == this.notes &&
          other.archived == this.archived);
}

class SamitiesCompanion extends UpdateCompanion<SamityRow> {
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String> id;
  final Value<String> name;
  final Value<SamityMode> mode;
  final Value<String?> fundId;
  final Value<int> contributionAmount;
  final Value<String> frequency;
  final Value<int> startOn;
  final Value<String?> notes;
  final Value<bool> archived;
  final Value<int> rowid;
  const SamitiesCompanion({
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mode = const Value.absent(),
    this.fundId = const Value.absent(),
    this.contributionAmount = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startOn = const Value.absent(),
    this.notes = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SamitiesCompanion.insert({
    this.version = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    required String id,
    required String name,
    required SamityMode mode,
    this.fundId = const Value.absent(),
    this.contributionAmount = const Value.absent(),
    this.frequency = const Value.absent(),
    required int startOn,
    this.notes = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       id = Value(id),
       name = Value(name),
       mode = Value(mode),
       startOn = Value(startOn);
  static Insertable<SamityRow> custom({
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? mode,
    Expression<String>? fundId,
    Expression<int>? contributionAmount,
    Expression<String>? frequency,
    Expression<int>? startOn,
    Expression<String>? notes,
    Expression<bool>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mode != null) 'mode': mode,
      if (fundId != null) 'fund_id': fundId,
      if (contributionAmount != null) 'contribution_amount': contributionAmount,
      if (frequency != null) 'frequency': frequency,
      if (startOn != null) 'start_on': startOn,
      if (notes != null) 'notes': notes,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SamitiesCompanion copyWith({
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<SyncStatus>? syncStatus,
    Value<String>? id,
    Value<String>? name,
    Value<SamityMode>? mode,
    Value<String?>? fundId,
    Value<int>? contributionAmount,
    Value<String>? frequency,
    Value<int>? startOn,
    Value<String?>? notes,
    Value<bool>? archived,
    Value<int>? rowid,
  }) {
    return SamitiesCompanion(
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      id: id ?? this.id,
      name: name ?? this.name,
      mode: mode ?? this.mode,
      fundId: fundId ?? this.fundId,
      contributionAmount: contributionAmount ?? this.contributionAmount,
      frequency: frequency ?? this.frequency,
      startOn: startOn ?? this.startOn,
      notes: notes ?? this.notes,
      archived: archived ?? this.archived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $SamitiesTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(
        $SamitiesTable.$convertermode.toSql(mode.value),
      );
    }
    if (fundId.present) {
      map['fund_id'] = Variable<String>(fundId.value);
    }
    if (contributionAmount.present) {
      map['contribution_amount'] = Variable<int>(contributionAmount.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (startOn.present) {
      map['start_on'] = Variable<int>(startOn.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SamitiesCompanion(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mode: $mode, ')
          ..write('fundId: $fundId, ')
          ..write('contributionAmount: $contributionAmount, ')
          ..write('frequency: $frequency, ')
          ..write('startOn: $startOn, ')
          ..write('notes: $notes, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SamityMembersTable extends SamityMembers
    with TableInfo<$SamityMembersTable, SamityMemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SamityMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncStatus>($SamityMembersTable.$convertersyncStatus);
  static const VerificationMeta _samityIdMeta = const VerificationMeta(
    'samityId',
  );
  @override
  late final GeneratedColumn<String> samityId = GeneratedColumn<String>(
    'samity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES samities (id)',
    ),
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
    'person_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id)',
    ),
  );
  static const VerificationMeta _sharesMeta = const VerificationMeta('shares');
  @override
  late final GeneratedColumn<int> shares = GeneratedColumn<int>(
    'shares',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _joinedOnMeta = const VerificationMeta(
    'joinedOn',
  );
  @override
  late final GeneratedColumn<int> joinedOn = GeneratedColumn<int>(
    'joined_on',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    createdAt,
    updatedAt,
    syncStatus,
    samityId,
    personId,
    shares,
    joinedOn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'samity_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<SamityMemberRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('samity_id')) {
      context.handle(
        _samityIdMeta,
        samityId.isAcceptableOrUnknown(data['samity_id']!, _samityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_samityIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('shares')) {
      context.handle(
        _sharesMeta,
        shares.isAcceptableOrUnknown(data['shares']!, _sharesMeta),
      );
    }
    if (data.containsKey('joined_on')) {
      context.handle(
        _joinedOnMeta,
        joinedOn.isAcceptableOrUnknown(data['joined_on']!, _joinedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_joinedOnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {samityId, personId};
  @override
  SamityMemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SamityMemberRow(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: $SamityMembersTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      samityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}samity_id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_id'],
      )!,
      shares: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shares'],
      )!,
      joinedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}joined_on'],
      )!,
    );
  }

  @override
  $SamityMembersTable createAlias(String alias) {
    return $SamityMembersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class SamityMemberRow extends DataClass implements Insertable<SamityMemberRow> {
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String samityId;
  final String personId;
  final int shares;
  final int joinedOn;
  const SamityMemberRow({
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.samityId,
    required this.personId,
    required this.shares,
    required this.joinedOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
        $SamityMembersTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['samity_id'] = Variable<String>(samityId);
    map['person_id'] = Variable<String>(personId);
    map['shares'] = Variable<int>(shares);
    map['joined_on'] = Variable<int>(joinedOn);
    return map;
  }

  SamityMembersCompanion toCompanion(bool nullToAbsent) {
    return SamityMembersCompanion(
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      samityId: Value(samityId),
      personId: Value(personId),
      shares: Value(shares),
      joinedOn: Value(joinedOn),
    );
  }

  factory SamityMemberRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SamityMemberRow(
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $SamityMembersTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      samityId: serializer.fromJson<String>(json['samityId']),
      personId: serializer.fromJson<String>(json['personId']),
      shares: serializer.fromJson<int>(json['shares']),
      joinedOn: serializer.fromJson<int>(json['joinedOn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
        $SamityMembersTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'samityId': serializer.toJson<String>(samityId),
      'personId': serializer.toJson<String>(personId),
      'shares': serializer.toJson<int>(shares),
      'joinedOn': serializer.toJson<int>(joinedOn),
    };
  }

  SamityMemberRow copyWith({
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    String? samityId,
    String? personId,
    int? shares,
    int? joinedOn,
  }) => SamityMemberRow(
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    samityId: samityId ?? this.samityId,
    personId: personId ?? this.personId,
    shares: shares ?? this.shares,
    joinedOn: joinedOn ?? this.joinedOn,
  );
  SamityMemberRow copyWithCompanion(SamityMembersCompanion data) {
    return SamityMemberRow(
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      samityId: data.samityId.present ? data.samityId.value : this.samityId,
      personId: data.personId.present ? data.personId.value : this.personId,
      shares: data.shares.present ? data.shares.value : this.shares,
      joinedOn: data.joinedOn.present ? data.joinedOn.value : this.joinedOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SamityMemberRow(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('samityId: $samityId, ')
          ..write('personId: $personId, ')
          ..write('shares: $shares, ')
          ..write('joinedOn: $joinedOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    version,
    createdAt,
    updatedAt,
    syncStatus,
    samityId,
    personId,
    shares,
    joinedOn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SamityMemberRow &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.samityId == this.samityId &&
          other.personId == this.personId &&
          other.shares == this.shares &&
          other.joinedOn == this.joinedOn);
}

class SamityMembersCompanion extends UpdateCompanion<SamityMemberRow> {
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String> samityId;
  final Value<String> personId;
  final Value<int> shares;
  final Value<int> joinedOn;
  final Value<int> rowid;
  const SamityMembersCompanion({
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.samityId = const Value.absent(),
    this.personId = const Value.absent(),
    this.shares = const Value.absent(),
    this.joinedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SamityMembersCompanion.insert({
    this.version = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    required String samityId,
    required String personId,
    this.shares = const Value.absent(),
    required int joinedOn,
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       samityId = Value(samityId),
       personId = Value(personId),
       joinedOn = Value(joinedOn);
  static Insertable<SamityMemberRow> custom({
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? samityId,
    Expression<String>? personId,
    Expression<int>? shares,
    Expression<int>? joinedOn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (samityId != null) 'samity_id': samityId,
      if (personId != null) 'person_id': personId,
      if (shares != null) 'shares': shares,
      if (joinedOn != null) 'joined_on': joinedOn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SamityMembersCompanion copyWith({
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<SyncStatus>? syncStatus,
    Value<String>? samityId,
    Value<String>? personId,
    Value<int>? shares,
    Value<int>? joinedOn,
    Value<int>? rowid,
  }) {
    return SamityMembersCompanion(
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      samityId: samityId ?? this.samityId,
      personId: personId ?? this.personId,
      shares: shares ?? this.shares,
      joinedOn: joinedOn ?? this.joinedOn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $SamityMembersTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (samityId.present) {
      map['samity_id'] = Variable<String>(samityId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (shares.present) {
      map['shares'] = Variable<int>(shares.value);
    }
    if (joinedOn.present) {
      map['joined_on'] = Variable<int>(joinedOn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SamityMembersCompanion(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('samityId: $samityId, ')
          ..write('personId: $personId, ')
          ..write('shares: $shares, ')
          ..write('joinedOn: $joinedOn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, BudgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncStatus>($BudgetsTable.$convertersyncStatus);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthKeyMeta = const VerificationMeta(
    'monthKey',
  );
  @override
  late final GeneratedColumn<int> monthKey = GeneratedColumn<int>(
    'month_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledger_accounts (id)',
    ),
  );
  static const VerificationMeta _limitAmountMeta = const VerificationMeta(
    'limitAmount',
  );
  @override
  late final GeneratedColumn<int> limitAmount = GeneratedColumn<int>(
    'limit_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    createdAt,
    updatedAt,
    syncStatus,
    id,
    monthKey,
    categoryId,
    limitAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('month_key')) {
      context.handle(
        _monthKeyMeta,
        monthKey.isAcceptableOrUnknown(data['month_key']!, _monthKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_monthKeyMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('limit_amount')) {
      context.handle(
        _limitAmountMeta,
        limitAmount.isAcceptableOrUnknown(
          data['limit_amount']!,
          _limitAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_limitAmountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {monthKey, categoryId},
  ];
  @override
  BudgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetRow(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: $BudgetsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      monthKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month_key'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      limitAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limit_amount'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class BudgetRow extends DataClass implements Insertable<BudgetRow> {
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String id;
  final int monthKey;
  final String categoryId;
  final int limitAmount;
  const BudgetRow({
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.id,
    required this.monthKey,
    required this.categoryId,
    required this.limitAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
        $BudgetsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['id'] = Variable<String>(id);
    map['month_key'] = Variable<int>(monthKey);
    map['category_id'] = Variable<String>(categoryId);
    map['limit_amount'] = Variable<int>(limitAmount);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      id: Value(id),
      monthKey: Value(monthKey),
      categoryId: Value(categoryId),
      limitAmount: Value(limitAmount),
    );
  }

  factory BudgetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetRow(
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $BudgetsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      id: serializer.fromJson<String>(json['id']),
      monthKey: serializer.fromJson<int>(json['monthKey']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      limitAmount: serializer.fromJson<int>(json['limitAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
        $BudgetsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'id': serializer.toJson<String>(id),
      'monthKey': serializer.toJson<int>(monthKey),
      'categoryId': serializer.toJson<String>(categoryId),
      'limitAmount': serializer.toJson<int>(limitAmount),
    };
  }

  BudgetRow copyWith({
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    String? id,
    int? monthKey,
    String? categoryId,
    int? limitAmount,
  }) => BudgetRow(
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    id: id ?? this.id,
    monthKey: monthKey ?? this.monthKey,
    categoryId: categoryId ?? this.categoryId,
    limitAmount: limitAmount ?? this.limitAmount,
  );
  BudgetRow copyWithCompanion(BudgetsCompanion data) {
    return BudgetRow(
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      id: data.id.present ? data.id.value : this.id,
      monthKey: data.monthKey.present ? data.monthKey.value : this.monthKey,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      limitAmount: data.limitAmount.present
          ? data.limitAmount.value
          : this.limitAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRow(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('monthKey: $monthKey, ')
          ..write('categoryId: $categoryId, ')
          ..write('limitAmount: $limitAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    version,
    createdAt,
    updatedAt,
    syncStatus,
    id,
    monthKey,
    categoryId,
    limitAmount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetRow &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.id == this.id &&
          other.monthKey == this.monthKey &&
          other.categoryId == this.categoryId &&
          other.limitAmount == this.limitAmount);
}

class BudgetsCompanion extends UpdateCompanion<BudgetRow> {
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<String> id;
  final Value<int> monthKey;
  final Value<String> categoryId;
  final Value<int> limitAmount;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.id = const Value.absent(),
    this.monthKey = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.limitAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.version = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    required String id,
    required int monthKey,
    required String categoryId,
    required int limitAmount,
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       id = Value(id),
       monthKey = Value(monthKey),
       categoryId = Value(categoryId),
       limitAmount = Value(limitAmount);
  static Insertable<BudgetRow> custom({
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? id,
    Expression<int>? monthKey,
    Expression<String>? categoryId,
    Expression<int>? limitAmount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (id != null) 'id': id,
      if (monthKey != null) 'month_key': monthKey,
      if (categoryId != null) 'category_id': categoryId,
      if (limitAmount != null) 'limit_amount': limitAmount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<SyncStatus>? syncStatus,
    Value<String>? id,
    Value<int>? monthKey,
    Value<String>? categoryId,
    Value<int>? limitAmount,
    Value<int>? rowid,
  }) {
    return BudgetsCompanion(
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      id: id ?? this.id,
      monthKey: monthKey ?? this.monthKey,
      categoryId: categoryId ?? this.categoryId,
      limitAmount: limitAmount ?? this.limitAmount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $BudgetsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (monthKey.present) {
      map['month_key'] = Variable<int>(monthKey.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (limitAmount.present) {
      map['limit_amount'] = Variable<int>(limitAmount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('monthKey: $monthKey, ')
          ..write('categoryId: $categoryId, ')
          ..write('limitAmount: $limitAmount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LedgerTransactionsTable extends LedgerTransactions
    with TableInfo<$LedgerTransactionsTable, TxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TxType>($LedgerTransactionsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<TxStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TxStatus>($LedgerTransactionsTable.$converterstatus);
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<int> dateKey = GeneratedColumn<int>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    true,
    check: () => amount.isNull() | ComparableExpr(amount).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('BDT'),
  );
  static const VerificationMeta _feeMeta = const VerificationMeta('fee');
  @override
  late final GeneratedColumn<int> fee = GeneratedColumn<int>(
    'fee',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _increaseMeta = const VerificationMeta(
    'increase',
  );
  @override
  late final GeneratedColumn<bool> increase = GeneratedColumn<bool>(
    'increase',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("increase" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceNoMeta = const VerificationMeta(
    'referenceNo',
  );
  @override
  late final GeneratedColumn<String> referenceNo = GeneratedColumn<String>(
    'reference_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
    'person_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fundIdMeta = const VerificationMeta('fundId');
  @override
  late final GeneratedColumn<String> fundId = GeneratedColumn<String>(
    'fund_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toFundIdMeta = const VerificationMeta(
    'toFundId',
  );
  @override
  late final GeneratedColumn<String> toFundId = GeneratedColumn<String>(
    'to_fund_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromAccountIdMeta = const VerificationMeta(
    'fromAccountId',
  );
  @override
  late final GeneratedColumn<String> fromAccountId = GeneratedColumn<String>(
    'from_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta(
    'toAccountId',
  );
  @override
  late final GeneratedColumn<String> toAccountId = GeneratedColumn<String>(
    'to_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _obligationIdMeta = const VerificationMeta(
    'obligationId',
  );
  @override
  late final GeneratedColumn<String> obligationId = GeneratedColumn<String>(
    'obligation_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _samityIdMeta = const VerificationMeta(
    'samityId',
  );
  @override
  late final GeneratedColumn<String> samityId = GeneratedColumn<String>(
    'samity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reconSessionIdMeta = const VerificationMeta(
    'reconSessionId',
  );
  @override
  late final GeneratedColumn<String> reconSessionId = GeneratedColumn<String>(
    'recon_session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reversesTxIdMeta = const VerificationMeta(
    'reversesTxId',
  );
  @override
  late final GeneratedColumn<String> reversesTxId = GeneratedColumn<String>(
    'reverses_tx_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reversedByTxIdMeta = const VerificationMeta(
    'reversedByTxId',
  );
  @override
  late final GeneratedColumn<String> reversedByTxId = GeneratedColumn<String>(
    'reversed_by_tx_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replacesTxIdMeta = const VerificationMeta(
    'replacesTxId',
  );
  @override
  late final GeneratedColumn<String> replacesTxId = GeneratedColumn<String>(
    'replaces_tx_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedByMeta = const VerificationMeta(
    'modifiedBy',
  );
  @override
  late final GeneratedColumn<String> modifiedBy = GeneratedColumn<String>(
    'modified_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postedAtMeta = const VerificationMeta(
    'postedAt',
  );
  @override
  late final GeneratedColumn<DateTime> postedAt = GeneratedColumn<DateTime>(
    'posted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortKeyMeta = const VerificationMeta(
    'sortKey',
  );
  @override
  late final GeneratedColumn<int> sortKey = GeneratedColumn<int>(
    'sort_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncStatus>(
        $LedgerTransactionsTable.$convertersyncStatus,
      );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    status,
    dateKey,
    amount,
    currency,
    fee,
    increase,
    description,
    notes,
    referenceNo,
    categoryId,
    personId,
    fundId,
    toFundId,
    fromAccountId,
    toAccountId,
    obligationId,
    samityId,
    reconSessionId,
    reversesTxId,
    reversedByTxId,
    replacesTxId,
    createdBy,
    modifiedBy,
    createdAt,
    updatedAt,
    postedAt,
    sortKey,
    version,
    contentHash,
    syncStatus,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('fee')) {
      context.handle(
        _feeMeta,
        fee.isAcceptableOrUnknown(data['fee']!, _feeMeta),
      );
    }
    if (data.containsKey('increase')) {
      context.handle(
        _increaseMeta,
        increase.isAcceptableOrUnknown(data['increase']!, _increaseMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('reference_no')) {
      context.handle(
        _referenceNoMeta,
        referenceNo.isAcceptableOrUnknown(
          data['reference_no']!,
          _referenceNoMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    }
    if (data.containsKey('fund_id')) {
      context.handle(
        _fundIdMeta,
        fundId.isAcceptableOrUnknown(data['fund_id']!, _fundIdMeta),
      );
    }
    if (data.containsKey('to_fund_id')) {
      context.handle(
        _toFundIdMeta,
        toFundId.isAcceptableOrUnknown(data['to_fund_id']!, _toFundIdMeta),
      );
    }
    if (data.containsKey('from_account_id')) {
      context.handle(
        _fromAccountIdMeta,
        fromAccountId.isAcceptableOrUnknown(
          data['from_account_id']!,
          _fromAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
        _toAccountIdMeta,
        toAccountId.isAcceptableOrUnknown(
          data['to_account_id']!,
          _toAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('obligation_id')) {
      context.handle(
        _obligationIdMeta,
        obligationId.isAcceptableOrUnknown(
          data['obligation_id']!,
          _obligationIdMeta,
        ),
      );
    }
    if (data.containsKey('samity_id')) {
      context.handle(
        _samityIdMeta,
        samityId.isAcceptableOrUnknown(data['samity_id']!, _samityIdMeta),
      );
    }
    if (data.containsKey('recon_session_id')) {
      context.handle(
        _reconSessionIdMeta,
        reconSessionId.isAcceptableOrUnknown(
          data['recon_session_id']!,
          _reconSessionIdMeta,
        ),
      );
    }
    if (data.containsKey('reverses_tx_id')) {
      context.handle(
        _reversesTxIdMeta,
        reversesTxId.isAcceptableOrUnknown(
          data['reverses_tx_id']!,
          _reversesTxIdMeta,
        ),
      );
    }
    if (data.containsKey('reversed_by_tx_id')) {
      context.handle(
        _reversedByTxIdMeta,
        reversedByTxId.isAcceptableOrUnknown(
          data['reversed_by_tx_id']!,
          _reversedByTxIdMeta,
        ),
      );
    }
    if (data.containsKey('replaces_tx_id')) {
      context.handle(
        _replacesTxIdMeta,
        replacesTxId.isAcceptableOrUnknown(
          data['replaces_tx_id']!,
          _replacesTxIdMeta,
        ),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('modified_by')) {
      context.handle(
        _modifiedByMeta,
        modifiedBy.isAcceptableOrUnknown(data['modified_by']!, _modifiedByMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('posted_at')) {
      context.handle(
        _postedAtMeta,
        postedAt.isAcceptableOrUnknown(data['posted_at']!, _postedAtMeta),
      );
    }
    if (data.containsKey('sort_key')) {
      context.handle(
        _sortKeyMeta,
        sortKey.isAcceptableOrUnknown(data['sort_key']!, _sortKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_sortKeyMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: $LedgerTransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      status: $LedgerTransactionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_key'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      fee: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fee'],
      )!,
      increase: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}increase'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      referenceNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_no'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_id'],
      ),
      fundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fund_id'],
      ),
      toFundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_fund_id'],
      ),
      fromAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_account_id'],
      ),
      toAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_account_id'],
      ),
      obligationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}obligation_id'],
      ),
      samityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}samity_id'],
      ),
      reconSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recon_session_id'],
      ),
      reversesTxId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reverses_tx_id'],
      ),
      reversedByTxId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reversed_by_tx_id'],
      ),
      replacesTxId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}replaces_tx_id'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      modifiedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modified_by'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      postedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}posted_at'],
      ),
      sortKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_key'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      ),
      syncStatus: $LedgerTransactionsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
    );
  }

  @override
  $LedgerTransactionsTable createAlias(String alias) {
    return $LedgerTransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TxType, String, String> $convertertype =
      const EnumNameConverter<TxType>(TxType.values);
  static JsonTypeConverter2<TxStatus, String, String> $converterstatus =
      const EnumNameConverter<TxStatus>(TxStatus.values);
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class TxRow extends DataClass implements Insertable<TxRow> {
  final String id;
  final TxType type;
  final TxStatus status;
  final int dateKey;
  final int? amount;
  final String currency;
  final int fee;
  final bool increase;
  final String? description;
  final String? notes;
  final String? referenceNo;
  final String? categoryId;
  final String? personId;
  final String? fundId;
  final String? toFundId;
  final String? fromAccountId;
  final String? toAccountId;
  final String? obligationId;
  final String? samityId;
  final String? reconSessionId;
  final String? reversesTxId;
  final String? reversedByTxId;
  final String? replacesTxId;
  final String createdBy;
  final String modifiedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? postedAt;

  /// Creation time in microseconds; orders entries within the same day
  /// deterministically (DateTime columns only keep whole seconds).
  final int sortKey;
  final int version;
  final String? contentHash;
  final SyncStatus syncStatus;
  final String? deviceId;
  const TxRow({
    required this.id,
    required this.type,
    required this.status,
    required this.dateKey,
    this.amount,
    required this.currency,
    required this.fee,
    required this.increase,
    this.description,
    this.notes,
    this.referenceNo,
    this.categoryId,
    this.personId,
    this.fundId,
    this.toFundId,
    this.fromAccountId,
    this.toAccountId,
    this.obligationId,
    this.samityId,
    this.reconSessionId,
    this.reversesTxId,
    this.reversedByTxId,
    this.replacesTxId,
    required this.createdBy,
    required this.modifiedBy,
    required this.createdAt,
    required this.updatedAt,
    this.postedAt,
    required this.sortKey,
    required this.version,
    this.contentHash,
    required this.syncStatus,
    this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['type'] = Variable<String>(
        $LedgerTransactionsTable.$convertertype.toSql(type),
      );
    }
    {
      map['status'] = Variable<String>(
        $LedgerTransactionsTable.$converterstatus.toSql(status),
      );
    }
    map['date_key'] = Variable<int>(dateKey);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<int>(amount);
    }
    map['currency'] = Variable<String>(currency);
    map['fee'] = Variable<int>(fee);
    map['increase'] = Variable<bool>(increase);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || referenceNo != null) {
      map['reference_no'] = Variable<String>(referenceNo);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || personId != null) {
      map['person_id'] = Variable<String>(personId);
    }
    if (!nullToAbsent || fundId != null) {
      map['fund_id'] = Variable<String>(fundId);
    }
    if (!nullToAbsent || toFundId != null) {
      map['to_fund_id'] = Variable<String>(toFundId);
    }
    if (!nullToAbsent || fromAccountId != null) {
      map['from_account_id'] = Variable<String>(fromAccountId);
    }
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<String>(toAccountId);
    }
    if (!nullToAbsent || obligationId != null) {
      map['obligation_id'] = Variable<String>(obligationId);
    }
    if (!nullToAbsent || samityId != null) {
      map['samity_id'] = Variable<String>(samityId);
    }
    if (!nullToAbsent || reconSessionId != null) {
      map['recon_session_id'] = Variable<String>(reconSessionId);
    }
    if (!nullToAbsent || reversesTxId != null) {
      map['reverses_tx_id'] = Variable<String>(reversesTxId);
    }
    if (!nullToAbsent || reversedByTxId != null) {
      map['reversed_by_tx_id'] = Variable<String>(reversedByTxId);
    }
    if (!nullToAbsent || replacesTxId != null) {
      map['replaces_tx_id'] = Variable<String>(replacesTxId);
    }
    map['created_by'] = Variable<String>(createdBy);
    map['modified_by'] = Variable<String>(modifiedBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || postedAt != null) {
      map['posted_at'] = Variable<DateTime>(postedAt);
    }
    map['sort_key'] = Variable<int>(sortKey);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || contentHash != null) {
      map['content_hash'] = Variable<String>(contentHash);
    }
    {
      map['sync_status'] = Variable<String>(
        $LedgerTransactionsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    return map;
  }

  LedgerTransactionsCompanion toCompanion(bool nullToAbsent) {
    return LedgerTransactionsCompanion(
      id: Value(id),
      type: Value(type),
      status: Value(status),
      dateKey: Value(dateKey),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      currency: Value(currency),
      fee: Value(fee),
      increase: Value(increase),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      referenceNo: referenceNo == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceNo),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
      fundId: fundId == null && nullToAbsent
          ? const Value.absent()
          : Value(fundId),
      toFundId: toFundId == null && nullToAbsent
          ? const Value.absent()
          : Value(toFundId),
      fromAccountId: fromAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromAccountId),
      toAccountId: toAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(toAccountId),
      obligationId: obligationId == null && nullToAbsent
          ? const Value.absent()
          : Value(obligationId),
      samityId: samityId == null && nullToAbsent
          ? const Value.absent()
          : Value(samityId),
      reconSessionId: reconSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(reconSessionId),
      reversesTxId: reversesTxId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversesTxId),
      reversedByTxId: reversedByTxId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversedByTxId),
      replacesTxId: replacesTxId == null && nullToAbsent
          ? const Value.absent()
          : Value(replacesTxId),
      createdBy: Value(createdBy),
      modifiedBy: Value(modifiedBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      postedAt: postedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(postedAt),
      sortKey: Value(sortKey),
      version: Value(version),
      contentHash: contentHash == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHash),
      syncStatus: Value(syncStatus),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
    );
  }

  factory TxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TxRow(
      id: serializer.fromJson<String>(json['id']),
      type: $LedgerTransactionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      status: $LedgerTransactionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      dateKey: serializer.fromJson<int>(json['dateKey']),
      amount: serializer.fromJson<int?>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      fee: serializer.fromJson<int>(json['fee']),
      increase: serializer.fromJson<bool>(json['increase']),
      description: serializer.fromJson<String?>(json['description']),
      notes: serializer.fromJson<String?>(json['notes']),
      referenceNo: serializer.fromJson<String?>(json['referenceNo']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      personId: serializer.fromJson<String?>(json['personId']),
      fundId: serializer.fromJson<String?>(json['fundId']),
      toFundId: serializer.fromJson<String?>(json['toFundId']),
      fromAccountId: serializer.fromJson<String?>(json['fromAccountId']),
      toAccountId: serializer.fromJson<String?>(json['toAccountId']),
      obligationId: serializer.fromJson<String?>(json['obligationId']),
      samityId: serializer.fromJson<String?>(json['samityId']),
      reconSessionId: serializer.fromJson<String?>(json['reconSessionId']),
      reversesTxId: serializer.fromJson<String?>(json['reversesTxId']),
      reversedByTxId: serializer.fromJson<String?>(json['reversedByTxId']),
      replacesTxId: serializer.fromJson<String?>(json['replacesTxId']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      modifiedBy: serializer.fromJson<String>(json['modifiedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      postedAt: serializer.fromJson<DateTime?>(json['postedAt']),
      sortKey: serializer.fromJson<int>(json['sortKey']),
      version: serializer.fromJson<int>(json['version']),
      contentHash: serializer.fromJson<String?>(json['contentHash']),
      syncStatus: $LedgerTransactionsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(
        $LedgerTransactionsTable.$convertertype.toJson(type),
      ),
      'status': serializer.toJson<String>(
        $LedgerTransactionsTable.$converterstatus.toJson(status),
      ),
      'dateKey': serializer.toJson<int>(dateKey),
      'amount': serializer.toJson<int?>(amount),
      'currency': serializer.toJson<String>(currency),
      'fee': serializer.toJson<int>(fee),
      'increase': serializer.toJson<bool>(increase),
      'description': serializer.toJson<String?>(description),
      'notes': serializer.toJson<String?>(notes),
      'referenceNo': serializer.toJson<String?>(referenceNo),
      'categoryId': serializer.toJson<String?>(categoryId),
      'personId': serializer.toJson<String?>(personId),
      'fundId': serializer.toJson<String?>(fundId),
      'toFundId': serializer.toJson<String?>(toFundId),
      'fromAccountId': serializer.toJson<String?>(fromAccountId),
      'toAccountId': serializer.toJson<String?>(toAccountId),
      'obligationId': serializer.toJson<String?>(obligationId),
      'samityId': serializer.toJson<String?>(samityId),
      'reconSessionId': serializer.toJson<String?>(reconSessionId),
      'reversesTxId': serializer.toJson<String?>(reversesTxId),
      'reversedByTxId': serializer.toJson<String?>(reversedByTxId),
      'replacesTxId': serializer.toJson<String?>(replacesTxId),
      'createdBy': serializer.toJson<String>(createdBy),
      'modifiedBy': serializer.toJson<String>(modifiedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'postedAt': serializer.toJson<DateTime?>(postedAt),
      'sortKey': serializer.toJson<int>(sortKey),
      'version': serializer.toJson<int>(version),
      'contentHash': serializer.toJson<String?>(contentHash),
      'syncStatus': serializer.toJson<String>(
        $LedgerTransactionsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'deviceId': serializer.toJson<String?>(deviceId),
    };
  }

  TxRow copyWith({
    String? id,
    TxType? type,
    TxStatus? status,
    int? dateKey,
    Value<int?> amount = const Value.absent(),
    String? currency,
    int? fee,
    bool? increase,
    Value<String?> description = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> referenceNo = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> personId = const Value.absent(),
    Value<String?> fundId = const Value.absent(),
    Value<String?> toFundId = const Value.absent(),
    Value<String?> fromAccountId = const Value.absent(),
    Value<String?> toAccountId = const Value.absent(),
    Value<String?> obligationId = const Value.absent(),
    Value<String?> samityId = const Value.absent(),
    Value<String?> reconSessionId = const Value.absent(),
    Value<String?> reversesTxId = const Value.absent(),
    Value<String?> reversedByTxId = const Value.absent(),
    Value<String?> replacesTxId = const Value.absent(),
    String? createdBy,
    String? modifiedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> postedAt = const Value.absent(),
    int? sortKey,
    int? version,
    Value<String?> contentHash = const Value.absent(),
    SyncStatus? syncStatus,
    Value<String?> deviceId = const Value.absent(),
  }) => TxRow(
    id: id ?? this.id,
    type: type ?? this.type,
    status: status ?? this.status,
    dateKey: dateKey ?? this.dateKey,
    amount: amount.present ? amount.value : this.amount,
    currency: currency ?? this.currency,
    fee: fee ?? this.fee,
    increase: increase ?? this.increase,
    description: description.present ? description.value : this.description,
    notes: notes.present ? notes.value : this.notes,
    referenceNo: referenceNo.present ? referenceNo.value : this.referenceNo,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    personId: personId.present ? personId.value : this.personId,
    fundId: fundId.present ? fundId.value : this.fundId,
    toFundId: toFundId.present ? toFundId.value : this.toFundId,
    fromAccountId: fromAccountId.present
        ? fromAccountId.value
        : this.fromAccountId,
    toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
    obligationId: obligationId.present ? obligationId.value : this.obligationId,
    samityId: samityId.present ? samityId.value : this.samityId,
    reconSessionId: reconSessionId.present
        ? reconSessionId.value
        : this.reconSessionId,
    reversesTxId: reversesTxId.present ? reversesTxId.value : this.reversesTxId,
    reversedByTxId: reversedByTxId.present
        ? reversedByTxId.value
        : this.reversedByTxId,
    replacesTxId: replacesTxId.present ? replacesTxId.value : this.replacesTxId,
    createdBy: createdBy ?? this.createdBy,
    modifiedBy: modifiedBy ?? this.modifiedBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    postedAt: postedAt.present ? postedAt.value : this.postedAt,
    sortKey: sortKey ?? this.sortKey,
    version: version ?? this.version,
    contentHash: contentHash.present ? contentHash.value : this.contentHash,
    syncStatus: syncStatus ?? this.syncStatus,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
  );
  TxRow copyWithCompanion(LedgerTransactionsCompanion data) {
    return TxRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      fee: data.fee.present ? data.fee.value : this.fee,
      increase: data.increase.present ? data.increase.value : this.increase,
      description: data.description.present
          ? data.description.value
          : this.description,
      notes: data.notes.present ? data.notes.value : this.notes,
      referenceNo: data.referenceNo.present
          ? data.referenceNo.value
          : this.referenceNo,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      personId: data.personId.present ? data.personId.value : this.personId,
      fundId: data.fundId.present ? data.fundId.value : this.fundId,
      toFundId: data.toFundId.present ? data.toFundId.value : this.toFundId,
      fromAccountId: data.fromAccountId.present
          ? data.fromAccountId.value
          : this.fromAccountId,
      toAccountId: data.toAccountId.present
          ? data.toAccountId.value
          : this.toAccountId,
      obligationId: data.obligationId.present
          ? data.obligationId.value
          : this.obligationId,
      samityId: data.samityId.present ? data.samityId.value : this.samityId,
      reconSessionId: data.reconSessionId.present
          ? data.reconSessionId.value
          : this.reconSessionId,
      reversesTxId: data.reversesTxId.present
          ? data.reversesTxId.value
          : this.reversesTxId,
      reversedByTxId: data.reversedByTxId.present
          ? data.reversedByTxId.value
          : this.reversedByTxId,
      replacesTxId: data.replacesTxId.present
          ? data.replacesTxId.value
          : this.replacesTxId,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      modifiedBy: data.modifiedBy.present
          ? data.modifiedBy.value
          : this.modifiedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      postedAt: data.postedAt.present ? data.postedAt.value : this.postedAt,
      sortKey: data.sortKey.present ? data.sortKey.value : this.sortKey,
      version: data.version.present ? data.version.value : this.version,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TxRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('dateKey: $dateKey, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('fee: $fee, ')
          ..write('increase: $increase, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('referenceNo: $referenceNo, ')
          ..write('categoryId: $categoryId, ')
          ..write('personId: $personId, ')
          ..write('fundId: $fundId, ')
          ..write('toFundId: $toFundId, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('obligationId: $obligationId, ')
          ..write('samityId: $samityId, ')
          ..write('reconSessionId: $reconSessionId, ')
          ..write('reversesTxId: $reversesTxId, ')
          ..write('reversedByTxId: $reversedByTxId, ')
          ..write('replacesTxId: $replacesTxId, ')
          ..write('createdBy: $createdBy, ')
          ..write('modifiedBy: $modifiedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('postedAt: $postedAt, ')
          ..write('sortKey: $sortKey, ')
          ..write('version: $version, ')
          ..write('contentHash: $contentHash, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    type,
    status,
    dateKey,
    amount,
    currency,
    fee,
    increase,
    description,
    notes,
    referenceNo,
    categoryId,
    personId,
    fundId,
    toFundId,
    fromAccountId,
    toAccountId,
    obligationId,
    samityId,
    reconSessionId,
    reversesTxId,
    reversedByTxId,
    replacesTxId,
    createdBy,
    modifiedBy,
    createdAt,
    updatedAt,
    postedAt,
    sortKey,
    version,
    contentHash,
    syncStatus,
    deviceId,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TxRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.status == this.status &&
          other.dateKey == this.dateKey &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.fee == this.fee &&
          other.increase == this.increase &&
          other.description == this.description &&
          other.notes == this.notes &&
          other.referenceNo == this.referenceNo &&
          other.categoryId == this.categoryId &&
          other.personId == this.personId &&
          other.fundId == this.fundId &&
          other.toFundId == this.toFundId &&
          other.fromAccountId == this.fromAccountId &&
          other.toAccountId == this.toAccountId &&
          other.obligationId == this.obligationId &&
          other.samityId == this.samityId &&
          other.reconSessionId == this.reconSessionId &&
          other.reversesTxId == this.reversesTxId &&
          other.reversedByTxId == this.reversedByTxId &&
          other.replacesTxId == this.replacesTxId &&
          other.createdBy == this.createdBy &&
          other.modifiedBy == this.modifiedBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.postedAt == this.postedAt &&
          other.sortKey == this.sortKey &&
          other.version == this.version &&
          other.contentHash == this.contentHash &&
          other.syncStatus == this.syncStatus &&
          other.deviceId == this.deviceId);
}

class LedgerTransactionsCompanion extends UpdateCompanion<TxRow> {
  final Value<String> id;
  final Value<TxType> type;
  final Value<TxStatus> status;
  final Value<int> dateKey;
  final Value<int?> amount;
  final Value<String> currency;
  final Value<int> fee;
  final Value<bool> increase;
  final Value<String?> description;
  final Value<String?> notes;
  final Value<String?> referenceNo;
  final Value<String?> categoryId;
  final Value<String?> personId;
  final Value<String?> fundId;
  final Value<String?> toFundId;
  final Value<String?> fromAccountId;
  final Value<String?> toAccountId;
  final Value<String?> obligationId;
  final Value<String?> samityId;
  final Value<String?> reconSessionId;
  final Value<String?> reversesTxId;
  final Value<String?> reversedByTxId;
  final Value<String?> replacesTxId;
  final Value<String> createdBy;
  final Value<String> modifiedBy;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> postedAt;
  final Value<int> sortKey;
  final Value<int> version;
  final Value<String?> contentHash;
  final Value<SyncStatus> syncStatus;
  final Value<String?> deviceId;
  final Value<int> rowid;
  const LedgerTransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.fee = const Value.absent(),
    this.increase = const Value.absent(),
    this.description = const Value.absent(),
    this.notes = const Value.absent(),
    this.referenceNo = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.personId = const Value.absent(),
    this.fundId = const Value.absent(),
    this.toFundId = const Value.absent(),
    this.fromAccountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.obligationId = const Value.absent(),
    this.samityId = const Value.absent(),
    this.reconSessionId = const Value.absent(),
    this.reversesTxId = const Value.absent(),
    this.reversedByTxId = const Value.absent(),
    this.replacesTxId = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.modifiedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.postedAt = const Value.absent(),
    this.sortKey = const Value.absent(),
    this.version = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LedgerTransactionsCompanion.insert({
    required String id,
    required TxType type,
    required TxStatus status,
    required int dateKey,
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.fee = const Value.absent(),
    this.increase = const Value.absent(),
    this.description = const Value.absent(),
    this.notes = const Value.absent(),
    this.referenceNo = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.personId = const Value.absent(),
    this.fundId = const Value.absent(),
    this.toFundId = const Value.absent(),
    this.fromAccountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.obligationId = const Value.absent(),
    this.samityId = const Value.absent(),
    this.reconSessionId = const Value.absent(),
    this.reversesTxId = const Value.absent(),
    this.reversedByTxId = const Value.absent(),
    this.replacesTxId = const Value.absent(),
    required String createdBy,
    required String modifiedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.postedAt = const Value.absent(),
    required int sortKey,
    this.version = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       status = Value(status),
       dateKey = Value(dateKey),
       createdBy = Value(createdBy),
       modifiedBy = Value(modifiedBy),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       sortKey = Value(sortKey);
  static Insertable<TxRow> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? status,
    Expression<int>? dateKey,
    Expression<int>? amount,
    Expression<String>? currency,
    Expression<int>? fee,
    Expression<bool>? increase,
    Expression<String>? description,
    Expression<String>? notes,
    Expression<String>? referenceNo,
    Expression<String>? categoryId,
    Expression<String>? personId,
    Expression<String>? fundId,
    Expression<String>? toFundId,
    Expression<String>? fromAccountId,
    Expression<String>? toAccountId,
    Expression<String>? obligationId,
    Expression<String>? samityId,
    Expression<String>? reconSessionId,
    Expression<String>? reversesTxId,
    Expression<String>? reversedByTxId,
    Expression<String>? replacesTxId,
    Expression<String>? createdBy,
    Expression<String>? modifiedBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? postedAt,
    Expression<int>? sortKey,
    Expression<int>? version,
    Expression<String>? contentHash,
    Expression<String>? syncStatus,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (dateKey != null) 'date_key': dateKey,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (fee != null) 'fee': fee,
      if (increase != null) 'increase': increase,
      if (description != null) 'description': description,
      if (notes != null) 'notes': notes,
      if (referenceNo != null) 'reference_no': referenceNo,
      if (categoryId != null) 'category_id': categoryId,
      if (personId != null) 'person_id': personId,
      if (fundId != null) 'fund_id': fundId,
      if (toFundId != null) 'to_fund_id': toFundId,
      if (fromAccountId != null) 'from_account_id': fromAccountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (obligationId != null) 'obligation_id': obligationId,
      if (samityId != null) 'samity_id': samityId,
      if (reconSessionId != null) 'recon_session_id': reconSessionId,
      if (reversesTxId != null) 'reverses_tx_id': reversesTxId,
      if (reversedByTxId != null) 'reversed_by_tx_id': reversedByTxId,
      if (replacesTxId != null) 'replaces_tx_id': replacesTxId,
      if (createdBy != null) 'created_by': createdBy,
      if (modifiedBy != null) 'modified_by': modifiedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (postedAt != null) 'posted_at': postedAt,
      if (sortKey != null) 'sort_key': sortKey,
      if (version != null) 'version': version,
      if (contentHash != null) 'content_hash': contentHash,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LedgerTransactionsCompanion copyWith({
    Value<String>? id,
    Value<TxType>? type,
    Value<TxStatus>? status,
    Value<int>? dateKey,
    Value<int?>? amount,
    Value<String>? currency,
    Value<int>? fee,
    Value<bool>? increase,
    Value<String?>? description,
    Value<String?>? notes,
    Value<String?>? referenceNo,
    Value<String?>? categoryId,
    Value<String?>? personId,
    Value<String?>? fundId,
    Value<String?>? toFundId,
    Value<String?>? fromAccountId,
    Value<String?>? toAccountId,
    Value<String?>? obligationId,
    Value<String?>? samityId,
    Value<String?>? reconSessionId,
    Value<String?>? reversesTxId,
    Value<String?>? reversedByTxId,
    Value<String?>? replacesTxId,
    Value<String>? createdBy,
    Value<String>? modifiedBy,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? postedAt,
    Value<int>? sortKey,
    Value<int>? version,
    Value<String?>? contentHash,
    Value<SyncStatus>? syncStatus,
    Value<String?>? deviceId,
    Value<int>? rowid,
  }) {
    return LedgerTransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      dateKey: dateKey ?? this.dateKey,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      fee: fee ?? this.fee,
      increase: increase ?? this.increase,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      referenceNo: referenceNo ?? this.referenceNo,
      categoryId: categoryId ?? this.categoryId,
      personId: personId ?? this.personId,
      fundId: fundId ?? this.fundId,
      toFundId: toFundId ?? this.toFundId,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      obligationId: obligationId ?? this.obligationId,
      samityId: samityId ?? this.samityId,
      reconSessionId: reconSessionId ?? this.reconSessionId,
      reversesTxId: reversesTxId ?? this.reversesTxId,
      reversedByTxId: reversedByTxId ?? this.reversedByTxId,
      replacesTxId: replacesTxId ?? this.replacesTxId,
      createdBy: createdBy ?? this.createdBy,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      postedAt: postedAt ?? this.postedAt,
      sortKey: sortKey ?? this.sortKey,
      version: version ?? this.version,
      contentHash: contentHash ?? this.contentHash,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $LedgerTransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $LedgerTransactionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (dateKey.present) {
      map['date_key'] = Variable<int>(dateKey.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (fee.present) {
      map['fee'] = Variable<int>(fee.value);
    }
    if (increase.present) {
      map['increase'] = Variable<bool>(increase.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (referenceNo.present) {
      map['reference_no'] = Variable<String>(referenceNo.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (fundId.present) {
      map['fund_id'] = Variable<String>(fundId.value);
    }
    if (toFundId.present) {
      map['to_fund_id'] = Variable<String>(toFundId.value);
    }
    if (fromAccountId.present) {
      map['from_account_id'] = Variable<String>(fromAccountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<String>(toAccountId.value);
    }
    if (obligationId.present) {
      map['obligation_id'] = Variable<String>(obligationId.value);
    }
    if (samityId.present) {
      map['samity_id'] = Variable<String>(samityId.value);
    }
    if (reconSessionId.present) {
      map['recon_session_id'] = Variable<String>(reconSessionId.value);
    }
    if (reversesTxId.present) {
      map['reverses_tx_id'] = Variable<String>(reversesTxId.value);
    }
    if (reversedByTxId.present) {
      map['reversed_by_tx_id'] = Variable<String>(reversedByTxId.value);
    }
    if (replacesTxId.present) {
      map['replaces_tx_id'] = Variable<String>(replacesTxId.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (modifiedBy.present) {
      map['modified_by'] = Variable<String>(modifiedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (postedAt.present) {
      map['posted_at'] = Variable<DateTime>(postedAt.value);
    }
    if (sortKey.present) {
      map['sort_key'] = Variable<int>(sortKey.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $LedgerTransactionsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('dateKey: $dateKey, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('fee: $fee, ')
          ..write('increase: $increase, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('referenceNo: $referenceNo, ')
          ..write('categoryId: $categoryId, ')
          ..write('personId: $personId, ')
          ..write('fundId: $fundId, ')
          ..write('toFundId: $toFundId, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('obligationId: $obligationId, ')
          ..write('samityId: $samityId, ')
          ..write('reconSessionId: $reconSessionId, ')
          ..write('reversesTxId: $reversesTxId, ')
          ..write('reversedByTxId: $reversedByTxId, ')
          ..write('replacesTxId: $replacesTxId, ')
          ..write('createdBy: $createdBy, ')
          ..write('modifiedBy: $modifiedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('postedAt: $postedAt, ')
          ..write('sortKey: $sortKey, ')
          ..write('version: $version, ')
          ..write('contentHash: $contentHash, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionLinesTable extends TransactionLines
    with TableInfo<$TransactionLinesTable, LineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _txIdMeta = const VerificationMeta('txId');
  @override
  late final GeneratedColumn<String> txId = GeneratedColumn<String>(
    'tx_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledger_transactions (id)',
    ),
  );
  static const VerificationMeta _lineNoMeta = const VerificationMeta('lineNo');
  @override
  late final GeneratedColumn<int> lineNo = GeneratedColumn<int>(
    'line_no',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledger_accounts (id)',
    ),
  );
  static const VerificationMeta _fundIdMeta = const VerificationMeta('fundId');
  @override
  late final GeneratedColumn<String> fundId = GeneratedColumn<String>(
    'fund_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES funds (id)',
    ),
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
    'person_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _counterFundIdMeta = const VerificationMeta(
    'counterFundId',
  );
  @override
  late final GeneratedColumn<String> counterFundId = GeneratedColumn<String>(
    'counter_fund_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    check: () => amount.isNotValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    txId,
    lineNo,
    accountId,
    fundId,
    personId,
    counterFundId,
    amount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<LineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tx_id')) {
      context.handle(
        _txIdMeta,
        txId.isAcceptableOrUnknown(data['tx_id']!, _txIdMeta),
      );
    } else if (isInserting) {
      context.missing(_txIdMeta);
    }
    if (data.containsKey('line_no')) {
      context.handle(
        _lineNoMeta,
        lineNo.isAcceptableOrUnknown(data['line_no']!, _lineNoMeta),
      );
    } else if (isInserting) {
      context.missing(_lineNoMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('fund_id')) {
      context.handle(
        _fundIdMeta,
        fundId.isAcceptableOrUnknown(data['fund_id']!, _fundIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fundIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    }
    if (data.containsKey('counter_fund_id')) {
      context.handle(
        _counterFundIdMeta,
        counterFundId.isAcceptableOrUnknown(
          data['counter_fund_id']!,
          _counterFundIdMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {txId, lineNo};
  @override
  LineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LineRow(
      txId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tx_id'],
      )!,
      lineNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_no'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      fundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fund_id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_id'],
      ),
      counterFundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counter_fund_id'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
    );
  }

  @override
  $TransactionLinesTable createAlias(String alias) {
    return $TransactionLinesTable(attachedDatabase, alias);
  }
}

class LineRow extends DataClass implements Insertable<LineRow> {
  final String txId;
  final int lineNo;
  final String accountId;
  final String fundId;
  final String? personId;
  final String? counterFundId;
  final int amount;
  const LineRow({
    required this.txId,
    required this.lineNo,
    required this.accountId,
    required this.fundId,
    this.personId,
    this.counterFundId,
    required this.amount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tx_id'] = Variable<String>(txId);
    map['line_no'] = Variable<int>(lineNo);
    map['account_id'] = Variable<String>(accountId);
    map['fund_id'] = Variable<String>(fundId);
    if (!nullToAbsent || personId != null) {
      map['person_id'] = Variable<String>(personId);
    }
    if (!nullToAbsent || counterFundId != null) {
      map['counter_fund_id'] = Variable<String>(counterFundId);
    }
    map['amount'] = Variable<int>(amount);
    return map;
  }

  TransactionLinesCompanion toCompanion(bool nullToAbsent) {
    return TransactionLinesCompanion(
      txId: Value(txId),
      lineNo: Value(lineNo),
      accountId: Value(accountId),
      fundId: Value(fundId),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
      counterFundId: counterFundId == null && nullToAbsent
          ? const Value.absent()
          : Value(counterFundId),
      amount: Value(amount),
    );
  }

  factory LineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LineRow(
      txId: serializer.fromJson<String>(json['txId']),
      lineNo: serializer.fromJson<int>(json['lineNo']),
      accountId: serializer.fromJson<String>(json['accountId']),
      fundId: serializer.fromJson<String>(json['fundId']),
      personId: serializer.fromJson<String?>(json['personId']),
      counterFundId: serializer.fromJson<String?>(json['counterFundId']),
      amount: serializer.fromJson<int>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'txId': serializer.toJson<String>(txId),
      'lineNo': serializer.toJson<int>(lineNo),
      'accountId': serializer.toJson<String>(accountId),
      'fundId': serializer.toJson<String>(fundId),
      'personId': serializer.toJson<String?>(personId),
      'counterFundId': serializer.toJson<String?>(counterFundId),
      'amount': serializer.toJson<int>(amount),
    };
  }

  LineRow copyWith({
    String? txId,
    int? lineNo,
    String? accountId,
    String? fundId,
    Value<String?> personId = const Value.absent(),
    Value<String?> counterFundId = const Value.absent(),
    int? amount,
  }) => LineRow(
    txId: txId ?? this.txId,
    lineNo: lineNo ?? this.lineNo,
    accountId: accountId ?? this.accountId,
    fundId: fundId ?? this.fundId,
    personId: personId.present ? personId.value : this.personId,
    counterFundId: counterFundId.present
        ? counterFundId.value
        : this.counterFundId,
    amount: amount ?? this.amount,
  );
  LineRow copyWithCompanion(TransactionLinesCompanion data) {
    return LineRow(
      txId: data.txId.present ? data.txId.value : this.txId,
      lineNo: data.lineNo.present ? data.lineNo.value : this.lineNo,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      fundId: data.fundId.present ? data.fundId.value : this.fundId,
      personId: data.personId.present ? data.personId.value : this.personId,
      counterFundId: data.counterFundId.present
          ? data.counterFundId.value
          : this.counterFundId,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LineRow(')
          ..write('txId: $txId, ')
          ..write('lineNo: $lineNo, ')
          ..write('accountId: $accountId, ')
          ..write('fundId: $fundId, ')
          ..write('personId: $personId, ')
          ..write('counterFundId: $counterFundId, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    txId,
    lineNo,
    accountId,
    fundId,
    personId,
    counterFundId,
    amount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LineRow &&
          other.txId == this.txId &&
          other.lineNo == this.lineNo &&
          other.accountId == this.accountId &&
          other.fundId == this.fundId &&
          other.personId == this.personId &&
          other.counterFundId == this.counterFundId &&
          other.amount == this.amount);
}

class TransactionLinesCompanion extends UpdateCompanion<LineRow> {
  final Value<String> txId;
  final Value<int> lineNo;
  final Value<String> accountId;
  final Value<String> fundId;
  final Value<String?> personId;
  final Value<String?> counterFundId;
  final Value<int> amount;
  final Value<int> rowid;
  const TransactionLinesCompanion({
    this.txId = const Value.absent(),
    this.lineNo = const Value.absent(),
    this.accountId = const Value.absent(),
    this.fundId = const Value.absent(),
    this.personId = const Value.absent(),
    this.counterFundId = const Value.absent(),
    this.amount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionLinesCompanion.insert({
    required String txId,
    required int lineNo,
    required String accountId,
    required String fundId,
    this.personId = const Value.absent(),
    this.counterFundId = const Value.absent(),
    required int amount,
    this.rowid = const Value.absent(),
  }) : txId = Value(txId),
       lineNo = Value(lineNo),
       accountId = Value(accountId),
       fundId = Value(fundId),
       amount = Value(amount);
  static Insertable<LineRow> custom({
    Expression<String>? txId,
    Expression<int>? lineNo,
    Expression<String>? accountId,
    Expression<String>? fundId,
    Expression<String>? personId,
    Expression<String>? counterFundId,
    Expression<int>? amount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (txId != null) 'tx_id': txId,
      if (lineNo != null) 'line_no': lineNo,
      if (accountId != null) 'account_id': accountId,
      if (fundId != null) 'fund_id': fundId,
      if (personId != null) 'person_id': personId,
      if (counterFundId != null) 'counter_fund_id': counterFundId,
      if (amount != null) 'amount': amount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionLinesCompanion copyWith({
    Value<String>? txId,
    Value<int>? lineNo,
    Value<String>? accountId,
    Value<String>? fundId,
    Value<String?>? personId,
    Value<String?>? counterFundId,
    Value<int>? amount,
    Value<int>? rowid,
  }) {
    return TransactionLinesCompanion(
      txId: txId ?? this.txId,
      lineNo: lineNo ?? this.lineNo,
      accountId: accountId ?? this.accountId,
      fundId: fundId ?? this.fundId,
      personId: personId ?? this.personId,
      counterFundId: counterFundId ?? this.counterFundId,
      amount: amount ?? this.amount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (txId.present) {
      map['tx_id'] = Variable<String>(txId.value);
    }
    if (lineNo.present) {
      map['line_no'] = Variable<int>(lineNo.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (fundId.present) {
      map['fund_id'] = Variable<String>(fundId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (counterFundId.present) {
      map['counter_fund_id'] = Variable<String>(counterFundId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionLinesCompanion(')
          ..write('txId: $txId, ')
          ..write('lineNo: $lineNo, ')
          ..write('accountId: $accountId, ')
          ..write('fundId: $fundId, ')
          ..write('personId: $personId, ')
          ..write('counterFundId: $counterFundId, ')
          ..write('amount: $amount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, AttachmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _txIdMeta = const VerificationMeta('txId');
  @override
  late final GeneratedColumn<String> txId = GeneratedColumn<String>(
    'tx_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledger_transactions (id)',
    ),
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    txId,
    fileName,
    localPath,
    mimeType,
    sizeBytes,
    sha256,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttachmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tx_id')) {
      context.handle(
        _txIdMeta,
        txId.isAcceptableOrUnknown(data['tx_id']!, _txIdMeta),
      );
    } else if (isInserting) {
      context.missing(_txIdMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttachmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttachmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      txId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tx_id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }
}

class AttachmentRow extends DataClass implements Insertable<AttachmentRow> {
  final String id;
  final String txId;
  final String fileName;
  final String localPath;
  final String? mimeType;
  final int sizeBytes;
  final String sha256;
  final DateTime createdAt;
  const AttachmentRow({
    required this.id,
    required this.txId,
    required this.fileName,
    required this.localPath,
    this.mimeType,
    required this.sizeBytes,
    required this.sha256,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tx_id'] = Variable<String>(txId);
    map['file_name'] = Variable<String>(fileName);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['sha256'] = Variable<String>(sha256);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      txId: Value(txId),
      fileName: Value(fileName),
      localPath: Value(localPath),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      sizeBytes: Value(sizeBytes),
      sha256: Value(sha256),
      createdAt: Value(createdAt),
    );
  }

  factory AttachmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttachmentRow(
      id: serializer.fromJson<String>(json['id']),
      txId: serializer.fromJson<String>(json['txId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      localPath: serializer.fromJson<String>(json['localPath']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      sha256: serializer.fromJson<String>(json['sha256']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'txId': serializer.toJson<String>(txId),
      'fileName': serializer.toJson<String>(fileName),
      'localPath': serializer.toJson<String>(localPath),
      'mimeType': serializer.toJson<String?>(mimeType),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'sha256': serializer.toJson<String>(sha256),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AttachmentRow copyWith({
    String? id,
    String? txId,
    String? fileName,
    String? localPath,
    Value<String?> mimeType = const Value.absent(),
    int? sizeBytes,
    String? sha256,
    DateTime? createdAt,
  }) => AttachmentRow(
    id: id ?? this.id,
    txId: txId ?? this.txId,
    fileName: fileName ?? this.fileName,
    localPath: localPath ?? this.localPath,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    sha256: sha256 ?? this.sha256,
    createdAt: createdAt ?? this.createdAt,
  );
  AttachmentRow copyWithCompanion(AttachmentsCompanion data) {
    return AttachmentRow(
      id: data.id.present ? data.id.value : this.id,
      txId: data.txId.present ? data.txId.value : this.txId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentRow(')
          ..write('id: $id, ')
          ..write('txId: $txId, ')
          ..write('fileName: $fileName, ')
          ..write('localPath: $localPath, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('sha256: $sha256, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    txId,
    fileName,
    localPath,
    mimeType,
    sizeBytes,
    sha256,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttachmentRow &&
          other.id == this.id &&
          other.txId == this.txId &&
          other.fileName == this.fileName &&
          other.localPath == this.localPath &&
          other.mimeType == this.mimeType &&
          other.sizeBytes == this.sizeBytes &&
          other.sha256 == this.sha256 &&
          other.createdAt == this.createdAt);
}

class AttachmentsCompanion extends UpdateCompanion<AttachmentRow> {
  final Value<String> id;
  final Value<String> txId;
  final Value<String> fileName;
  final Value<String> localPath;
  final Value<String?> mimeType;
  final Value<int> sizeBytes;
  final Value<String> sha256;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.txId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.localPath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    required String id,
    required String txId,
    required String fileName,
    required String localPath,
    this.mimeType = const Value.absent(),
    required int sizeBytes,
    required String sha256,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       txId = Value(txId),
       fileName = Value(fileName),
       localPath = Value(localPath),
       sizeBytes = Value(sizeBytes),
       sha256 = Value(sha256),
       createdAt = Value(createdAt);
  static Insertable<AttachmentRow> custom({
    Expression<String>? id,
    Expression<String>? txId,
    Expression<String>? fileName,
    Expression<String>? localPath,
    Expression<String>? mimeType,
    Expression<int>? sizeBytes,
    Expression<String>? sha256,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (txId != null) 'tx_id': txId,
      if (fileName != null) 'file_name': fileName,
      if (localPath != null) 'local_path': localPath,
      if (mimeType != null) 'mime_type': mimeType,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (sha256 != null) 'sha256': sha256,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttachmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? txId,
    Value<String>? fileName,
    Value<String>? localPath,
    Value<String?>? mimeType,
    Value<int>? sizeBytes,
    Value<String>? sha256,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      txId: txId ?? this.txId,
      fileName: fileName ?? this.fileName,
      localPath: localPath ?? this.localPath,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      sha256: sha256 ?? this.sha256,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (txId.present) {
      map['tx_id'] = Variable<String>(txId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('txId: $txId, ')
          ..write('fileName: $fileName, ')
          ..write('localPath: $localPath, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('sha256: $sha256, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReconSessionsTable extends ReconSessions
    with TableInfo<$ReconSessionsTable, ReconSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReconSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledger_accounts (id)',
    ),
  );
  static const VerificationMeta _fundIdMeta = const VerificationMeta('fundId');
  @override
  late final GeneratedColumn<String> fundId = GeneratedColumn<String>(
    'fund_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _asOfDateKeyMeta = const VerificationMeta(
    'asOfDateKey',
  );
  @override
  late final GeneratedColumn<int> asOfDateKey = GeneratedColumn<int>(
    'as_of_date_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedBalanceMeta = const VerificationMeta(
    'expectedBalance',
  );
  @override
  late final GeneratedColumn<int> expectedBalance = GeneratedColumn<int>(
    'expected_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualBalanceMeta = const VerificationMeta(
    'actualBalance',
  );
  @override
  late final GeneratedColumn<int> actualBalance = GeneratedColumn<int>(
    'actual_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _adjustmentTxIdMeta = const VerificationMeta(
    'adjustmentTxId',
  );
  @override
  late final GeneratedColumn<String> adjustmentTxId = GeneratedColumn<String>(
    'adjustment_tx_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _approvedByMeta = const VerificationMeta(
    'approvedBy',
  );
  @override
  late final GeneratedColumn<String> approvedBy = GeneratedColumn<String>(
    'approved_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _approvedAtMeta = const VerificationMeta(
    'approvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> approvedAt = GeneratedColumn<DateTime>(
    'approved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncStatus>($ReconSessionsTable.$convertersyncStatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    fundId,
    asOfDateKey,
    expectedBalance,
    actualBalance,
    status,
    notes,
    adjustmentTxId,
    createdBy,
    createdAt,
    approvedBy,
    approvedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recon_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReconSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('fund_id')) {
      context.handle(
        _fundIdMeta,
        fundId.isAcceptableOrUnknown(data['fund_id']!, _fundIdMeta),
      );
    }
    if (data.containsKey('as_of_date_key')) {
      context.handle(
        _asOfDateKeyMeta,
        asOfDateKey.isAcceptableOrUnknown(
          data['as_of_date_key']!,
          _asOfDateKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_asOfDateKeyMeta);
    }
    if (data.containsKey('expected_balance')) {
      context.handle(
        _expectedBalanceMeta,
        expectedBalance.isAcceptableOrUnknown(
          data['expected_balance']!,
          _expectedBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expectedBalanceMeta);
    }
    if (data.containsKey('actual_balance')) {
      context.handle(
        _actualBalanceMeta,
        actualBalance.isAcceptableOrUnknown(
          data['actual_balance']!,
          _actualBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualBalanceMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('adjustment_tx_id')) {
      context.handle(
        _adjustmentTxIdMeta,
        adjustmentTxId.isAcceptableOrUnknown(
          data['adjustment_tx_id']!,
          _adjustmentTxIdMeta,
        ),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('approved_by')) {
      context.handle(
        _approvedByMeta,
        approvedBy.isAcceptableOrUnknown(data['approved_by']!, _approvedByMeta),
      );
    }
    if (data.containsKey('approved_at')) {
      context.handle(
        _approvedAtMeta,
        approvedAt.isAcceptableOrUnknown(data['approved_at']!, _approvedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReconSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReconSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      fundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fund_id'],
      ),
      asOfDateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}as_of_date_key'],
      )!,
      expectedBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_balance'],
      )!,
      actualBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_balance'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      adjustmentTxId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adjustment_tx_id'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      approvedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approved_by'],
      ),
      approvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}approved_at'],
      ),
      syncStatus: $ReconSessionsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
    );
  }

  @override
  $ReconSessionsTable createAlias(String alias) {
    return $ReconSessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class ReconSessionRow extends DataClass implements Insertable<ReconSessionRow> {
  final String id;
  final String accountId;
  final String? fundId;
  final int asOfDateKey;
  final int expectedBalance;
  final int actualBalance;

  /// open | matched | adjusted | pendingApproval | unresolved
  final String status;
  final String? notes;
  final String? adjustmentTxId;
  final String createdBy;
  final DateTime createdAt;
  final String? approvedBy;
  final DateTime? approvedAt;
  final SyncStatus syncStatus;
  const ReconSessionRow({
    required this.id,
    required this.accountId,
    this.fundId,
    required this.asOfDateKey,
    required this.expectedBalance,
    required this.actualBalance,
    required this.status,
    this.notes,
    this.adjustmentTxId,
    required this.createdBy,
    required this.createdAt,
    this.approvedBy,
    this.approvedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || fundId != null) {
      map['fund_id'] = Variable<String>(fundId);
    }
    map['as_of_date_key'] = Variable<int>(asOfDateKey);
    map['expected_balance'] = Variable<int>(expectedBalance);
    map['actual_balance'] = Variable<int>(actualBalance);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || adjustmentTxId != null) {
      map['adjustment_tx_id'] = Variable<String>(adjustmentTxId);
    }
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || approvedBy != null) {
      map['approved_by'] = Variable<String>(approvedBy);
    }
    if (!nullToAbsent || approvedAt != null) {
      map['approved_at'] = Variable<DateTime>(approvedAt);
    }
    {
      map['sync_status'] = Variable<String>(
        $ReconSessionsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    return map;
  }

  ReconSessionsCompanion toCompanion(bool nullToAbsent) {
    return ReconSessionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      fundId: fundId == null && nullToAbsent
          ? const Value.absent()
          : Value(fundId),
      asOfDateKey: Value(asOfDateKey),
      expectedBalance: Value(expectedBalance),
      actualBalance: Value(actualBalance),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      adjustmentTxId: adjustmentTxId == null && nullToAbsent
          ? const Value.absent()
          : Value(adjustmentTxId),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      approvedBy: approvedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedBy),
      approvedAt: approvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory ReconSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReconSessionRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      fundId: serializer.fromJson<String?>(json['fundId']),
      asOfDateKey: serializer.fromJson<int>(json['asOfDateKey']),
      expectedBalance: serializer.fromJson<int>(json['expectedBalance']),
      actualBalance: serializer.fromJson<int>(json['actualBalance']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      adjustmentTxId: serializer.fromJson<String?>(json['adjustmentTxId']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      approvedBy: serializer.fromJson<String?>(json['approvedBy']),
      approvedAt: serializer.fromJson<DateTime?>(json['approvedAt']),
      syncStatus: $ReconSessionsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'fundId': serializer.toJson<String?>(fundId),
      'asOfDateKey': serializer.toJson<int>(asOfDateKey),
      'expectedBalance': serializer.toJson<int>(expectedBalance),
      'actualBalance': serializer.toJson<int>(actualBalance),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'adjustmentTxId': serializer.toJson<String?>(adjustmentTxId),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'approvedBy': serializer.toJson<String?>(approvedBy),
      'approvedAt': serializer.toJson<DateTime?>(approvedAt),
      'syncStatus': serializer.toJson<String>(
        $ReconSessionsTable.$convertersyncStatus.toJson(syncStatus),
      ),
    };
  }

  ReconSessionRow copyWith({
    String? id,
    String? accountId,
    Value<String?> fundId = const Value.absent(),
    int? asOfDateKey,
    int? expectedBalance,
    int? actualBalance,
    String? status,
    Value<String?> notes = const Value.absent(),
    Value<String?> adjustmentTxId = const Value.absent(),
    String? createdBy,
    DateTime? createdAt,
    Value<String?> approvedBy = const Value.absent(),
    Value<DateTime?> approvedAt = const Value.absent(),
    SyncStatus? syncStatus,
  }) => ReconSessionRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    fundId: fundId.present ? fundId.value : this.fundId,
    asOfDateKey: asOfDateKey ?? this.asOfDateKey,
    expectedBalance: expectedBalance ?? this.expectedBalance,
    actualBalance: actualBalance ?? this.actualBalance,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    adjustmentTxId: adjustmentTxId.present
        ? adjustmentTxId.value
        : this.adjustmentTxId,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    approvedBy: approvedBy.present ? approvedBy.value : this.approvedBy,
    approvedAt: approvedAt.present ? approvedAt.value : this.approvedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  ReconSessionRow copyWithCompanion(ReconSessionsCompanion data) {
    return ReconSessionRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      fundId: data.fundId.present ? data.fundId.value : this.fundId,
      asOfDateKey: data.asOfDateKey.present
          ? data.asOfDateKey.value
          : this.asOfDateKey,
      expectedBalance: data.expectedBalance.present
          ? data.expectedBalance.value
          : this.expectedBalance,
      actualBalance: data.actualBalance.present
          ? data.actualBalance.value
          : this.actualBalance,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      adjustmentTxId: data.adjustmentTxId.present
          ? data.adjustmentTxId.value
          : this.adjustmentTxId,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      approvedBy: data.approvedBy.present
          ? data.approvedBy.value
          : this.approvedBy,
      approvedAt: data.approvedAt.present
          ? data.approvedAt.value
          : this.approvedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReconSessionRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('fundId: $fundId, ')
          ..write('asOfDateKey: $asOfDateKey, ')
          ..write('expectedBalance: $expectedBalance, ')
          ..write('actualBalance: $actualBalance, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('adjustmentTxId: $adjustmentTxId, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    fundId,
    asOfDateKey,
    expectedBalance,
    actualBalance,
    status,
    notes,
    adjustmentTxId,
    createdBy,
    createdAt,
    approvedBy,
    approvedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReconSessionRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.fundId == this.fundId &&
          other.asOfDateKey == this.asOfDateKey &&
          other.expectedBalance == this.expectedBalance &&
          other.actualBalance == this.actualBalance &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.adjustmentTxId == this.adjustmentTxId &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.approvedBy == this.approvedBy &&
          other.approvedAt == this.approvedAt &&
          other.syncStatus == this.syncStatus);
}

class ReconSessionsCompanion extends UpdateCompanion<ReconSessionRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String?> fundId;
  final Value<int> asOfDateKey;
  final Value<int> expectedBalance;
  final Value<int> actualBalance;
  final Value<String> status;
  final Value<String?> notes;
  final Value<String?> adjustmentTxId;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<String?> approvedBy;
  final Value<DateTime?> approvedAt;
  final Value<SyncStatus> syncStatus;
  final Value<int> rowid;
  const ReconSessionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.fundId = const Value.absent(),
    this.asOfDateKey = const Value.absent(),
    this.expectedBalance = const Value.absent(),
    this.actualBalance = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.adjustmentTxId = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReconSessionsCompanion.insert({
    required String id,
    required String accountId,
    this.fundId = const Value.absent(),
    required int asOfDateKey,
    required int expectedBalance,
    required int actualBalance,
    required String status,
    this.notes = const Value.absent(),
    this.adjustmentTxId = const Value.absent(),
    required String createdBy,
    required DateTime createdAt,
    this.approvedBy = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       asOfDateKey = Value(asOfDateKey),
       expectedBalance = Value(expectedBalance),
       actualBalance = Value(actualBalance),
       status = Value(status),
       createdBy = Value(createdBy),
       createdAt = Value(createdAt);
  static Insertable<ReconSessionRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? fundId,
    Expression<int>? asOfDateKey,
    Expression<int>? expectedBalance,
    Expression<int>? actualBalance,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<String>? adjustmentTxId,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<String>? approvedBy,
    Expression<DateTime>? approvedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (fundId != null) 'fund_id': fundId,
      if (asOfDateKey != null) 'as_of_date_key': asOfDateKey,
      if (expectedBalance != null) 'expected_balance': expectedBalance,
      if (actualBalance != null) 'actual_balance': actualBalance,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (adjustmentTxId != null) 'adjustment_tx_id': adjustmentTxId,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (approvedAt != null) 'approved_at': approvedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReconSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String?>? fundId,
    Value<int>? asOfDateKey,
    Value<int>? expectedBalance,
    Value<int>? actualBalance,
    Value<String>? status,
    Value<String?>? notes,
    Value<String?>? adjustmentTxId,
    Value<String>? createdBy,
    Value<DateTime>? createdAt,
    Value<String?>? approvedBy,
    Value<DateTime?>? approvedAt,
    Value<SyncStatus>? syncStatus,
    Value<int>? rowid,
  }) {
    return ReconSessionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      fundId: fundId ?? this.fundId,
      asOfDateKey: asOfDateKey ?? this.asOfDateKey,
      expectedBalance: expectedBalance ?? this.expectedBalance,
      actualBalance: actualBalance ?? this.actualBalance,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      adjustmentTxId: adjustmentTxId ?? this.adjustmentTxId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (fundId.present) {
      map['fund_id'] = Variable<String>(fundId.value);
    }
    if (asOfDateKey.present) {
      map['as_of_date_key'] = Variable<int>(asOfDateKey.value);
    }
    if (expectedBalance.present) {
      map['expected_balance'] = Variable<int>(expectedBalance.value);
    }
    if (actualBalance.present) {
      map['actual_balance'] = Variable<int>(actualBalance.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (adjustmentTxId.present) {
      map['adjustment_tx_id'] = Variable<String>(adjustmentTxId.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (approvedBy.present) {
      map['approved_by'] = Variable<String>(approvedBy.value);
    }
    if (approvedAt.present) {
      map['approved_at'] = Variable<DateTime>(approvedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $ReconSessionsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReconSessionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('fundId: $fundId, ')
          ..write('asOfDateKey: $asOfDateKey, ')
          ..write('expectedBalance: $expectedBalance, ')
          ..write('actualBalance: $actualBalance, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('adjustmentTxId: $adjustmentTxId, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditEventsTable extends AuditEvents
    with TableInfo<$AuditEventsTable, AuditRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actorIdMeta = const VerificationMeta(
    'actorId',
  );
  @override
  late final GeneratedColumn<String> actorId = GeneratedColumn<String>(
    'actor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prevHashMeta = const VerificationMeta(
    'prevHash',
  );
  @override
  late final GeneratedColumn<String> prevHash = GeneratedColumn<String>(
    'prev_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
    'hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncStatus>($AuditEventsTable.$convertersyncStatus);
  @override
  List<GeneratedColumn> get $columns => [
    seq,
    eventId,
    at,
    actorId,
    entityType,
    entityId,
    action,
    details,
    prevHash,
    hash,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('actor_id')) {
      context.handle(
        _actorIdMeta,
        actorId.isAcceptableOrUnknown(data['actor_id']!, _actorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actorIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('prev_hash')) {
      context.handle(
        _prevHashMeta,
        prevHash.isAcceptableOrUnknown(data['prev_hash']!, _prevHashMeta),
      );
    } else if (isInserting) {
      context.missing(_prevHashMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
        _hashMeta,
        hash.isAcceptableOrUnknown(data['hash']!, _hashMeta),
      );
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seq};
  @override
  AuditRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditRow(
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      actorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      prevHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prev_hash'],
      )!,
      hash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hash'],
      )!,
      syncStatus: $AuditEventsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
    );
  }

  @override
  $AuditEventsTable createAlias(String alias) {
    return $AuditEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class AuditRow extends DataClass implements Insertable<AuditRow> {
  final int seq;
  final String eventId;
  final DateTime at;
  final String actorId;
  final String entityType;
  final String entityId;
  final String action;
  final String? details;
  final String prevHash;
  final String hash;
  final SyncStatus syncStatus;
  const AuditRow({
    required this.seq,
    required this.eventId,
    required this.at,
    required this.actorId,
    required this.entityType,
    required this.entityId,
    required this.action,
    this.details,
    required this.prevHash,
    required this.hash,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seq'] = Variable<int>(seq);
    map['event_id'] = Variable<String>(eventId);
    map['at'] = Variable<DateTime>(at);
    map['actor_id'] = Variable<String>(actorId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['prev_hash'] = Variable<String>(prevHash);
    map['hash'] = Variable<String>(hash);
    {
      map['sync_status'] = Variable<String>(
        $AuditEventsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    return map;
  }

  AuditEventsCompanion toCompanion(bool nullToAbsent) {
    return AuditEventsCompanion(
      seq: Value(seq),
      eventId: Value(eventId),
      at: Value(at),
      actorId: Value(actorId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: Value(action),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      prevHash: Value(prevHash),
      hash: Value(hash),
      syncStatus: Value(syncStatus),
    );
  }

  factory AuditRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditRow(
      seq: serializer.fromJson<int>(json['seq']),
      eventId: serializer.fromJson<String>(json['eventId']),
      at: serializer.fromJson<DateTime>(json['at']),
      actorId: serializer.fromJson<String>(json['actorId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      details: serializer.fromJson<String?>(json['details']),
      prevHash: serializer.fromJson<String>(json['prevHash']),
      hash: serializer.fromJson<String>(json['hash']),
      syncStatus: $AuditEventsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seq': serializer.toJson<int>(seq),
      'eventId': serializer.toJson<String>(eventId),
      'at': serializer.toJson<DateTime>(at),
      'actorId': serializer.toJson<String>(actorId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'action': serializer.toJson<String>(action),
      'details': serializer.toJson<String?>(details),
      'prevHash': serializer.toJson<String>(prevHash),
      'hash': serializer.toJson<String>(hash),
      'syncStatus': serializer.toJson<String>(
        $AuditEventsTable.$convertersyncStatus.toJson(syncStatus),
      ),
    };
  }

  AuditRow copyWith({
    int? seq,
    String? eventId,
    DateTime? at,
    String? actorId,
    String? entityType,
    String? entityId,
    String? action,
    Value<String?> details = const Value.absent(),
    String? prevHash,
    String? hash,
    SyncStatus? syncStatus,
  }) => AuditRow(
    seq: seq ?? this.seq,
    eventId: eventId ?? this.eventId,
    at: at ?? this.at,
    actorId: actorId ?? this.actorId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    action: action ?? this.action,
    details: details.present ? details.value : this.details,
    prevHash: prevHash ?? this.prevHash,
    hash: hash ?? this.hash,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  AuditRow copyWithCompanion(AuditEventsCompanion data) {
    return AuditRow(
      seq: data.seq.present ? data.seq.value : this.seq,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      at: data.at.present ? data.at.value : this.at,
      actorId: data.actorId.present ? data.actorId.value : this.actorId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      details: data.details.present ? data.details.value : this.details,
      prevHash: data.prevHash.present ? data.prevHash.value : this.prevHash,
      hash: data.hash.present ? data.hash.value : this.hash,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditRow(')
          ..write('seq: $seq, ')
          ..write('eventId: $eventId, ')
          ..write('at: $at, ')
          ..write('actorId: $actorId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('details: $details, ')
          ..write('prevHash: $prevHash, ')
          ..write('hash: $hash, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    seq,
    eventId,
    at,
    actorId,
    entityType,
    entityId,
    action,
    details,
    prevHash,
    hash,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditRow &&
          other.seq == this.seq &&
          other.eventId == this.eventId &&
          other.at == this.at &&
          other.actorId == this.actorId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.details == this.details &&
          other.prevHash == this.prevHash &&
          other.hash == this.hash &&
          other.syncStatus == this.syncStatus);
}

class AuditEventsCompanion extends UpdateCompanion<AuditRow> {
  final Value<int> seq;
  final Value<String> eventId;
  final Value<DateTime> at;
  final Value<String> actorId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> action;
  final Value<String?> details;
  final Value<String> prevHash;
  final Value<String> hash;
  final Value<SyncStatus> syncStatus;
  const AuditEventsCompanion({
    this.seq = const Value.absent(),
    this.eventId = const Value.absent(),
    this.at = const Value.absent(),
    this.actorId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.details = const Value.absent(),
    this.prevHash = const Value.absent(),
    this.hash = const Value.absent(),
    this.syncStatus = const Value.absent(),
  });
  AuditEventsCompanion.insert({
    this.seq = const Value.absent(),
    required String eventId,
    required DateTime at,
    required String actorId,
    required String entityType,
    required String entityId,
    required String action,
    this.details = const Value.absent(),
    required String prevHash,
    required String hash,
    this.syncStatus = const Value.absent(),
  }) : eventId = Value(eventId),
       at = Value(at),
       actorId = Value(actorId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       action = Value(action),
       prevHash = Value(prevHash),
       hash = Value(hash);
  static Insertable<AuditRow> custom({
    Expression<int>? seq,
    Expression<String>? eventId,
    Expression<DateTime>? at,
    Expression<String>? actorId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<String>? details,
    Expression<String>? prevHash,
    Expression<String>? hash,
    Expression<String>? syncStatus,
  }) {
    return RawValuesInsertable({
      if (seq != null) 'seq': seq,
      if (eventId != null) 'event_id': eventId,
      if (at != null) 'at': at,
      if (actorId != null) 'actor_id': actorId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (details != null) 'details': details,
      if (prevHash != null) 'prev_hash': prevHash,
      if (hash != null) 'hash': hash,
      if (syncStatus != null) 'sync_status': syncStatus,
    });
  }

  AuditEventsCompanion copyWith({
    Value<int>? seq,
    Value<String>? eventId,
    Value<DateTime>? at,
    Value<String>? actorId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? action,
    Value<String?>? details,
    Value<String>? prevHash,
    Value<String>? hash,
    Value<SyncStatus>? syncStatus,
  }) {
    return AuditEventsCompanion(
      seq: seq ?? this.seq,
      eventId: eventId ?? this.eventId,
      at: at ?? this.at,
      actorId: actorId ?? this.actorId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      details: details ?? this.details,
      prevHash: prevHash ?? this.prevHash,
      hash: hash ?? this.hash,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (actorId.present) {
      map['actor_id'] = Variable<String>(actorId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (prevHash.present) {
      map['prev_hash'] = Variable<String>(prevHash.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $AuditEventsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditEventsCompanion(')
          ..write('seq: $seq, ')
          ..write('eventId: $eventId, ')
          ..write('at: $at, ')
          ..write('actorId: $actorId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('details: $details, ')
          ..write('prevHash: $prevHash, ')
          ..write('hash: $hash, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    seq,
    entityType,
    entityId,
    operation,
    createdAt,
    attempts,
    nextAttemptAt,
    lastError,
    state,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextAttemptAtMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seq};
  @override
  OutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxRow(
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }
}

class OutboxRow extends DataClass implements Insertable<OutboxRow> {
  final int seq;
  final String entityType;
  final String entityId;
  final String operation;
  final DateTime createdAt;
  final int attempts;
  final DateTime nextAttemptAt;
  final String? lastError;

  /// pending | failed | conflict
  final String state;
  const OutboxRow({
    required this.seq,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.createdAt,
    required this.attempts,
    required this.nextAttemptAt,
    this.lastError,
    required this.state,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seq'] = Variable<int>(seq);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['state'] = Variable<String>(state);
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      seq: Value(seq),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      nextAttemptAt: Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      state: Value(state),
    );
  }

  factory OutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxRow(
      seq: serializer.fromJson<int>(json['seq']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<DateTime>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      state: serializer.fromJson<String>(json['state']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seq': serializer.toJson<int>(seq),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'nextAttemptAt': serializer.toJson<DateTime>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'state': serializer.toJson<String>(state),
    };
  }

  OutboxRow copyWith({
    int? seq,
    String? entityType,
    String? entityId,
    String? operation,
    DateTime? createdAt,
    int? attempts,
    DateTime? nextAttemptAt,
    Value<String?> lastError = const Value.absent(),
    String? state,
  }) => OutboxRow(
    seq: seq ?? this.seq,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    state: state ?? this.state,
  );
  OutboxRow copyWithCompanion(OutboxCompanion data) {
    return OutboxRow(
      seq: data.seq.present ? data.seq.value : this.seq,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxRow(')
          ..write('seq: $seq, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    seq,
    entityType,
    entityId,
    operation,
    createdAt,
    attempts,
    nextAttemptAt,
    lastError,
    state,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxRow &&
          other.seq == this.seq &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.state == this.state);
}

class OutboxCompanion extends UpdateCompanion<OutboxRow> {
  final Value<int> seq;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<DateTime> nextAttemptAt;
  final Value<String?> lastError;
  final Value<String> state;
  const OutboxCompanion({
    this.seq = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.state = const Value.absent(),
  });
  OutboxCompanion.insert({
    this.seq = const Value.absent(),
    required String entityType,
    required String entityId,
    required String operation,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    required DateTime nextAttemptAt,
    this.lastError = const Value.absent(),
    this.state = const Value.absent(),
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       createdAt = Value(createdAt),
       nextAttemptAt = Value(nextAttemptAt);
  static Insertable<OutboxRow> custom({
    Expression<int>? seq,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<String>? state,
  }) {
    return RawValuesInsertable({
      if (seq != null) 'seq': seq,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (state != null) 'state': state,
    });
  }

  OutboxCompanion copyWith({
    Value<int>? seq,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<DateTime>? nextAttemptAt,
    Value<String?>? lastError,
    Value<String>? state,
  }) {
    return OutboxCompanion(
      seq: seq ?? this.seq,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      state: state ?? this.state,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('seq: $seq, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }
}

class $KeyValuesTable extends KeyValues with TableInfo<$KeyValuesTable, KvRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeyValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'key_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<KvRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  KvRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KvRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $KeyValuesTable createAlias(String alias) {
    return $KeyValuesTable(attachedDatabase, alias);
  }
}

class KvRow extends DataClass implements Insertable<KvRow> {
  final String key;
  final String value;
  const KvRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  KeyValuesCompanion toCompanion(bool nullToAbsent) {
    return KeyValuesCompanion(key: Value(key), value: Value(value));
  }

  factory KvRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KvRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  KvRow copyWith({String? key, String? value}) =>
      KvRow(key: key ?? this.key, value: value ?? this.value);
  KvRow copyWithCompanion(KeyValuesCompanion data) {
    return KvRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KvRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KvRow && other.key == this.key && other.value == this.value);
}

class KeyValuesCompanion extends UpdateCompanion<KvRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const KeyValuesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeyValuesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<KvRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeyValuesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return KeyValuesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeyValuesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PersonsTable persons = $PersonsTable(this);
  late final $FundsTable funds = $FundsTable(this);
  late final $LedgerAccountsTable ledgerAccounts = $LedgerAccountsTable(this);
  late final $ObligationsTable obligations = $ObligationsTable(this);
  late final $SamitiesTable samities = $SamitiesTable(this);
  late final $SamityMembersTable samityMembers = $SamityMembersTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $LedgerTransactionsTable ledgerTransactions =
      $LedgerTransactionsTable(this);
  late final $TransactionLinesTable transactionLines = $TransactionLinesTable(
    this,
  );
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  late final $ReconSessionsTable reconSessions = $ReconSessionsTable(this);
  late final $AuditEventsTable auditEvents = $AuditEventsTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  late final $KeyValuesTable keyValues = $KeyValuesTable(this);
  late final Index txStatusDate = Index(
    'tx_status_date',
    'CREATE INDEX tx_status_date ON ledger_transactions (status, date_key, sort_key)',
  );
  late final Index txPerson = Index(
    'tx_person',
    'CREATE INDEX tx_person ON ledger_transactions (person_id)',
  );
  late final Index txObligation = Index(
    'tx_obligation',
    'CREATE INDEX tx_obligation ON ledger_transactions (obligation_id)',
  );
  late final Index txSamity = Index(
    'tx_samity',
    'CREATE INDEX tx_samity ON ledger_transactions (samity_id)',
  );
  late final Index txSync = Index(
    'tx_sync',
    'CREATE INDEX tx_sync ON ledger_transactions (sync_status)',
  );
  late final Index lineAccount = Index(
    'line_account',
    'CREATE INDEX line_account ON transaction_lines (account_id, fund_id)',
  );
  late final Index lineFund = Index(
    'line_fund',
    'CREATE INDEX line_fund ON transaction_lines (fund_id)',
  );
  late final Index linePerson = Index(
    'line_person',
    'CREATE INDEX line_person ON transaction_lines (person_id, account_id)',
  );
  late final Index auditEntity = Index(
    'audit_entity',
    'CREATE INDEX audit_entity ON audit_events (entity_type, entity_id)',
  );
  late final Index outboxState = Index(
    'outbox_state',
    'CREATE INDEX outbox_state ON outbox (state, next_attempt_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    persons,
    funds,
    ledgerAccounts,
    obligations,
    samities,
    samityMembers,
    budgets,
    ledgerTransactions,
    transactionLines,
    attachments,
    reconSessions,
    auditEvents,
    outbox,
    keyValues,
    txStatusDate,
    txPerson,
    txObligation,
    txSamity,
    txSync,
    lineAccount,
    lineFund,
    linePerson,
    auditEntity,
    outboxState,
  ];
}

typedef $$PersonsTableCreateCompanionBuilder = PersonsCompanion Function({
  Value<int> version,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<SyncStatus> syncStatus,
  required String id,
  required String name,
  Value<String> relation,
  Value<String?> phone,
  Value<String?> notes,
  Value<bool> isSelf,
  Value<bool> archived,
  Value<int> rowid,
});
typedef $$PersonsTableUpdateCompanionBuilder = PersonsCompanion Function({
  Value<int> version,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String> id,
  Value<String> name,
  Value<String> relation,
  Value<String?> phone,
  Value<String?> notes,
  Value<bool> isSelf,
  Value<bool> archived,
  Value<int> rowid,
});

final class $$PersonsTableReferences
    extends BaseReferences<_$AppDatabase, $PersonsTable, PersonRow> {
  $$PersonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FundsTable, List<FundRow>> _fundsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.funds,
    aliasName: 'persons__id__funds__owner_person_id',
  );

  $$FundsTableProcessedTableManager get fundsRefs {
    final manager = $$FundsTableTableManager(
      $_db,
      $_db.funds,
    ).filter((f) => f.ownerPersonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_fundsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ObligationsTable, List<ObligationRow>>
  _obligationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.obligations,
    aliasName: 'persons__id__obligations__person_id',
  );

  $$ObligationsTableProcessedTableManager get obligationsRefs {
    final manager = $$ObligationsTableTableManager(
      $_db,
      $_db.obligations,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_obligationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SamityMembersTable, List<SamityMemberRow>>
  _samityMembersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.samityMembers,
    aliasName: 'persons__id__samity_members__person_id',
  );

  $$SamityMembersTableProcessedTableManager get samityMembersRefs {
    final manager = $$SamityMembersTableTableManager(
      $_db,
      $_db.samityMembers,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_samityMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PersonsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSelf => $composableBuilder(
    column: $table.isSelf,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fundsRefs(
    Expression<bool> Function($$FundsTableFilterComposer f) f,
  ) {
    final $$FundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.funds,
      getReferencedColumn: (t) => t.ownerPersonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundsTableFilterComposer(
            $db: $db,
            $table: $db.funds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> obligationsRefs(
    Expression<bool> Function($$ObligationsTableFilterComposer f) f,
  ) {
    final $$ObligationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligations,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationsTableFilterComposer(
            $db: $db,
            $table: $db.obligations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> samityMembersRefs(
    Expression<bool> Function($$SamityMembersTableFilterComposer f) f,
  ) {
    final $$SamityMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.samityMembers,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamityMembersTableFilterComposer(
            $db: $db,
            $table: $db.samityMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersonsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSelf => $composableBuilder(
    column: $table.isSelf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get relation =>
      $composableBuilder(column: $table.relation, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isSelf =>
      $composableBuilder(column: $table.isSelf, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> fundsRefs<T extends Object>(
    Expression<T> Function($$FundsTableAnnotationComposer a) f,
  ) {
    final $$FundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.funds,
      getReferencedColumn: (t) => t.ownerPersonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundsTableAnnotationComposer(
            $db: $db,
            $table: $db.funds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> obligationsRefs<T extends Object>(
    Expression<T> Function($$ObligationsTableAnnotationComposer a) f,
  ) {
    final $$ObligationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligations,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationsTableAnnotationComposer(
            $db: $db,
            $table: $db.obligations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> samityMembersRefs<T extends Object>(
    Expression<T> Function($$SamityMembersTableAnnotationComposer a) f,
  ) {
    final $$SamityMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.samityMembers,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamityMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.samityMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonsTable,
          PersonRow,
          $$PersonsTableFilterComposer,
          $$PersonsTableOrderingComposer,
          $$PersonsTableAnnotationComposer,
          $$PersonsTableCreateCompanionBuilder,
          $$PersonsTableUpdateCompanionBuilder,
          (PersonRow, $$PersonsTableReferences),
          PersonRow,
          PrefetchHooks Function({
            bool fundsRefs,
            bool obligationsRefs,
            bool samityMembersRefs,
          })
        > {
  $$PersonsTableTableManager(_$AppDatabase db, $PersonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> relation = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSelf = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonsCompanion(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                id: id,
                name: name,
                relation: relation,
                phone: phone,
                notes: notes,
                isSelf: isSelf,
                archived: archived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<SyncStatus> syncStatus = const Value.absent(),
                required String id,
                required String name,
                Value<String> relation = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSelf = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonsCompanion.insert(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                id: id,
                name: name,
                relation: relation,
                phone: phone,
                notes: notes,
                isSelf: isSelf,
                archived: archived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PersonsTable, PersonRow>(table),
                  $$PersonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                fundsRefs = false,
                obligationsRefs = false,
                samityMembersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fundsRefs) db.funds,
                    if (obligationsRefs) db.obligations,
                    if (samityMembersRefs) db.samityMembers,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fundsRefs)
                        await $_getPrefetchedDataByColumns<
                          PersonRow,
                          $PersonsTable,
                          FundRow,
                          $FundsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._fundsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(db, table, p0).fundsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'owner_person_id',
                          typedResults: items,
                        ),
                      if (obligationsRefs)
                        await $_getPrefetchedDataByColumns<
                          PersonRow,
                          $PersonsTable,
                          ObligationRow,
                          $ObligationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._obligationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).obligationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'person_id',
                          typedResults: items,
                        ),
                      if (samityMembersRefs)
                        await $_getPrefetchedDataByColumns<
                          PersonRow,
                          $PersonsTable,
                          SamityMemberRow,
                          $SamityMembersTable
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._samityMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).samityMembersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'person_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PersonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonsTable,
      PersonRow,
      $$PersonsTableFilterComposer,
      $$PersonsTableOrderingComposer,
      $$PersonsTableAnnotationComposer,
      $$PersonsTableCreateCompanionBuilder,
      $$PersonsTableUpdateCompanionBuilder,
      (PersonRow, $$PersonsTableReferences),
      PersonRow,
      PrefetchHooks Function({
        bool fundsRefs,
        bool obligationsRefs,
        bool samityMembersRefs,
      })
    >;
typedef $$FundsTableCreateCompanionBuilder = FundsCompanion Function({
  Value<int> version,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<SyncStatus> syncStatus,
  required String id,
  required String name,
  required FundKind kind,
  Value<String?> ownerPersonId,
  Value<String?> description,
  Value<bool> archived,
  Value<int> rowid,
});
typedef $$FundsTableUpdateCompanionBuilder = FundsCompanion Function({
  Value<int> version,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String> id,
  Value<String> name,
  Value<FundKind> kind,
  Value<String?> ownerPersonId,
  Value<String?> description,
  Value<bool> archived,
  Value<int> rowid,
});

final class $$FundsTableReferences
    extends BaseReferences<_$AppDatabase, $FundsTable, FundRow> {
  $$FundsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonsTable _ownerPersonIdTable(_$AppDatabase db) =>
      db.persons.createAlias('funds__owner_person_id__persons__id');

  $$PersonsTableProcessedTableManager? get ownerPersonId {
    final $_column = $_itemColumn<String>('owner_person_id');
    if ($_column == null) return null;
    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerPersonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ObligationsTable, List<ObligationRow>>
  _obligationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.obligations,
    aliasName: 'funds__id__obligations__fund_id',
  );

  $$ObligationsTableProcessedTableManager get obligationsRefs {
    final manager = $$ObligationsTableTableManager(
      $_db,
      $_db.obligations,
    ).filter((f) => f.fundId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_obligationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SamitiesTable, List<SamityRow>>
  _samitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.samities,
    aliasName: 'funds__id__samities__fund_id',
  );

  $$SamitiesTableProcessedTableManager get samitiesRefs {
    final manager = $$SamitiesTableTableManager(
      $_db,
      $_db.samities,
    ).filter((f) => f.fundId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_samitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionLinesTable, List<LineRow>>
  _transactionLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionLines,
    aliasName: 'funds__id__transaction_lines__fund_id',
  );

  $$TransactionLinesTableProcessedTableManager get transactionLinesRefs {
    final manager = $$TransactionLinesTableTableManager(
      $_db,
      $_db.transactionLines,
    ).filter((f) => f.fundId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FundsTableFilterComposer extends Composer<_$AppDatabase, $FundsTable> {
  $$FundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FundKind, FundKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonsTableFilterComposer get ownerPersonId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerPersonId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> obligationsRefs(
    Expression<bool> Function($$ObligationsTableFilterComposer f) f,
  ) {
    final $$ObligationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligations,
      getReferencedColumn: (t) => t.fundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationsTableFilterComposer(
            $db: $db,
            $table: $db.obligations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> samitiesRefs(
    Expression<bool> Function($$SamitiesTableFilterComposer f) f,
  ) {
    final $$SamitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.samities,
      getReferencedColumn: (t) => t.fundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamitiesTableFilterComposer(
            $db: $db,
            $table: $db.samities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionLinesRefs(
    Expression<bool> Function($$TransactionLinesTableFilterComposer f) f,
  ) {
    final $$TransactionLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.fundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableFilterComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FundsTableOrderingComposer
    extends Composer<_$AppDatabase, $FundsTable> {
  $$FundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonsTableOrderingComposer get ownerPersonId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerPersonId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FundsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FundsTable> {
  $$FundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FundKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  $$PersonsTableAnnotationComposer get ownerPersonId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerPersonId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> obligationsRefs<T extends Object>(
    Expression<T> Function($$ObligationsTableAnnotationComposer a) f,
  ) {
    final $$ObligationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligations,
      getReferencedColumn: (t) => t.fundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationsTableAnnotationComposer(
            $db: $db,
            $table: $db.obligations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> samitiesRefs<T extends Object>(
    Expression<T> Function($$SamitiesTableAnnotationComposer a) f,
  ) {
    final $$SamitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.samities,
      getReferencedColumn: (t) => t.fundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.samities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionLinesRefs<T extends Object>(
    Expression<T> Function($$TransactionLinesTableAnnotationComposer a) f,
  ) {
    final $$TransactionLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.fundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FundsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FundsTable,
          FundRow,
          $$FundsTableFilterComposer,
          $$FundsTableOrderingComposer,
          $$FundsTableAnnotationComposer,
          $$FundsTableCreateCompanionBuilder,
          $$FundsTableUpdateCompanionBuilder,
          (FundRow, $$FundsTableReferences),
          FundRow,
          PrefetchHooks Function({
            bool ownerPersonId,
            bool obligationsRefs,
            bool samitiesRefs,
            bool transactionLinesRefs,
          })
        > {
  $$FundsTableTableManager(_$AppDatabase db, $FundsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<FundKind> kind = const Value.absent(),
                Value<String?> ownerPersonId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FundsCompanion(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                id: id,
                name: name,
                kind: kind,
                ownerPersonId: ownerPersonId,
                description: description,
                archived: archived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<SyncStatus> syncStatus = const Value.absent(),
                required String id,
                required String name,
                required FundKind kind,
                Value<String?> ownerPersonId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FundsCompanion.insert(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                id: id,
                name: name,
                kind: kind,
                ownerPersonId: ownerPersonId,
                description: description,
                archived: archived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FundsTable, FundRow>(table),
                  $$FundsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ownerPersonId = false,
                obligationsRefs = false,
                samitiesRefs = false,
                transactionLinesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (obligationsRefs) db.obligations,
                    if (samitiesRefs) db.samities,
                    if (transactionLinesRefs) db.transactionLines,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ownerPersonId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.ownerPersonId,
                            referencedTable: $$FundsTableReferences
                                ._ownerPersonIdTable(db),
                            referencedColumn: $$FundsTableReferences
                                ._ownerPersonIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (obligationsRefs)
                        await $_getPrefetchedDataByColumns<
                          FundRow,
                          $FundsTable,
                          ObligationRow,
                          $ObligationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$FundsTableReferences
                              ._obligationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FundsTableReferences(
                                db,
                                table,
                                p0,
                              ).obligationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'fund_id',
                          typedResults: items,
                        ),
                      if (samitiesRefs)
                        await $_getPrefetchedDataByColumns<
                          FundRow,
                          $FundsTable,
                          SamityRow,
                          $SamitiesTable
                        >(
                          currentTable: table,
                          referencedTable: $$FundsTableReferences
                              ._samitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FundsTableReferences(
                                db,
                                table,
                                p0,
                              ).samitiesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'fund_id',
                          typedResults: items,
                        ),
                      if (transactionLinesRefs)
                        await $_getPrefetchedDataByColumns<
                          FundRow,
                          $FundsTable,
                          LineRow,
                          $TransactionLinesTable
                        >(
                          currentTable: table,
                          referencedTable: $$FundsTableReferences
                              ._transactionLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FundsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionLinesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'fund_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FundsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FundsTable,
      FundRow,
      $$FundsTableFilterComposer,
      $$FundsTableOrderingComposer,
      $$FundsTableAnnotationComposer,
      $$FundsTableCreateCompanionBuilder,
      $$FundsTableUpdateCompanionBuilder,
      (FundRow, $$FundsTableReferences),
      FundRow,
      PrefetchHooks Function({
        bool ownerPersonId,
        bool obligationsRefs,
        bool samitiesRefs,
        bool transactionLinesRefs,
      })
    >;
typedef $$LedgerAccountsTableCreateCompanionBuilder =
    LedgerAccountsCompanion Function({
      Value<int> version,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<SyncStatus> syncStatus,
      required String id,
      required LedgerAccountKind kind,
      required AccountClass accountClass,
      Value<StorageType?> storageType,
      required String name,
      Value<String?> nameBn,
      Value<String?> institution,
      Value<String?> numberHint,
      Value<String?> icon,
      Value<bool> isSystem,
      Value<bool> archived,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$LedgerAccountsTableUpdateCompanionBuilder =
    LedgerAccountsCompanion Function({
      Value<int> version,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<SyncStatus> syncStatus,
      Value<String> id,
      Value<LedgerAccountKind> kind,
      Value<AccountClass> accountClass,
      Value<StorageType?> storageType,
      Value<String> name,
      Value<String?> nameBn,
      Value<String?> institution,
      Value<String?> numberHint,
      Value<String?> icon,
      Value<bool> isSystem,
      Value<bool> archived,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$LedgerAccountsTableReferences
    extends
        BaseReferences<_$AppDatabase, $LedgerAccountsTable, LedgerAccountRow> {
  $$LedgerAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$BudgetsTable, List<BudgetRow>> _budgetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.budgets,
    aliasName: 'ledger_accounts__id__budgets__category_id',
  );

  $$BudgetsTableProcessedTableManager get budgetsRefs {
    final manager = $$BudgetsTableTableManager(
      $_db,
      $_db.budgets,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionLinesTable, List<LineRow>>
  _transactionLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionLines,
    aliasName: 'ledger_accounts__id__transaction_lines__account_id',
  );

  $$TransactionLinesTableProcessedTableManager get transactionLinesRefs {
    final manager = $$TransactionLinesTableTableManager(
      $_db,
      $_db.transactionLines,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReconSessionsTable, List<ReconSessionRow>>
  _reconSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reconSessions,
    aliasName: 'ledger_accounts__id__recon_sessions__account_id',
  );

  $$ReconSessionsTableProcessedTableManager get reconSessionsRefs {
    final manager = $$ReconSessionsTableTableManager(
      $_db,
      $_db.reconSessions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reconSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LedgerAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $LedgerAccountsTable> {
  $$LedgerAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LedgerAccountKind, LedgerAccountKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<AccountClass, AccountClass, String>
  get accountClass => $composableBuilder(
    column: $table.accountClass,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<StorageType?, StorageType, String>
  get storageType => $composableBuilder(
    column: $table.storageType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameBn => $composableBuilder(
    column: $table.nameBn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numberHint => $composableBuilder(
    column: $table.numberHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> budgetsRefs(
    Expression<bool> Function($$BudgetsTableFilterComposer f) f,
  ) {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableFilterComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionLinesRefs(
    Expression<bool> Function($$TransactionLinesTableFilterComposer f) f,
  ) {
    final $$TransactionLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableFilterComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reconSessionsRefs(
    Expression<bool> Function($$ReconSessionsTableFilterComposer f) f,
  ) {
    final $$ReconSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reconSessions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReconSessionsTableFilterComposer(
            $db: $db,
            $table: $db.reconSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LedgerAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgerAccountsTable> {
  $$LedgerAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountClass => $composableBuilder(
    column: $table.accountClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storageType => $composableBuilder(
    column: $table.storageType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameBn => $composableBuilder(
    column: $table.nameBn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numberHint => $composableBuilder(
    column: $table.numberHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LedgerAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgerAccountsTable> {
  $$LedgerAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LedgerAccountKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountClass, String> get accountClass =>
      $composableBuilder(
        column: $table.accountClass,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<StorageType?, String> get storageType =>
      $composableBuilder(
        column: $table.storageType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameBn =>
      $composableBuilder(column: $table.nameBn, builder: (column) => column);

  GeneratedColumn<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => column,
  );

  GeneratedColumn<String> get numberHint => $composableBuilder(
    column: $table.numberHint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> budgetsRefs<T extends Object>(
    Expression<T> Function($$BudgetsTableAnnotationComposer a) f,
  ) {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionLinesRefs<T extends Object>(
    Expression<T> Function($$TransactionLinesTableAnnotationComposer a) f,
  ) {
    final $$TransactionLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reconSessionsRefs<T extends Object>(
    Expression<T> Function($$ReconSessionsTableAnnotationComposer a) f,
  ) {
    final $$ReconSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reconSessions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReconSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.reconSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LedgerAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LedgerAccountsTable,
          LedgerAccountRow,
          $$LedgerAccountsTableFilterComposer,
          $$LedgerAccountsTableOrderingComposer,
          $$LedgerAccountsTableAnnotationComposer,
          $$LedgerAccountsTableCreateCompanionBuilder,
          $$LedgerAccountsTableUpdateCompanionBuilder,
          (LedgerAccountRow, $$LedgerAccountsTableReferences),
          LedgerAccountRow,
          PrefetchHooks Function({
            bool budgetsRefs,
            bool transactionLinesRefs,
            bool reconSessionsRefs,
          })
        > {
  $$LedgerAccountsTableTableManager(
    _$AppDatabase db,
    $LedgerAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<LedgerAccountKind> kind = const Value.absent(),
                Value<AccountClass> accountClass = const Value.absent(),
                Value<StorageType?> storageType = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameBn = const Value.absent(),
                Value<String?> institution = const Value.absent(),
                Value<String?> numberHint = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LedgerAccountsCompanion(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                id: id,
                kind: kind,
                accountClass: accountClass,
                storageType: storageType,
                name: name,
                nameBn: nameBn,
                institution: institution,
                numberHint: numberHint,
                icon: icon,
                isSystem: isSystem,
                archived: archived,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<SyncStatus> syncStatus = const Value.absent(),
                required String id,
                required LedgerAccountKind kind,
                required AccountClass accountClass,
                Value<StorageType?> storageType = const Value.absent(),
                required String name,
                Value<String?> nameBn = const Value.absent(),
                Value<String?> institution = const Value.absent(),
                Value<String?> numberHint = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LedgerAccountsCompanion.insert(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                id: id,
                kind: kind,
                accountClass: accountClass,
                storageType: storageType,
                name: name,
                nameBn: nameBn,
                institution: institution,
                numberHint: numberHint,
                icon: icon,
                isSystem: isSystem,
                archived: archived,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LedgerAccountsTable, LedgerAccountRow>(table),
                  $$LedgerAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                budgetsRefs = false,
                transactionLinesRefs = false,
                reconSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (budgetsRefs) db.budgets,
                    if (transactionLinesRefs) db.transactionLines,
                    if (reconSessionsRefs) db.reconSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (budgetsRefs)
                        await $_getPrefetchedDataByColumns<
                          LedgerAccountRow,
                          $LedgerAccountsTable,
                          BudgetRow,
                          $BudgetsTable
                        >(
                          currentTable: table,
                          referencedTable: $$LedgerAccountsTableReferences
                              ._budgetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgerAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (transactionLinesRefs)
                        await $_getPrefetchedDataByColumns<
                          LedgerAccountRow,
                          $LedgerAccountsTable,
                          LineRow,
                          $TransactionLinesTable
                        >(
                          currentTable: table,
                          referencedTable: $$LedgerAccountsTableReferences
                              ._transactionLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgerAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionLinesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                      if (reconSessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          LedgerAccountRow,
                          $LedgerAccountsTable,
                          ReconSessionRow,
                          $ReconSessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$LedgerAccountsTableReferences
                              ._reconSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgerAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).reconSessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LedgerAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LedgerAccountsTable,
      LedgerAccountRow,
      $$LedgerAccountsTableFilterComposer,
      $$LedgerAccountsTableOrderingComposer,
      $$LedgerAccountsTableAnnotationComposer,
      $$LedgerAccountsTableCreateCompanionBuilder,
      $$LedgerAccountsTableUpdateCompanionBuilder,
      (LedgerAccountRow, $$LedgerAccountsTableReferences),
      LedgerAccountRow,
      PrefetchHooks Function({
        bool budgetsRefs,
        bool transactionLinesRefs,
        bool reconSessionsRefs,
      })
    >;
typedef $$ObligationsTableCreateCompanionBuilder =
    ObligationsCompanion Function({
      Value<int> version,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<SyncStatus> syncStatus,
      required String id,
      required ObligationKind kind,
      required String personId,
      required String fundId,
      Value<String?> title,
      required int openedOn,
      Value<int?> dueOn,
      Value<ObligationStatus> status,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$ObligationsTableUpdateCompanionBuilder =
    ObligationsCompanion Function({
      Value<int> version,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<SyncStatus> syncStatus,
      Value<String> id,
      Value<ObligationKind> kind,
      Value<String> personId,
      Value<String> fundId,
      Value<String?> title,
      Value<int> openedOn,
      Value<int?> dueOn,
      Value<ObligationStatus> status,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$ObligationsTableReferences
    extends BaseReferences<_$AppDatabase, $ObligationsTable, ObligationRow> {
  $$ObligationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonsTable _personIdTable(_$AppDatabase db) =>
      db.persons.createAlias('obligations__person_id__persons__id');

  $$PersonsTableProcessedTableManager get personId {
    final $_column = $_itemColumn<String>('person_id')!;

    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FundsTable _fundIdTable(_$AppDatabase db) =>
      db.funds.createAlias('obligations__fund_id__funds__id');

  $$FundsTableProcessedTableManager get fundId {
    final $_column = $_itemColumn<String>('fund_id')!;

    final manager = $$FundsTableTableManager(
      $_db,
      $_db.funds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fundIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ObligationsTableFilterComposer
    extends Composer<_$AppDatabase, $ObligationsTable> {
  $$ObligationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ObligationKind, ObligationKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openedOn => $composableBuilder(
    column: $table.openedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueOn => $composableBuilder(
    column: $table.dueOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ObligationStatus, ObligationStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonsTableFilterComposer get personId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundsTableFilterComposer get fundId {
    final $$FundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundId,
      referencedTable: $db.funds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundsTableFilterComposer(
            $db: $db,
            $table: $db.funds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObligationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ObligationsTable> {
  $$ObligationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openedOn => $composableBuilder(
    column: $table.openedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueOn => $composableBuilder(
    column: $table.dueOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonsTableOrderingComposer get personId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundsTableOrderingComposer get fundId {
    final $$FundsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundId,
      referencedTable: $db.funds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundsTableOrderingComposer(
            $db: $db,
            $table: $db.funds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObligationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ObligationsTable> {
  $$ObligationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ObligationKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get openedOn =>
      $composableBuilder(column: $table.openedOn, builder: (column) => column);

  GeneratedColumn<int> get dueOn =>
      $composableBuilder(column: $table.dueOn, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ObligationStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PersonsTableAnnotationComposer get personId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundsTableAnnotationComposer get fundId {
    final $$FundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundId,
      referencedTable: $db.funds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundsTableAnnotationComposer(
            $db: $db,
            $table: $db.funds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObligationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ObligationsTable,
          ObligationRow,
          $$ObligationsTableFilterComposer,
          $$ObligationsTableOrderingComposer,
          $$ObligationsTableAnnotationComposer,
          $$ObligationsTableCreateCompanionBuilder,
          $$ObligationsTableUpdateCompanionBuilder,
          (ObligationRow, $$ObligationsTableReferences),
          ObligationRow,
          PrefetchHooks Function({bool personId, bool fundId})
        > {
  $$ObligationsTableTableManager(_$AppDatabase db, $ObligationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ObligationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ObligationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ObligationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<ObligationKind> kind = const Value.absent(),
                Value<String> personId = const Value.absent(),
                Value<String> fundId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<int> openedOn = const Value.absent(),
                Value<int?> dueOn = const Value.absent(),
                Value<ObligationStatus> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ObligationsCompanion(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                id: id,
                kind: kind,
                personId: personId,
                fundId: fundId,
                title: title,
                openedOn: openedOn,
                dueOn: dueOn,
                status: status,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<SyncStatus> syncStatus = const Value.absent(),
                required String id,
                required ObligationKind kind,
                required String personId,
                required String fundId,
                Value<String?> title = const Value.absent(),
                required int openedOn,
                Value<int?> dueOn = const Value.absent(),
                Value<ObligationStatus> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ObligationsCompanion.insert(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                id: id,
                kind: kind,
                personId: personId,
                fundId: fundId,
                title: title,
                openedOn: openedOn,
                dueOn: dueOn,
                status: status,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ObligationsTable, ObligationRow>(table),
                  $$ObligationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({personId = false, fundId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (personId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.personId,
                        referencedTable: $$ObligationsTableReferences
                            ._personIdTable(db),
                        referencedColumn: $$ObligationsTableReferences
                            ._personIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (fundId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.fundId,
                        referencedTable: $$ObligationsTableReferences
                            ._fundIdTable(db),
                        referencedColumn: $$ObligationsTableReferences
                            ._fundIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ObligationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ObligationsTable,
      ObligationRow,
      $$ObligationsTableFilterComposer,
      $$ObligationsTableOrderingComposer,
      $$ObligationsTableAnnotationComposer,
      $$ObligationsTableCreateCompanionBuilder,
      $$ObligationsTableUpdateCompanionBuilder,
      (ObligationRow, $$ObligationsTableReferences),
      ObligationRow,
      PrefetchHooks Function({bool personId, bool fundId})
    >;
typedef $$SamitiesTableCreateCompanionBuilder = SamitiesCompanion Function({
  Value<int> version,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<SyncStatus> syncStatus,
  required String id,
  required String name,
  required SamityMode mode,
  Value<String?> fundId,
  Value<int> contributionAmount,
  Value<String> frequency,
  required int startOn,
  Value<String?> notes,
  Value<bool> archived,
  Value<int> rowid,
});
typedef $$SamitiesTableUpdateCompanionBuilder = SamitiesCompanion Function({
  Value<int> version,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String> id,
  Value<String> name,
  Value<SamityMode> mode,
  Value<String?> fundId,
  Value<int> contributionAmount,
  Value<String> frequency,
  Value<int> startOn,
  Value<String?> notes,
  Value<bool> archived,
  Value<int> rowid,
});

final class $$SamitiesTableReferences
    extends BaseReferences<_$AppDatabase, $SamitiesTable, SamityRow> {
  $$SamitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FundsTable _fundIdTable(_$AppDatabase db) =>
      db.funds.createAlias('samities__fund_id__funds__id');

  $$FundsTableProcessedTableManager? get fundId {
    final $_column = $_itemColumn<String>('fund_id');
    if ($_column == null) return null;
    final manager = $$FundsTableTableManager(
      $_db,
      $_db.funds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fundIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SamityMembersTable, List<SamityMemberRow>>
  _samityMembersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.samityMembers,
    aliasName: 'samities__id__samity_members__samity_id',
  );

  $$SamityMembersTableProcessedTableManager get samityMembersRefs {
    final manager = $$SamityMembersTableTableManager(
      $_db,
      $_db.samityMembers,
    ).filter((f) => f.samityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_samityMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SamitiesTableFilterComposer
    extends Composer<_$AppDatabase, $SamitiesTable> {
  $$SamitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SamityMode, SamityMode, String> get mode =>
      $composableBuilder(
        column: $table.mode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get contributionAmount => $composableBuilder(
    column: $table.contributionAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startOn => $composableBuilder(
    column: $table.startOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  $$FundsTableFilterComposer get fundId {
    final $$FundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundId,
      referencedTable: $db.funds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundsTableFilterComposer(
            $db: $db,
            $table: $db.funds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> samityMembersRefs(
    Expression<bool> Function($$SamityMembersTableFilterComposer f) f,
  ) {
    final $$SamityMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.samityMembers,
      getReferencedColumn: (t) => t.samityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamityMembersTableFilterComposer(
            $db: $db,
            $table: $db.samityMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SamitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $SamitiesTable> {
  $$SamitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contributionAmount => $composableBuilder(
    column: $table.contributionAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startOn => $composableBuilder(
    column: $table.startOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  $$FundsTableOrderingComposer get fundId {
    final $$FundsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundId,
      referencedTable: $db.funds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundsTableOrderingComposer(
            $db: $db,
            $table: $db.funds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SamitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SamitiesTable> {
  $$SamitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SamityMode, String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get contributionAmount => $composableBuilder(
    column: $table.contributionAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get startOn =>
      $composableBuilder(column: $table.startOn, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  $$FundsTableAnnotationComposer get fundId {
    final $$FundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundId,
      referencedTable: $db.funds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundsTableAnnotationComposer(
            $db: $db,
            $table: $db.funds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> samityMembersRefs<T extends Object>(
    Expression<T> Function($$SamityMembersTableAnnotationComposer a) f,
  ) {
    final $$SamityMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.samityMembers,
      getReferencedColumn: (t) => t.samityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamityMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.samityMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SamitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SamitiesTable,
          SamityRow,
          $$SamitiesTableFilterComposer,
          $$SamitiesTableOrderingComposer,
          $$SamitiesTableAnnotationComposer,
          $$SamitiesTableCreateCompanionBuilder,
          $$SamitiesTableUpdateCompanionBuilder,
          (SamityRow, $$SamitiesTableReferences),
          SamityRow,
          PrefetchHooks Function({bool fundId, bool samityMembersRefs})
        > {
  $$SamitiesTableTableManager(_$AppDatabase db, $SamitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SamitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SamitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SamitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<SamityMode> mode = const Value.absent(),
                Value<String?> fundId = const Value.absent(),
                Value<int> contributionAmount = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<int> startOn = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SamitiesCompanion(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                id: id,
                name: name,
                mode: mode,
                fundId: fundId,
                contributionAmount: contributionAmount,
                frequency: frequency,
                startOn: startOn,
                notes: notes,
                archived: archived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<SyncStatus> syncStatus = const Value.absent(),
                required String id,
                required String name,
                required SamityMode mode,
                Value<String?> fundId = const Value.absent(),
                Value<int> contributionAmount = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                required int startOn,
                Value<String?> notes = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SamitiesCompanion.insert(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                id: id,
                name: name,
                mode: mode,
                fundId: fundId,
                contributionAmount: contributionAmount,
                frequency: frequency,
                startOn: startOn,
                notes: notes,
                archived: archived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SamitiesTable, SamityRow>(table),
                  $$SamitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({fundId = false, samityMembersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (samityMembersRefs) db.samityMembers,
              ],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (fundId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.fundId,
                        referencedTable: $$SamitiesTableReferences._fundIdTable(
                          db,
                        ),
                        referencedColumn: $$SamitiesTableReferences
                            ._fundIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (samityMembersRefs)
                    await $_getPrefetchedDataByColumns<
                      SamityRow,
                      $SamitiesTable,
                      SamityMemberRow,
                      $SamityMembersTable
                    >(
                      currentTable: table,
                      referencedTable: $$SamitiesTableReferences
                          ._samityMembersRefsTable(db),
                      managerFromTypedResult: (p0) => $$SamitiesTableReferences(
                        db,
                        table,
                        p0,
                      ).samityMembersRefs,
                      currentColumn: 'id',
                      referencedColumn: 'samity_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SamitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SamitiesTable,
      SamityRow,
      $$SamitiesTableFilterComposer,
      $$SamitiesTableOrderingComposer,
      $$SamitiesTableAnnotationComposer,
      $$SamitiesTableCreateCompanionBuilder,
      $$SamitiesTableUpdateCompanionBuilder,
      (SamityRow, $$SamitiesTableReferences),
      SamityRow,
      PrefetchHooks Function({bool fundId, bool samityMembersRefs})
    >;
typedef $$SamityMembersTableCreateCompanionBuilder =
    SamityMembersCompanion Function({
      Value<int> version,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<SyncStatus> syncStatus,
      required String samityId,
      required String personId,
      Value<int> shares,
      required int joinedOn,
      Value<int> rowid,
    });
typedef $$SamityMembersTableUpdateCompanionBuilder =
    SamityMembersCompanion Function({
      Value<int> version,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<SyncStatus> syncStatus,
      Value<String> samityId,
      Value<String> personId,
      Value<int> shares,
      Value<int> joinedOn,
      Value<int> rowid,
    });

final class $$SamityMembersTableReferences
    extends
        BaseReferences<_$AppDatabase, $SamityMembersTable, SamityMemberRow> {
  $$SamityMembersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SamitiesTable _samityIdTable(_$AppDatabase db) =>
      db.samities.createAlias('samity_members__samity_id__samities__id');

  $$SamitiesTableProcessedTableManager get samityId {
    final $_column = $_itemColumn<String>('samity_id')!;

    final manager = $$SamitiesTableTableManager(
      $_db,
      $_db.samities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_samityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PersonsTable _personIdTable(_$AppDatabase db) =>
      db.persons.createAlias('samity_members__person_id__persons__id');

  $$PersonsTableProcessedTableManager get personId {
    final $_column = $_itemColumn<String>('person_id')!;

    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SamityMembersTableFilterComposer
    extends Composer<_$AppDatabase, $SamityMembersTable> {
  $$SamityMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get joinedOn => $composableBuilder(
    column: $table.joinedOn,
    builder: (column) => ColumnFilters(column),
  );

  $$SamitiesTableFilterComposer get samityId {
    final $$SamitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.samityId,
      referencedTable: $db.samities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamitiesTableFilterComposer(
            $db: $db,
            $table: $db.samities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableFilterComposer get personId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SamityMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $SamityMembersTable> {
  $$SamityMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get joinedOn => $composableBuilder(
    column: $table.joinedOn,
    builder: (column) => ColumnOrderings(column),
  );

  $$SamitiesTableOrderingComposer get samityId {
    final $$SamitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.samityId,
      referencedTable: $db.samities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamitiesTableOrderingComposer(
            $db: $db,
            $table: $db.samities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableOrderingComposer get personId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SamityMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SamityMembersTable> {
  $$SamityMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<int> get shares =>
      $composableBuilder(column: $table.shares, builder: (column) => column);

  GeneratedColumn<int> get joinedOn =>
      $composableBuilder(column: $table.joinedOn, builder: (column) => column);

  $$SamitiesTableAnnotationComposer get samityId {
    final $$SamitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.samityId,
      referencedTable: $db.samities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.samities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableAnnotationComposer get personId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SamityMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SamityMembersTable,
          SamityMemberRow,
          $$SamityMembersTableFilterComposer,
          $$SamityMembersTableOrderingComposer,
          $$SamityMembersTableAnnotationComposer,
          $$SamityMembersTableCreateCompanionBuilder,
          $$SamityMembersTableUpdateCompanionBuilder,
          (SamityMemberRow, $$SamityMembersTableReferences),
          SamityMemberRow,
          PrefetchHooks Function({bool samityId, bool personId})
        > {
  $$SamityMembersTableTableManager(_$AppDatabase db, $SamityMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SamityMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SamityMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SamityMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<String> samityId = const Value.absent(),
                Value<String> personId = const Value.absent(),
                Value<int> shares = const Value.absent(),
                Value<int> joinedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SamityMembersCompanion(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                samityId: samityId,
                personId: personId,
                shares: shares,
                joinedOn: joinedOn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<SyncStatus> syncStatus = const Value.absent(),
                required String samityId,
                required String personId,
                Value<int> shares = const Value.absent(),
                required int joinedOn,
                Value<int> rowid = const Value.absent(),
              }) => SamityMembersCompanion.insert(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                samityId: samityId,
                personId: personId,
                shares: shares,
                joinedOn: joinedOn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SamityMembersTable, SamityMemberRow>(table),
                  $$SamityMembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({samityId = false, personId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (samityId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.samityId,
                        referencedTable: $$SamityMembersTableReferences
                            ._samityIdTable(db),
                        referencedColumn: $$SamityMembersTableReferences
                            ._samityIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (personId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.personId,
                        referencedTable: $$SamityMembersTableReferences
                            ._personIdTable(db),
                        referencedColumn: $$SamityMembersTableReferences
                            ._personIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SamityMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SamityMembersTable,
      SamityMemberRow,
      $$SamityMembersTableFilterComposer,
      $$SamityMembersTableOrderingComposer,
      $$SamityMembersTableAnnotationComposer,
      $$SamityMembersTableCreateCompanionBuilder,
      $$SamityMembersTableUpdateCompanionBuilder,
      (SamityMemberRow, $$SamityMembersTableReferences),
      SamityMemberRow,
      PrefetchHooks Function({bool samityId, bool personId})
    >;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  Value<int> version,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<SyncStatus> syncStatus,
  required String id,
  required int monthKey,
  required String categoryId,
  required int limitAmount,
  Value<int> rowid,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<int> version,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<String> id,
  Value<int> monthKey,
  Value<String> categoryId,
  Value<int> limitAmount,
  Value<int> rowid,
});

final class $$BudgetsTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow> {
  $$BudgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LedgerAccountsTable _categoryIdTable(_$AppDatabase db) => db
      .ledgerAccounts
      .createAlias('budgets__category_id__ledger_accounts__id');

  $$LedgerAccountsTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$LedgerAccountsTableTableManager(
      $_db,
      $_db.ledgerAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthKey => $composableBuilder(
    column: $table.monthKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get limitAmount => $composableBuilder(
    column: $table.limitAmount,
    builder: (column) => ColumnFilters(column),
  );

  $$LedgerAccountsTableFilterComposer get categoryId {
    final $$LedgerAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthKey => $composableBuilder(
    column: $table.monthKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get limitAmount => $composableBuilder(
    column: $table.limitAmount,
    builder: (column) => ColumnOrderings(column),
  );

  $$LedgerAccountsTableOrderingComposer get categoryId {
    final $$LedgerAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get monthKey =>
      $composableBuilder(column: $table.monthKey, builder: (column) => column);

  GeneratedColumn<int> get limitAmount => $composableBuilder(
    column: $table.limitAmount,
    builder: (column) => column,
  );

  $$LedgerAccountsTableAnnotationComposer get categoryId {
    final $$LedgerAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          BudgetRow,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (BudgetRow, $$BudgetsTableReferences),
          BudgetRow,
          PrefetchHooks Function({bool categoryId})
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<int> monthKey = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> limitAmount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                id: id,
                monthKey: monthKey,
                categoryId: categoryId,
                limitAmount: limitAmount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<SyncStatus> syncStatus = const Value.absent(),
                required String id,
                required int monthKey,
                required String categoryId,
                required int limitAmount,
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                id: id,
                monthKey: monthKey,
                categoryId: categoryId,
                limitAmount: limitAmount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTable, BudgetRow>(table),
                  $$BudgetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$BudgetsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$BudgetsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      BudgetRow,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (BudgetRow, $$BudgetsTableReferences),
      BudgetRow,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$LedgerTransactionsTableCreateCompanionBuilder =
    LedgerTransactionsCompanion Function({
      required String id,
      required TxType type,
      required TxStatus status,
      required int dateKey,
      Value<int?> amount,
      Value<String> currency,
      Value<int> fee,
      Value<bool> increase,
      Value<String?> description,
      Value<String?> notes,
      Value<String?> referenceNo,
      Value<String?> categoryId,
      Value<String?> personId,
      Value<String?> fundId,
      Value<String?> toFundId,
      Value<String?> fromAccountId,
      Value<String?> toAccountId,
      Value<String?> obligationId,
      Value<String?> samityId,
      Value<String?> reconSessionId,
      Value<String?> reversesTxId,
      Value<String?> reversedByTxId,
      Value<String?> replacesTxId,
      required String createdBy,
      required String modifiedBy,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> postedAt,
      required int sortKey,
      Value<int> version,
      Value<String?> contentHash,
      Value<SyncStatus> syncStatus,
      Value<String?> deviceId,
      Value<int> rowid,
    });
typedef $$LedgerTransactionsTableUpdateCompanionBuilder =
    LedgerTransactionsCompanion Function({
      Value<String> id,
      Value<TxType> type,
      Value<TxStatus> status,
      Value<int> dateKey,
      Value<int?> amount,
      Value<String> currency,
      Value<int> fee,
      Value<bool> increase,
      Value<String?> description,
      Value<String?> notes,
      Value<String?> referenceNo,
      Value<String?> categoryId,
      Value<String?> personId,
      Value<String?> fundId,
      Value<String?> toFundId,
      Value<String?> fromAccountId,
      Value<String?> toAccountId,
      Value<String?> obligationId,
      Value<String?> samityId,
      Value<String?> reconSessionId,
      Value<String?> reversesTxId,
      Value<String?> reversedByTxId,
      Value<String?> replacesTxId,
      Value<String> createdBy,
      Value<String> modifiedBy,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> postedAt,
      Value<int> sortKey,
      Value<int> version,
      Value<String?> contentHash,
      Value<SyncStatus> syncStatus,
      Value<String?> deviceId,
      Value<int> rowid,
    });

final class $$LedgerTransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $LedgerTransactionsTable, TxRow> {
  $$LedgerTransactionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TransactionLinesTable, List<LineRow>>
  _transactionLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionLines,
    aliasName: 'ledger_transactions__id__transaction_lines__tx_id',
  );

  $$TransactionLinesTableProcessedTableManager get transactionLinesRefs {
    final manager = $$TransactionLinesTableTableManager(
      $_db,
      $_db.transactionLines,
    ).filter((f) => f.txId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AttachmentsTable, List<AttachmentRow>>
  _attachmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attachments,
    aliasName: 'ledger_transactions__id__attachments__tx_id',
  );

  $$AttachmentsTableProcessedTableManager get attachmentsRefs {
    final manager = $$AttachmentsTableTableManager(
      $_db,
      $_db.attachments,
    ).filter((f) => f.txId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attachmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LedgerTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $LedgerTransactionsTable> {
  $$LedgerTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TxType, TxType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<TxStatus, TxStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fee => $composableBuilder(
    column: $table.fee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get increase => $composableBuilder(
    column: $table.increase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceNo => $composableBuilder(
    column: $table.referenceNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personId => $composableBuilder(
    column: $table.personId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fundId => $composableBuilder(
    column: $table.fundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toFundId => $composableBuilder(
    column: $table.toFundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromAccountId => $composableBuilder(
    column: $table.fromAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get obligationId => $composableBuilder(
    column: $table.obligationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get samityId => $composableBuilder(
    column: $table.samityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reconSessionId => $composableBuilder(
    column: $table.reconSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reversesTxId => $composableBuilder(
    column: $table.reversesTxId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reversedByTxId => $composableBuilder(
    column: $table.reversedByTxId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replacesTxId => $composableBuilder(
    column: $table.replacesTxId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modifiedBy => $composableBuilder(
    column: $table.modifiedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get postedAt => $composableBuilder(
    column: $table.postedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortKey => $composableBuilder(
    column: $table.sortKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionLinesRefs(
    Expression<bool> Function($$TransactionLinesTableFilterComposer f) f,
  ) {
    final $$TransactionLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.txId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableFilterComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> attachmentsRefs(
    Expression<bool> Function($$AttachmentsTableFilterComposer f) f,
  ) {
    final $$AttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.txId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LedgerTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgerTransactionsTable> {
  $$LedgerTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fee => $composableBuilder(
    column: $table.fee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get increase => $composableBuilder(
    column: $table.increase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceNo => $composableBuilder(
    column: $table.referenceNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personId => $composableBuilder(
    column: $table.personId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fundId => $composableBuilder(
    column: $table.fundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toFundId => $composableBuilder(
    column: $table.toFundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromAccountId => $composableBuilder(
    column: $table.fromAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get obligationId => $composableBuilder(
    column: $table.obligationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get samityId => $composableBuilder(
    column: $table.samityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reconSessionId => $composableBuilder(
    column: $table.reconSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reversesTxId => $composableBuilder(
    column: $table.reversesTxId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reversedByTxId => $composableBuilder(
    column: $table.reversedByTxId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replacesTxId => $composableBuilder(
    column: $table.replacesTxId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modifiedBy => $composableBuilder(
    column: $table.modifiedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get postedAt => $composableBuilder(
    column: $table.postedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortKey => $composableBuilder(
    column: $table.sortKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LedgerTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgerTransactionsTable> {
  $$LedgerTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get fee =>
      $composableBuilder(column: $table.fee, builder: (column) => column);

  GeneratedColumn<bool> get increase =>
      $composableBuilder(column: $table.increase, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get referenceNo => $composableBuilder(
    column: $table.referenceNo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get fundId =>
      $composableBuilder(column: $table.fundId, builder: (column) => column);

  GeneratedColumn<String> get toFundId =>
      $composableBuilder(column: $table.toFundId, builder: (column) => column);

  GeneratedColumn<String> get fromAccountId => $composableBuilder(
    column: $table.fromAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get obligationId => $composableBuilder(
    column: $table.obligationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get samityId =>
      $composableBuilder(column: $table.samityId, builder: (column) => column);

  GeneratedColumn<String> get reconSessionId => $composableBuilder(
    column: $table.reconSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reversesTxId => $composableBuilder(
    column: $table.reversesTxId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reversedByTxId => $composableBuilder(
    column: $table.reversedByTxId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replacesTxId => $composableBuilder(
    column: $table.replacesTxId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get modifiedBy => $composableBuilder(
    column: $table.modifiedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get postedAt =>
      $composableBuilder(column: $table.postedAt, builder: (column) => column);

  GeneratedColumn<int> get sortKey =>
      $composableBuilder(column: $table.sortKey, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  Expression<T> transactionLinesRefs<T extends Object>(
    Expression<T> Function($$TransactionLinesTableAnnotationComposer a) f,
  ) {
    final $$TransactionLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.txId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> attachmentsRefs<T extends Object>(
    Expression<T> Function($$AttachmentsTableAnnotationComposer a) f,
  ) {
    final $$AttachmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.txId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LedgerTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LedgerTransactionsTable,
          TxRow,
          $$LedgerTransactionsTableFilterComposer,
          $$LedgerTransactionsTableOrderingComposer,
          $$LedgerTransactionsTableAnnotationComposer,
          $$LedgerTransactionsTableCreateCompanionBuilder,
          $$LedgerTransactionsTableUpdateCompanionBuilder,
          (TxRow, $$LedgerTransactionsTableReferences),
          TxRow,
          PrefetchHooks Function({
            bool transactionLinesRefs,
            bool attachmentsRefs,
          })
        > {
  $$LedgerTransactionsTableTableManager(
    _$AppDatabase db,
    $LedgerTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<TxType> type = const Value.absent(),
                Value<TxStatus> status = const Value.absent(),
                Value<int> dateKey = const Value.absent(),
                Value<int?> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> fee = const Value.absent(),
                Value<bool> increase = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> referenceNo = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> personId = const Value.absent(),
                Value<String?> fundId = const Value.absent(),
                Value<String?> toFundId = const Value.absent(),
                Value<String?> fromAccountId = const Value.absent(),
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> obligationId = const Value.absent(),
                Value<String?> samityId = const Value.absent(),
                Value<String?> reconSessionId = const Value.absent(),
                Value<String?> reversesTxId = const Value.absent(),
                Value<String?> reversedByTxId = const Value.absent(),
                Value<String?> replacesTxId = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> modifiedBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> postedAt = const Value.absent(),
                Value<int> sortKey = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String?> contentHash = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LedgerTransactionsCompanion(
                id: id,
                type: type,
                status: status,
                dateKey: dateKey,
                amount: amount,
                currency: currency,
                fee: fee,
                increase: increase,
                description: description,
                notes: notes,
                referenceNo: referenceNo,
                categoryId: categoryId,
                personId: personId,
                fundId: fundId,
                toFundId: toFundId,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                obligationId: obligationId,
                samityId: samityId,
                reconSessionId: reconSessionId,
                reversesTxId: reversesTxId,
                reversedByTxId: reversedByTxId,
                replacesTxId: replacesTxId,
                createdBy: createdBy,
                modifiedBy: modifiedBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
                postedAt: postedAt,
                sortKey: sortKey,
                version: version,
                contentHash: contentHash,
                syncStatus: syncStatus,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required TxType type,
                required TxStatus status,
                required int dateKey,
                Value<int?> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> fee = const Value.absent(),
                Value<bool> increase = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> referenceNo = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> personId = const Value.absent(),
                Value<String?> fundId = const Value.absent(),
                Value<String?> toFundId = const Value.absent(),
                Value<String?> fromAccountId = const Value.absent(),
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> obligationId = const Value.absent(),
                Value<String?> samityId = const Value.absent(),
                Value<String?> reconSessionId = const Value.absent(),
                Value<String?> reversesTxId = const Value.absent(),
                Value<String?> reversedByTxId = const Value.absent(),
                Value<String?> replacesTxId = const Value.absent(),
                required String createdBy,
                required String modifiedBy,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> postedAt = const Value.absent(),
                required int sortKey,
                Value<int> version = const Value.absent(),
                Value<String?> contentHash = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LedgerTransactionsCompanion.insert(
                id: id,
                type: type,
                status: status,
                dateKey: dateKey,
                amount: amount,
                currency: currency,
                fee: fee,
                increase: increase,
                description: description,
                notes: notes,
                referenceNo: referenceNo,
                categoryId: categoryId,
                personId: personId,
                fundId: fundId,
                toFundId: toFundId,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                obligationId: obligationId,
                samityId: samityId,
                reconSessionId: reconSessionId,
                reversesTxId: reversesTxId,
                reversedByTxId: reversedByTxId,
                replacesTxId: replacesTxId,
                createdBy: createdBy,
                modifiedBy: modifiedBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
                postedAt: postedAt,
                sortKey: sortKey,
                version: version,
                contentHash: contentHash,
                syncStatus: syncStatus,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LedgerTransactionsTable, TxRow>(table),
                  $$LedgerTransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({transactionLinesRefs = false, attachmentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionLinesRefs) db.transactionLines,
                    if (attachmentsRefs) db.attachments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionLinesRefs)
                        await $_getPrefetchedDataByColumns<
                          TxRow,
                          $LedgerTransactionsTable,
                          LineRow,
                          $TransactionLinesTable
                        >(
                          currentTable: table,
                          referencedTable: $$LedgerTransactionsTableReferences
                              ._transactionLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgerTransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionLinesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'tx_id',
                          typedResults: items,
                        ),
                      if (attachmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          TxRow,
                          $LedgerTransactionsTable,
                          AttachmentRow,
                          $AttachmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$LedgerTransactionsTableReferences
                              ._attachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgerTransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).attachmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'tx_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LedgerTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LedgerTransactionsTable,
      TxRow,
      $$LedgerTransactionsTableFilterComposer,
      $$LedgerTransactionsTableOrderingComposer,
      $$LedgerTransactionsTableAnnotationComposer,
      $$LedgerTransactionsTableCreateCompanionBuilder,
      $$LedgerTransactionsTableUpdateCompanionBuilder,
      (TxRow, $$LedgerTransactionsTableReferences),
      TxRow,
      PrefetchHooks Function({bool transactionLinesRefs, bool attachmentsRefs})
    >;
typedef $$TransactionLinesTableCreateCompanionBuilder =
    TransactionLinesCompanion Function({
      required String txId,
      required int lineNo,
      required String accountId,
      required String fundId,
      Value<String?> personId,
      Value<String?> counterFundId,
      required int amount,
      Value<int> rowid,
    });
typedef $$TransactionLinesTableUpdateCompanionBuilder =
    TransactionLinesCompanion Function({
      Value<String> txId,
      Value<int> lineNo,
      Value<String> accountId,
      Value<String> fundId,
      Value<String?> personId,
      Value<String?> counterFundId,
      Value<int> amount,
      Value<int> rowid,
    });

final class $$TransactionLinesTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionLinesTable, LineRow> {
  $$TransactionLinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LedgerTransactionsTable _txIdTable(_$AppDatabase db) => db
      .ledgerTransactions
      .createAlias('transaction_lines__tx_id__ledger_transactions__id');

  $$LedgerTransactionsTableProcessedTableManager get txId {
    final $_column = $_itemColumn<String>('tx_id')!;

    final manager = $$LedgerTransactionsTableTableManager(
      $_db,
      $_db.ledgerTransactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_txIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LedgerAccountsTable _accountIdTable(_$AppDatabase db) => db
      .ledgerAccounts
      .createAlias('transaction_lines__account_id__ledger_accounts__id');

  $$LedgerAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$LedgerAccountsTableTableManager(
      $_db,
      $_db.ledgerAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FundsTable _fundIdTable(_$AppDatabase db) =>
      db.funds.createAlias('transaction_lines__fund_id__funds__id');

  $$FundsTableProcessedTableManager get fundId {
    final $_column = $_itemColumn<String>('fund_id')!;

    final manager = $$FundsTableTableManager(
      $_db,
      $_db.funds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fundIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionLinesTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionLinesTable> {
  $$TransactionLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get lineNo => $composableBuilder(
    column: $table.lineNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personId => $composableBuilder(
    column: $table.personId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get counterFundId => $composableBuilder(
    column: $table.counterFundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  $$LedgerTransactionsTableFilterComposer get txId {
    final $$LedgerTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.txId,
      referencedTable: $db.ledgerTransactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableFilterComposer get accountId {
    final $$LedgerAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundsTableFilterComposer get fundId {
    final $$FundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundId,
      referencedTable: $db.funds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundsTableFilterComposer(
            $db: $db,
            $table: $db.funds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionLinesTable> {
  $$TransactionLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get lineNo => $composableBuilder(
    column: $table.lineNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personId => $composableBuilder(
    column: $table.personId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counterFundId => $composableBuilder(
    column: $table.counterFundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  $$LedgerTransactionsTableOrderingComposer get txId {
    final $$LedgerTransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.txId,
      referencedTable: $db.ledgerTransactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerTransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableOrderingComposer get accountId {
    final $$LedgerAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundsTableOrderingComposer get fundId {
    final $$FundsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundId,
      referencedTable: $db.funds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundsTableOrderingComposer(
            $db: $db,
            $table: $db.funds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionLinesTable> {
  $$TransactionLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get lineNo =>
      $composableBuilder(column: $table.lineNo, builder: (column) => column);

  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get counterFundId => $composableBuilder(
    column: $table.counterFundId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$LedgerTransactionsTableAnnotationComposer get txId {
    final $$LedgerTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.txId,
          referencedTable: $db.ledgerTransactions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LedgerTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.ledgerTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$LedgerAccountsTableAnnotationComposer get accountId {
    final $$LedgerAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundsTableAnnotationComposer get fundId {
    final $$FundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundId,
      referencedTable: $db.funds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundsTableAnnotationComposer(
            $db: $db,
            $table: $db.funds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionLinesTable,
          LineRow,
          $$TransactionLinesTableFilterComposer,
          $$TransactionLinesTableOrderingComposer,
          $$TransactionLinesTableAnnotationComposer,
          $$TransactionLinesTableCreateCompanionBuilder,
          $$TransactionLinesTableUpdateCompanionBuilder,
          (LineRow, $$TransactionLinesTableReferences),
          LineRow,
          PrefetchHooks Function({bool txId, bool accountId, bool fundId})
        > {
  $$TransactionLinesTableTableManager(
    _$AppDatabase db,
    $TransactionLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> txId = const Value.absent(),
                Value<int> lineNo = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> fundId = const Value.absent(),
                Value<String?> personId = const Value.absent(),
                Value<String?> counterFundId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionLinesCompanion(
                txId: txId,
                lineNo: lineNo,
                accountId: accountId,
                fundId: fundId,
                personId: personId,
                counterFundId: counterFundId,
                amount: amount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String txId,
                required int lineNo,
                required String accountId,
                required String fundId,
                Value<String?> personId = const Value.absent(),
                Value<String?> counterFundId = const Value.absent(),
                required int amount,
                Value<int> rowid = const Value.absent(),
              }) => TransactionLinesCompanion.insert(
                txId: txId,
                lineNo: lineNo,
                accountId: accountId,
                fundId: fundId,
                personId: personId,
                counterFundId: counterFundId,
                amount: amount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionLinesTable, LineRow>(table),
                  $$TransactionLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({txId = false, accountId = false, fundId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (txId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.txId,
                            referencedTable: $$TransactionLinesTableReferences
                                ._txIdTable(db),
                            referencedColumn: $$TransactionLinesTableReferences
                                ._txIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$TransactionLinesTableReferences
                                ._accountIdTable(db),
                            referencedColumn: $$TransactionLinesTableReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (fundId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.fundId,
                            referencedTable: $$TransactionLinesTableReferences
                                ._fundIdTable(db),
                            referencedColumn: $$TransactionLinesTableReferences
                                ._fundIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionLinesTable,
      LineRow,
      $$TransactionLinesTableFilterComposer,
      $$TransactionLinesTableOrderingComposer,
      $$TransactionLinesTableAnnotationComposer,
      $$TransactionLinesTableCreateCompanionBuilder,
      $$TransactionLinesTableUpdateCompanionBuilder,
      (LineRow, $$TransactionLinesTableReferences),
      LineRow,
      PrefetchHooks Function({bool txId, bool accountId, bool fundId})
    >;
typedef $$AttachmentsTableCreateCompanionBuilder =
    AttachmentsCompanion Function({
      required String id,
      required String txId,
      required String fileName,
      required String localPath,
      Value<String?> mimeType,
      required int sizeBytes,
      required String sha256,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AttachmentsTableUpdateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<String> id,
      Value<String> txId,
      Value<String> fileName,
      Value<String> localPath,
      Value<String?> mimeType,
      Value<int> sizeBytes,
      Value<String> sha256,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$AttachmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AttachmentsTable, AttachmentRow> {
  $$AttachmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LedgerTransactionsTable _txIdTable(_$AppDatabase db) => db
      .ledgerTransactions
      .createAlias('attachments__tx_id__ledger_transactions__id');

  $$LedgerTransactionsTableProcessedTableManager get txId {
    final $_column = $_itemColumn<String>('tx_id')!;

    final manager = $$LedgerTransactionsTableTableManager(
      $_db,
      $_db.ledgerTransactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_txIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LedgerTransactionsTableFilterComposer get txId {
    final $$LedgerTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.txId,
      referencedTable: $db.ledgerTransactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LedgerTransactionsTableOrderingComposer get txId {
    final $$LedgerTransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.txId,
      referencedTable: $db.ledgerTransactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerTransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$LedgerTransactionsTableAnnotationComposer get txId {
    final $$LedgerTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.txId,
          referencedTable: $db.ledgerTransactions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LedgerTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.ledgerTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$AttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttachmentsTable,
          AttachmentRow,
          $$AttachmentsTableFilterComposer,
          $$AttachmentsTableOrderingComposer,
          $$AttachmentsTableAnnotationComposer,
          $$AttachmentsTableCreateCompanionBuilder,
          $$AttachmentsTableUpdateCompanionBuilder,
          (AttachmentRow, $$AttachmentsTableReferences),
          AttachmentRow,
          PrefetchHooks Function({bool txId})
        > {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> txId = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion(
                id: id,
                txId: txId,
                fileName: fileName,
                localPath: localPath,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                sha256: sha256,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String txId,
                required String fileName,
                required String localPath,
                Value<String?> mimeType = const Value.absent(),
                required int sizeBytes,
                required String sha256,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion.insert(
                id: id,
                txId: txId,
                fileName: fileName,
                localPath: localPath,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                sha256: sha256,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AttachmentsTable, AttachmentRow>(table),
                  $$AttachmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({txId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (txId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.txId,
                        referencedTable: $$AttachmentsTableReferences
                            ._txIdTable(db),
                        referencedColumn: $$AttachmentsTableReferences
                            ._txIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttachmentsTable,
      AttachmentRow,
      $$AttachmentsTableFilterComposer,
      $$AttachmentsTableOrderingComposer,
      $$AttachmentsTableAnnotationComposer,
      $$AttachmentsTableCreateCompanionBuilder,
      $$AttachmentsTableUpdateCompanionBuilder,
      (AttachmentRow, $$AttachmentsTableReferences),
      AttachmentRow,
      PrefetchHooks Function({bool txId})
    >;
typedef $$ReconSessionsTableCreateCompanionBuilder =
    ReconSessionsCompanion Function({
      required String id,
      required String accountId,
      Value<String?> fundId,
      required int asOfDateKey,
      required int expectedBalance,
      required int actualBalance,
      required String status,
      Value<String?> notes,
      Value<String?> adjustmentTxId,
      required String createdBy,
      required DateTime createdAt,
      Value<String?> approvedBy,
      Value<DateTime?> approvedAt,
      Value<SyncStatus> syncStatus,
      Value<int> rowid,
    });
typedef $$ReconSessionsTableUpdateCompanionBuilder =
    ReconSessionsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String?> fundId,
      Value<int> asOfDateKey,
      Value<int> expectedBalance,
      Value<int> actualBalance,
      Value<String> status,
      Value<String?> notes,
      Value<String?> adjustmentTxId,
      Value<String> createdBy,
      Value<DateTime> createdAt,
      Value<String?> approvedBy,
      Value<DateTime?> approvedAt,
      Value<SyncStatus> syncStatus,
      Value<int> rowid,
    });

final class $$ReconSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ReconSessionsTable, ReconSessionRow> {
  $$ReconSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LedgerAccountsTable _accountIdTable(_$AppDatabase db) => db
      .ledgerAccounts
      .createAlias('recon_sessions__account_id__ledger_accounts__id');

  $$LedgerAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$LedgerAccountsTableTableManager(
      $_db,
      $_db.ledgerAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReconSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ReconSessionsTable> {
  $$ReconSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fundId => $composableBuilder(
    column: $table.fundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get asOfDateKey => $composableBuilder(
    column: $table.asOfDateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedBalance => $composableBuilder(
    column: $table.expectedBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualBalance => $composableBuilder(
    column: $table.actualBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adjustmentTxId => $composableBuilder(
    column: $table.adjustmentTxId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$LedgerAccountsTableFilterComposer get accountId {
    final $$LedgerAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReconSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReconSessionsTable> {
  $$ReconSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fundId => $composableBuilder(
    column: $table.fundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get asOfDateKey => $composableBuilder(
    column: $table.asOfDateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedBalance => $composableBuilder(
    column: $table.expectedBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualBalance => $composableBuilder(
    column: $table.actualBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adjustmentTxId => $composableBuilder(
    column: $table.adjustmentTxId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$LedgerAccountsTableOrderingComposer get accountId {
    final $$LedgerAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReconSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReconSessionsTable> {
  $$ReconSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fundId =>
      $composableBuilder(column: $table.fundId, builder: (column) => column);

  GeneratedColumn<int> get asOfDateKey => $composableBuilder(
    column: $table.asOfDateKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expectedBalance => $composableBuilder(
    column: $table.expectedBalance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualBalance => $composableBuilder(
    column: $table.actualBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get adjustmentTxId => $composableBuilder(
    column: $table.adjustmentTxId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  $$LedgerAccountsTableAnnotationComposer get accountId {
    final $$LedgerAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReconSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReconSessionsTable,
          ReconSessionRow,
          $$ReconSessionsTableFilterComposer,
          $$ReconSessionsTableOrderingComposer,
          $$ReconSessionsTableAnnotationComposer,
          $$ReconSessionsTableCreateCompanionBuilder,
          $$ReconSessionsTableUpdateCompanionBuilder,
          (ReconSessionRow, $$ReconSessionsTableReferences),
          ReconSessionRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$ReconSessionsTableTableManager(_$AppDatabase db, $ReconSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReconSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReconSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReconSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String?> fundId = const Value.absent(),
                Value<int> asOfDateKey = const Value.absent(),
                Value<int> expectedBalance = const Value.absent(),
                Value<int> actualBalance = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> adjustmentTxId = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> approvedBy = const Value.absent(),
                Value<DateTime?> approvedAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReconSessionsCompanion(
                id: id,
                accountId: accountId,
                fundId: fundId,
                asOfDateKey: asOfDateKey,
                expectedBalance: expectedBalance,
                actualBalance: actualBalance,
                status: status,
                notes: notes,
                adjustmentTxId: adjustmentTxId,
                createdBy: createdBy,
                createdAt: createdAt,
                approvedBy: approvedBy,
                approvedAt: approvedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                Value<String?> fundId = const Value.absent(),
                required int asOfDateKey,
                required int expectedBalance,
                required int actualBalance,
                required String status,
                Value<String?> notes = const Value.absent(),
                Value<String?> adjustmentTxId = const Value.absent(),
                required String createdBy,
                required DateTime createdAt,
                Value<String?> approvedBy = const Value.absent(),
                Value<DateTime?> approvedAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReconSessionsCompanion.insert(
                id: id,
                accountId: accountId,
                fundId: fundId,
                asOfDateKey: asOfDateKey,
                expectedBalance: expectedBalance,
                actualBalance: actualBalance,
                status: status,
                notes: notes,
                adjustmentTxId: adjustmentTxId,
                createdBy: createdBy,
                createdAt: createdAt,
                approvedBy: approvedBy,
                approvedAt: approvedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReconSessionsTable, ReconSessionRow>(table),
                  $$ReconSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable: $$ReconSessionsTableReferences
                            ._accountIdTable(db),
                        referencedColumn: $$ReconSessionsTableReferences
                            ._accountIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReconSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReconSessionsTable,
      ReconSessionRow,
      $$ReconSessionsTableFilterComposer,
      $$ReconSessionsTableOrderingComposer,
      $$ReconSessionsTableAnnotationComposer,
      $$ReconSessionsTableCreateCompanionBuilder,
      $$ReconSessionsTableUpdateCompanionBuilder,
      (ReconSessionRow, $$ReconSessionsTableReferences),
      ReconSessionRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$AuditEventsTableCreateCompanionBuilder =
    AuditEventsCompanion Function({
      Value<int> seq,
      required String eventId,
      required DateTime at,
      required String actorId,
      required String entityType,
      required String entityId,
      required String action,
      Value<String?> details,
      required String prevHash,
      required String hash,
      Value<SyncStatus> syncStatus,
    });
typedef $$AuditEventsTableUpdateCompanionBuilder =
    AuditEventsCompanion Function({
      Value<int> seq,
      Value<String> eventId,
      Value<DateTime> at,
      Value<String> actorId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> action,
      Value<String?> details,
      Value<String> prevHash,
      Value<String> hash,
      Value<SyncStatus> syncStatus,
    });

class $$AuditEventsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prevHash => $composableBuilder(
    column: $table.prevHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$AuditEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prevHash => $composableBuilder(
    column: $table.prevHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get actorId =>
      $composableBuilder(column: $table.actorId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<String> get prevHash =>
      $composableBuilder(column: $table.prevHash, builder: (column) => column);

  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );
}

class $$AuditEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditEventsTable,
          AuditRow,
          $$AuditEventsTableFilterComposer,
          $$AuditEventsTableOrderingComposer,
          $$AuditEventsTableAnnotationComposer,
          $$AuditEventsTableCreateCompanionBuilder,
          $$AuditEventsTableUpdateCompanionBuilder,
          (
            AuditRow,
            BaseReferences<_$AppDatabase, $AuditEventsTable, AuditRow>,
          ),
          AuditRow,
          PrefetchHooks Function()
        > {
  $$AuditEventsTableTableManager(_$AppDatabase db, $AuditEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> actorId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<String> prevHash = const Value.absent(),
                Value<String> hash = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
              }) => AuditEventsCompanion(
                seq: seq,
                eventId: eventId,
                at: at,
                actorId: actorId,
                entityType: entityType,
                entityId: entityId,
                action: action,
                details: details,
                prevHash: prevHash,
                hash: hash,
                syncStatus: syncStatus,
              ),
          createCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                required String eventId,
                required DateTime at,
                required String actorId,
                required String entityType,
                required String entityId,
                required String action,
                Value<String?> details = const Value.absent(),
                required String prevHash,
                required String hash,
                Value<SyncStatus> syncStatus = const Value.absent(),
              }) => AuditEventsCompanion.insert(
                seq: seq,
                eventId: eventId,
                at: at,
                actorId: actorId,
                entityType: entityType,
                entityId: entityId,
                action: action,
                details: details,
                prevHash: prevHash,
                hash: hash,
                syncStatus: syncStatus,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AuditEventsTable, AuditRow>(table),
                  BaseReferences<_$AppDatabase, $AuditEventsTable, AuditRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditEventsTable,
      AuditRow,
      $$AuditEventsTableFilterComposer,
      $$AuditEventsTableOrderingComposer,
      $$AuditEventsTableAnnotationComposer,
      $$AuditEventsTableCreateCompanionBuilder,
      $$AuditEventsTableUpdateCompanionBuilder,
      (AuditRow, BaseReferences<_$AppDatabase, $AuditEventsTable, AuditRow>),
      AuditRow,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder = OutboxCompanion Function({
  Value<int> seq,
  required String entityType,
  required String entityId,
  required String operation,
  required DateTime createdAt,
  Value<int> attempts,
  required DateTime nextAttemptAt,
  Value<String?> lastError,
  Value<String> state,
});
typedef $$OutboxTableUpdateCompanionBuilder = OutboxCompanion Function({
  Value<int> seq,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> operation,
  Value<DateTime> createdAt,
  Value<int> attempts,
  Value<DateTime> nextAttemptAt,
  Value<String?> lastError,
  Value<String> state,
});

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxRow,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (OutboxRow, BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>),
          OutboxRow,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> state = const Value.absent(),
              }) => OutboxCompanion(
                seq: seq,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                createdAt: createdAt,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                state: state,
              ),
          createCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                required String entityType,
                required String entityId,
                required String operation,
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                required DateTime nextAttemptAt,
                Value<String?> lastError = const Value.absent(),
                Value<String> state = const Value.absent(),
              }) => OutboxCompanion.insert(
                seq: seq,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                createdAt: createdAt,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                state: state,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxTable, OutboxRow>(table),
                  BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxRow,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxRow, BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>),
      OutboxRow,
      PrefetchHooks Function()
    >;
typedef $$KeyValuesTableCreateCompanionBuilder = KeyValuesCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$KeyValuesTableUpdateCompanionBuilder = KeyValuesCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$KeyValuesTableFilterComposer
    extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KeyValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KeyValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$KeyValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KeyValuesTable,
          KvRow,
          $$KeyValuesTableFilterComposer,
          $$KeyValuesTableOrderingComposer,
          $$KeyValuesTableAnnotationComposer,
          $$KeyValuesTableCreateCompanionBuilder,
          $$KeyValuesTableUpdateCompanionBuilder,
          (KvRow, BaseReferences<_$AppDatabase, $KeyValuesTable, KvRow>),
          KvRow,
          PrefetchHooks Function()
        > {
  $$KeyValuesTableTableManager(_$AppDatabase db, $KeyValuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeyValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeyValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeyValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => KeyValuesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => KeyValuesCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KeyValuesTable, KvRow>(table),
                  BaseReferences<_$AppDatabase, $KeyValuesTable, KvRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KeyValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KeyValuesTable,
      KvRow,
      $$KeyValuesTableFilterComposer,
      $$KeyValuesTableOrderingComposer,
      $$KeyValuesTableAnnotationComposer,
      $$KeyValuesTableCreateCompanionBuilder,
      $$KeyValuesTableUpdateCompanionBuilder,
      (KvRow, BaseReferences<_$AppDatabase, $KeyValuesTable, KvRow>),
      KvRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PersonsTableTableManager get persons =>
      $$PersonsTableTableManager(_db, _db.persons);
  $$FundsTableTableManager get funds =>
      $$FundsTableTableManager(_db, _db.funds);
  $$LedgerAccountsTableTableManager get ledgerAccounts =>
      $$LedgerAccountsTableTableManager(_db, _db.ledgerAccounts);
  $$ObligationsTableTableManager get obligations =>
      $$ObligationsTableTableManager(_db, _db.obligations);
  $$SamitiesTableTableManager get samities =>
      $$SamitiesTableTableManager(_db, _db.samities);
  $$SamityMembersTableTableManager get samityMembers =>
      $$SamityMembersTableTableManager(_db, _db.samityMembers);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$LedgerTransactionsTableTableManager get ledgerTransactions =>
      $$LedgerTransactionsTableTableManager(_db, _db.ledgerTransactions);
  $$TransactionLinesTableTableManager get transactionLines =>
      $$TransactionLinesTableTableManager(_db, _db.transactionLines);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
  $$ReconSessionsTableTableManager get reconSessions =>
      $$ReconSessionsTableTableManager(_db, _db.reconSessions);
  $$AuditEventsTableTableManager get auditEvents =>
      $$AuditEventsTableTableManager(_db, _db.auditEvents);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
  $$KeyValuesTableTableManager get keyValues =>
      $$KeyValuesTableTableManager(_db, _db.keyValues);
}
