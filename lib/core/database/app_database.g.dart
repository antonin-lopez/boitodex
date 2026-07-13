// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class CarsFts extends Table
    with TableInfo<CarsFts, CarsFt>, VirtualTableInfo<CarsFts, CarsFt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CarsFts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  late final GeneratedColumn<String> carId = GeneratedColumn<String>(
    'car_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _keywordsMeta = const VerificationMeta(
    'keywords',
  );
  late final GeneratedColumn<String> keywords = GeneratedColumn<String>(
    'keywords',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [carId, notes, keywords];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cars_fts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CarsFt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('car_id')) {
      context.handle(
        _carIdMeta,
        carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta),
      );
    } else if (isInserting) {
      context.missing(_carIdMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('keywords')) {
      context.handle(
        _keywordsMeta,
        keywords.isAcceptableOrUnknown(data['keywords']!, _keywordsMeta),
      );
    } else if (isInserting) {
      context.missing(_keywordsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  CarsFt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarsFt(
      carId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}car_id'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      keywords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keywords'],
      )!,
    );
  }

  @override
  CarsFts createAlias(String alias) {
    return CarsFts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(car_id UNINDEXED, notes, keywords, tokenize = \'unicode61 remove_diacritics 2\')';
}

class CarsFt extends DataClass implements Insertable<CarsFt> {
  final String carId;
  final String notes;
  final String keywords;
  const CarsFt({
    required this.carId,
    required this.notes,
    required this.keywords,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['car_id'] = Variable<String>(carId);
    map['notes'] = Variable<String>(notes);
    map['keywords'] = Variable<String>(keywords);
    return map;
  }

  CarsFtsCompanion toCompanion(bool nullToAbsent) {
    return CarsFtsCompanion(
      carId: Value(carId),
      notes: Value(notes),
      keywords: Value(keywords),
    );
  }

  factory CarsFt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarsFt(
      carId: serializer.fromJson<String>(json['car_id']),
      notes: serializer.fromJson<String>(json['notes']),
      keywords: serializer.fromJson<String>(json['keywords']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'car_id': serializer.toJson<String>(carId),
      'notes': serializer.toJson<String>(notes),
      'keywords': serializer.toJson<String>(keywords),
    };
  }

  CarsFt copyWith({String? carId, String? notes, String? keywords}) => CarsFt(
    carId: carId ?? this.carId,
    notes: notes ?? this.notes,
    keywords: keywords ?? this.keywords,
  );
  CarsFt copyWithCompanion(CarsFtsCompanion data) {
    return CarsFt(
      carId: data.carId.present ? data.carId.value : this.carId,
      notes: data.notes.present ? data.notes.value : this.notes,
      keywords: data.keywords.present ? data.keywords.value : this.keywords,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarsFt(')
          ..write('carId: $carId, ')
          ..write('notes: $notes, ')
          ..write('keywords: $keywords')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(carId, notes, keywords);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarsFt &&
          other.carId == this.carId &&
          other.notes == this.notes &&
          other.keywords == this.keywords);
}

class CarsFtsCompanion extends UpdateCompanion<CarsFt> {
  final Value<String> carId;
  final Value<String> notes;
  final Value<String> keywords;
  final Value<int> rowid;
  const CarsFtsCompanion({
    this.carId = const Value.absent(),
    this.notes = const Value.absent(),
    this.keywords = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CarsFtsCompanion.insert({
    required String carId,
    required String notes,
    required String keywords,
    this.rowid = const Value.absent(),
  }) : carId = Value(carId),
       notes = Value(notes),
       keywords = Value(keywords);
  static Insertable<CarsFt> custom({
    Expression<String>? carId,
    Expression<String>? notes,
    Expression<String>? keywords,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (carId != null) 'car_id': carId,
      if (notes != null) 'notes': notes,
      if (keywords != null) 'keywords': keywords,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CarsFtsCompanion copyWith({
    Value<String>? carId,
    Value<String>? notes,
    Value<String>? keywords,
    Value<int>? rowid,
  }) {
    return CarsFtsCompanion(
      carId: carId ?? this.carId,
      notes: notes ?? this.notes,
      keywords: keywords ?? this.keywords,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (carId.present) {
      map['car_id'] = Variable<String>(carId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (keywords.present) {
      map['keywords'] = Variable<String>(keywords.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarsFtsCompanion(')
          ..write('carId: $carId, ')
          ..write('notes: $notes, ')
          ..write('keywords: $keywords, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CollectionsTableTable extends CollectionsTable
    with TableInfo<$CollectionsTableTable, CollectionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pairingCodeMeta = const VerificationMeta(
    'pairingCode',
  );
  @override
  late final GeneratedColumn<String> pairingCode = GeneratedColumn<String>(
    'pairing_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 8,
      maxTextLength: 8,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  List<GeneratedColumn> get $columns => [id, pairingCode, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<CollectionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pairing_code')) {
      context.handle(
        _pairingCodeMeta,
        pairingCode.isAcceptableOrUnknown(
          data['pairing_code']!,
          _pairingCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pairingCodeMeta);
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
  CollectionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      pairingCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pairing_code'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CollectionsTableTable createAlias(String alias) {
    return $CollectionsTableTable(attachedDatabase, alias);
  }
}

class CollectionData extends DataClass implements Insertable<CollectionData> {
  final String id;
  final String pairingCode;
  final DateTime createdAt;
  const CollectionData({
    required this.id,
    required this.pairingCode,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pairing_code'] = Variable<String>(pairingCode);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CollectionsTableCompanion toCompanion(bool nullToAbsent) {
    return CollectionsTableCompanion(
      id: Value(id),
      pairingCode: Value(pairingCode),
      createdAt: Value(createdAt),
    );
  }

  factory CollectionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionData(
      id: serializer.fromJson<String>(json['id']),
      pairingCode: serializer.fromJson<String>(json['pairingCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pairingCode': serializer.toJson<String>(pairingCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CollectionData copyWith({
    String? id,
    String? pairingCode,
    DateTime? createdAt,
  }) => CollectionData(
    id: id ?? this.id,
    pairingCode: pairingCode ?? this.pairingCode,
    createdAt: createdAt ?? this.createdAt,
  );
  CollectionData copyWithCompanion(CollectionsTableCompanion data) {
    return CollectionData(
      id: data.id.present ? data.id.value : this.id,
      pairingCode: data.pairingCode.present
          ? data.pairingCode.value
          : this.pairingCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionData(')
          ..write('id: $id, ')
          ..write('pairingCode: $pairingCode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pairingCode, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionData &&
          other.id == this.id &&
          other.pairingCode == this.pairingCode &&
          other.createdAt == this.createdAt);
}

class CollectionsTableCompanion extends UpdateCompanion<CollectionData> {
  final Value<String> id;
  final Value<String> pairingCode;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CollectionsTableCompanion({
    this.id = const Value.absent(),
    this.pairingCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollectionsTableCompanion.insert({
    required String id,
    required String pairingCode,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       pairingCode = Value(pairingCode),
       createdAt = Value(createdAt);
  static Insertable<CollectionData> custom({
    Expression<String>? id,
    Expression<String>? pairingCode,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pairingCode != null) 'pairing_code': pairingCode,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollectionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? pairingCode,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CollectionsTableCompanion(
      id: id ?? this.id,
      pairingCode: pairingCode ?? this.pairingCode,
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
    if (pairingCode.present) {
      map['pairing_code'] = Variable<String>(pairingCode.value);
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
    return (StringBuffer('CollectionsTableCompanion(')
          ..write('id: $id, ')
          ..write('pairingCode: $pairingCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CarsTableTable extends CarsTable
    with TableInfo<$CarsTableTable, CarData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<String> collectionId = GeneratedColumn<String>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES collections (id)',
    ),
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
  @override
  late final GeneratedColumnWithTypeConverter<Float32List?, Uint8List>
  embedding = GeneratedColumn<Uint8List>(
    'embedding',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  ).withConverter<Float32List?>($CarsTableTable.$converterembeddingn);
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    collectionId,
    notes,
    embedding,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cars';
  @override
  VerificationContext validateIntegrity(
    Insertable<CarData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CarData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection_id'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      embedding: $CarsTableTable.$converterembeddingn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.blob,
          data['${effectivePrefix}embedding'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $CarsTableTable createAlias(String alias) {
    return $CarsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Float32List, Uint8List> $converterembedding =
      const Float32ListConverter();
  static TypeConverter<Float32List?, Uint8List?> $converterembeddingn =
      NullAwareTypeConverter.wrap($converterembedding);
}

class CarData extends DataClass implements Insertable<CarData> {
  final String id;
  final String collectionId;
  final String? notes;
  final Float32List? embedding;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int syncStatus;
  const CarData({
    required this.id,
    required this.collectionId,
    this.notes,
    this.embedding,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['collection_id'] = Variable<String>(collectionId);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || embedding != null) {
      map['embedding'] = Variable<Uint8List>(
        $CarsTableTable.$converterembeddingn.toSql(embedding),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  CarsTableCompanion toCompanion(bool nullToAbsent) {
    return CarsTableCompanion(
      id: Value(id),
      collectionId: Value(collectionId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      embedding: embedding == null && nullToAbsent
          ? const Value.absent()
          : Value(embedding),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory CarData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarData(
      id: serializer.fromJson<String>(json['id']),
      collectionId: serializer.fromJson<String>(json['collectionId']),
      notes: serializer.fromJson<String?>(json['notes']),
      embedding: serializer.fromJson<Float32List?>(json['embedding']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'collectionId': serializer.toJson<String>(collectionId),
      'notes': serializer.toJson<String?>(notes),
      'embedding': serializer.toJson<Float32List?>(embedding),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  CarData copyWith({
    String? id,
    String? collectionId,
    Value<String?> notes = const Value.absent(),
    Value<Float32List?> embedding = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? syncStatus,
  }) => CarData(
    id: id ?? this.id,
    collectionId: collectionId ?? this.collectionId,
    notes: notes.present ? notes.value : this.notes,
    embedding: embedding.present ? embedding.value : this.embedding,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  CarData copyWithCompanion(CarsTableCompanion data) {
    return CarData(
      id: data.id.present ? data.id.value : this.id,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      notes: data.notes.present ? data.notes.value : this.notes,
      embedding: data.embedding.present ? data.embedding.value : this.embedding,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarData(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('notes: $notes, ')
          ..write('embedding: $embedding, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    collectionId,
    notes,
    embedding,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarData &&
          other.id == this.id &&
          other.collectionId == this.collectionId &&
          other.notes == this.notes &&
          other.embedding == this.embedding &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class CarsTableCompanion extends UpdateCompanion<CarData> {
  final Value<String> id;
  final Value<String> collectionId;
  final Value<String?> notes;
  final Value<Float32List?> embedding;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const CarsTableCompanion({
    this.id = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.notes = const Value.absent(),
    this.embedding = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CarsTableCompanion.insert({
    required String id,
    required String collectionId,
    this.notes = const Value.absent(),
    this.embedding = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       collectionId = Value(collectionId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CarData> custom({
    Expression<String>? id,
    Expression<String>? collectionId,
    Expression<String>? notes,
    Expression<Uint8List>? embedding,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collectionId != null) 'collection_id': collectionId,
      if (notes != null) 'notes': notes,
      if (embedding != null) 'embedding': embedding,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CarsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? collectionId,
    Value<String?>? notes,
    Value<Float32List?>? embedding,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return CarsTableCompanion(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      notes: notes ?? this.notes,
      embedding: embedding ?? this.embedding,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
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
    if (collectionId.present) {
      map['collection_id'] = Variable<String>(collectionId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (embedding.present) {
      map['embedding'] = Variable<Uint8List>(
        $CarsTableTable.$converterembeddingn.toSql(embedding.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarsTableCompanion(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('notes: $notes, ')
          ..write('embedding: $embedding, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CarImagesTableTable extends CarImagesTable
    with TableInfo<$CarImagesTableTable, CarImageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarImagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  @override
  late final GeneratedColumn<String> carId = GeneratedColumn<String>(
    'car_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cars (id)',
    ),
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteUrlMeta = const VerificationMeta(
    'remoteUrl',
  );
  @override
  late final GeneratedColumn<String> remoteUrl = GeneratedColumn<String>(
    'remote_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPrimaryMeta = const VerificationMeta(
    'isPrimary',
  );
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
    'is_primary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_primary" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    carId,
    localPath,
    remoteUrl,
    isPrimary,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'car_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<CarImageData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('car_id')) {
      context.handle(
        _carIdMeta,
        carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta),
      );
    } else if (isInserting) {
      context.missing(_carIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('remote_url')) {
      context.handle(
        _remoteUrlMeta,
        remoteUrl.isAcceptableOrUnknown(data['remote_url']!, _remoteUrlMeta),
      );
    }
    if (data.containsKey('is_primary')) {
      context.handle(
        _isPrimaryMeta,
        isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta),
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CarImageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarImageData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      carId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}car_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      remoteUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_url'],
      ),
      isPrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_primary'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $CarImagesTableTable createAlias(String alias) {
    return $CarImagesTableTable(attachedDatabase, alias);
  }
}

class CarImageData extends DataClass implements Insertable<CarImageData> {
  final String id;
  final String carId;
  final String? localPath;
  final String? remoteUrl;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int syncStatus;
  const CarImageData({
    required this.id,
    required this.carId,
    this.localPath,
    this.remoteUrl,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['car_id'] = Variable<String>(carId);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || remoteUrl != null) {
      map['remote_url'] = Variable<String>(remoteUrl);
    }
    map['is_primary'] = Variable<bool>(isPrimary);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  CarImagesTableCompanion toCompanion(bool nullToAbsent) {
    return CarImagesTableCompanion(
      id: Value(id),
      carId: Value(carId),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      remoteUrl: remoteUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUrl),
      isPrimary: Value(isPrimary),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory CarImageData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarImageData(
      id: serializer.fromJson<String>(json['id']),
      carId: serializer.fromJson<String>(json['carId']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      remoteUrl: serializer.fromJson<String?>(json['remoteUrl']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'carId': serializer.toJson<String>(carId),
      'localPath': serializer.toJson<String?>(localPath),
      'remoteUrl': serializer.toJson<String?>(remoteUrl),
      'isPrimary': serializer.toJson<bool>(isPrimary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  CarImageData copyWith({
    String? id,
    String? carId,
    Value<String?> localPath = const Value.absent(),
    Value<String?> remoteUrl = const Value.absent(),
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? syncStatus,
  }) => CarImageData(
    id: id ?? this.id,
    carId: carId ?? this.carId,
    localPath: localPath.present ? localPath.value : this.localPath,
    remoteUrl: remoteUrl.present ? remoteUrl.value : this.remoteUrl,
    isPrimary: isPrimary ?? this.isPrimary,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  CarImageData copyWithCompanion(CarImagesTableCompanion data) {
    return CarImageData(
      id: data.id.present ? data.id.value : this.id,
      carId: data.carId.present ? data.carId.value : this.carId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      remoteUrl: data.remoteUrl.present ? data.remoteUrl.value : this.remoteUrl,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarImageData(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('localPath: $localPath, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    carId,
    localPath,
    remoteUrl,
    isPrimary,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarImageData &&
          other.id == this.id &&
          other.carId == this.carId &&
          other.localPath == this.localPath &&
          other.remoteUrl == this.remoteUrl &&
          other.isPrimary == this.isPrimary &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class CarImagesTableCompanion extends UpdateCompanion<CarImageData> {
  final Value<String> id;
  final Value<String> carId;
  final Value<String?> localPath;
  final Value<String?> remoteUrl;
  final Value<bool> isPrimary;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const CarImagesTableCompanion({
    this.id = const Value.absent(),
    this.carId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CarImagesTableCompanion.insert({
    required String id,
    required String carId,
    this.localPath = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.isPrimary = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       carId = Value(carId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CarImageData> custom({
    Expression<String>? id,
    Expression<String>? carId,
    Expression<String>? localPath,
    Expression<String>? remoteUrl,
    Expression<bool>? isPrimary,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (carId != null) 'car_id': carId,
      if (localPath != null) 'local_path': localPath,
      if (remoteUrl != null) 'remote_url': remoteUrl,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CarImagesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? carId,
    Value<String?>? localPath,
    Value<String?>? remoteUrl,
    Value<bool>? isPrimary,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return CarImagesTableCompanion(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      localPath: localPath ?? this.localPath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
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
    if (carId.present) {
      map['car_id'] = Variable<String>(carId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (remoteUrl.present) {
      map['remote_url'] = Variable<String>(remoteUrl.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarImagesTableCompanion(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('localPath: $localPath, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KeywordsTableTable extends KeywordsTable
    with TableInfo<$KeywordsTableTable, KeywordData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeywordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<String> collectionId = GeneratedColumn<String>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES collections (id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
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
  List<GeneratedColumn> get $columns => [id, collectionId, label, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'keywords';
  @override
  VerificationContext validateIntegrity(
    Insertable<KeywordData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
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
  KeywordData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeywordData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $KeywordsTableTable createAlias(String alias) {
    return $KeywordsTableTable(attachedDatabase, alias);
  }
}

class KeywordData extends DataClass implements Insertable<KeywordData> {
  final String id;
  final String collectionId;
  final String label;
  final DateTime createdAt;
  const KeywordData({
    required this.id,
    required this.collectionId,
    required this.label,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['collection_id'] = Variable<String>(collectionId);
    map['label'] = Variable<String>(label);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  KeywordsTableCompanion toCompanion(bool nullToAbsent) {
    return KeywordsTableCompanion(
      id: Value(id),
      collectionId: Value(collectionId),
      label: Value(label),
      createdAt: Value(createdAt),
    );
  }

  factory KeywordData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeywordData(
      id: serializer.fromJson<String>(json['id']),
      collectionId: serializer.fromJson<String>(json['collectionId']),
      label: serializer.fromJson<String>(json['label']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'collectionId': serializer.toJson<String>(collectionId),
      'label': serializer.toJson<String>(label),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  KeywordData copyWith({
    String? id,
    String? collectionId,
    String? label,
    DateTime? createdAt,
  }) => KeywordData(
    id: id ?? this.id,
    collectionId: collectionId ?? this.collectionId,
    label: label ?? this.label,
    createdAt: createdAt ?? this.createdAt,
  );
  KeywordData copyWithCompanion(KeywordsTableCompanion data) {
    return KeywordData(
      id: data.id.present ? data.id.value : this.id,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      label: data.label.present ? data.label.value : this.label,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeywordData(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, collectionId, label, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeywordData &&
          other.id == this.id &&
          other.collectionId == this.collectionId &&
          other.label == this.label &&
          other.createdAt == this.createdAt);
}

class KeywordsTableCompanion extends UpdateCompanion<KeywordData> {
  final Value<String> id;
  final Value<String> collectionId;
  final Value<String> label;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const KeywordsTableCompanion({
    this.id = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.label = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeywordsTableCompanion.insert({
    required String id,
    required String collectionId,
    required String label,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       collectionId = Value(collectionId),
       label = Value(label),
       createdAt = Value(createdAt);
  static Insertable<KeywordData> custom({
    Expression<String>? id,
    Expression<String>? collectionId,
    Expression<String>? label,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collectionId != null) 'collection_id': collectionId,
      if (label != null) 'label': label,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeywordsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? collectionId,
    Value<String>? label,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return KeywordsTableCompanion(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      label: label ?? this.label,
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
    if (collectionId.present) {
      map['collection_id'] = Variable<String>(collectionId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
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
    return (StringBuffer('KeywordsTableCompanion(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CarKeywordsTableTable extends CarKeywordsTable
    with TableInfo<$CarKeywordsTableTable, CarKeywordData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarKeywordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  @override
  late final GeneratedColumn<String> carId = GeneratedColumn<String>(
    'car_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cars (id)',
    ),
  );
  static const VerificationMeta _keywordIdMeta = const VerificationMeta(
    'keywordId',
  );
  @override
  late final GeneratedColumn<String> keywordId = GeneratedColumn<String>(
    'keyword_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES keywords (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [carId, keywordId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'car_keywords';
  @override
  VerificationContext validateIntegrity(
    Insertable<CarKeywordData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('car_id')) {
      context.handle(
        _carIdMeta,
        carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta),
      );
    } else if (isInserting) {
      context.missing(_carIdMeta);
    }
    if (data.containsKey('keyword_id')) {
      context.handle(
        _keywordIdMeta,
        keywordId.isAcceptableOrUnknown(data['keyword_id']!, _keywordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_keywordIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {carId, keywordId};
  @override
  CarKeywordData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarKeywordData(
      carId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}car_id'],
      )!,
      keywordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keyword_id'],
      )!,
    );
  }

  @override
  $CarKeywordsTableTable createAlias(String alias) {
    return $CarKeywordsTableTable(attachedDatabase, alias);
  }
}

class CarKeywordData extends DataClass implements Insertable<CarKeywordData> {
  final String carId;
  final String keywordId;
  const CarKeywordData({required this.carId, required this.keywordId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['car_id'] = Variable<String>(carId);
    map['keyword_id'] = Variable<String>(keywordId);
    return map;
  }

  CarKeywordsTableCompanion toCompanion(bool nullToAbsent) {
    return CarKeywordsTableCompanion(
      carId: Value(carId),
      keywordId: Value(keywordId),
    );
  }

  factory CarKeywordData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarKeywordData(
      carId: serializer.fromJson<String>(json['carId']),
      keywordId: serializer.fromJson<String>(json['keywordId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'carId': serializer.toJson<String>(carId),
      'keywordId': serializer.toJson<String>(keywordId),
    };
  }

  CarKeywordData copyWith({String? carId, String? keywordId}) => CarKeywordData(
    carId: carId ?? this.carId,
    keywordId: keywordId ?? this.keywordId,
  );
  CarKeywordData copyWithCompanion(CarKeywordsTableCompanion data) {
    return CarKeywordData(
      carId: data.carId.present ? data.carId.value : this.carId,
      keywordId: data.keywordId.present ? data.keywordId.value : this.keywordId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarKeywordData(')
          ..write('carId: $carId, ')
          ..write('keywordId: $keywordId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(carId, keywordId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarKeywordData &&
          other.carId == this.carId &&
          other.keywordId == this.keywordId);
}

class CarKeywordsTableCompanion extends UpdateCompanion<CarKeywordData> {
  final Value<String> carId;
  final Value<String> keywordId;
  final Value<int> rowid;
  const CarKeywordsTableCompanion({
    this.carId = const Value.absent(),
    this.keywordId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CarKeywordsTableCompanion.insert({
    required String carId,
    required String keywordId,
    this.rowid = const Value.absent(),
  }) : carId = Value(carId),
       keywordId = Value(keywordId);
  static Insertable<CarKeywordData> custom({
    Expression<String>? carId,
    Expression<String>? keywordId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (carId != null) 'car_id': carId,
      if (keywordId != null) 'keyword_id': keywordId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CarKeywordsTableCompanion copyWith({
    Value<String>? carId,
    Value<String>? keywordId,
    Value<int>? rowid,
  }) {
    return CarKeywordsTableCompanion(
      carId: carId ?? this.carId,
      keywordId: keywordId ?? this.keywordId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (carId.present) {
      map['car_id'] = Variable<String>(carId.value);
    }
    if (keywordId.present) {
      map['keyword_id'] = Variable<String>(keywordId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarKeywordsTableCompanion(')
          ..write('carId: $carId, ')
          ..write('keywordId: $keywordId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncCursorsTableTable extends SyncCursorsTable
    with TableInfo<$SyncCursorsTableTable, SyncCursorData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCursorsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<String> collectionId = GeneratedColumn<String>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES collections (id)',
    ),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [deviceId, collectionId, lastSyncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCursorData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSyncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  SyncCursorData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCursorData(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection_id'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      )!,
    );
  }

  @override
  $SyncCursorsTableTable createAlias(String alias) {
    return $SyncCursorsTableTable(attachedDatabase, alias);
  }
}

class SyncCursorData extends DataClass implements Insertable<SyncCursorData> {
  final String deviceId;
  final String collectionId;
  final DateTime lastSyncedAt;
  const SyncCursorData({
    required this.deviceId,
    required this.collectionId,
    required this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['collection_id'] = Variable<String>(collectionId);
    map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    return map;
  }

  SyncCursorsTableCompanion toCompanion(bool nullToAbsent) {
    return SyncCursorsTableCompanion(
      deviceId: Value(deviceId),
      collectionId: Value(collectionId),
      lastSyncedAt: Value(lastSyncedAt),
    );
  }

  factory SyncCursorData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCursorData(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      collectionId: serializer.fromJson<String>(json['collectionId']),
      lastSyncedAt: serializer.fromJson<DateTime>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'collectionId': serializer.toJson<String>(collectionId),
      'lastSyncedAt': serializer.toJson<DateTime>(lastSyncedAt),
    };
  }

  SyncCursorData copyWith({
    String? deviceId,
    String? collectionId,
    DateTime? lastSyncedAt,
  }) => SyncCursorData(
    deviceId: deviceId ?? this.deviceId,
    collectionId: collectionId ?? this.collectionId,
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
  );
  SyncCursorData copyWithCompanion(SyncCursorsTableCompanion data) {
    return SyncCursorData(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorData(')
          ..write('deviceId: $deviceId, ')
          ..write('collectionId: $collectionId, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deviceId, collectionId, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCursorData &&
          other.deviceId == this.deviceId &&
          other.collectionId == this.collectionId &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class SyncCursorsTableCompanion extends UpdateCompanion<SyncCursorData> {
  final Value<String> deviceId;
  final Value<String> collectionId;
  final Value<DateTime> lastSyncedAt;
  final Value<int> rowid;
  const SyncCursorsTableCompanion({
    this.deviceId = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCursorsTableCompanion.insert({
    required String deviceId,
    required String collectionId,
    required DateTime lastSyncedAt,
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       collectionId = Value(collectionId),
       lastSyncedAt = Value(lastSyncedAt);
  static Insertable<SyncCursorData> custom({
    Expression<String>? deviceId,
    Expression<String>? collectionId,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (collectionId != null) 'collection_id': collectionId,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCursorsTableCompanion copyWith({
    Value<String>? deviceId,
    Value<String>? collectionId,
    Value<DateTime>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return SyncCursorsTableCompanion(
      deviceId: deviceId ?? this.deviceId,
      collectionId: collectionId ?? this.collectionId,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<String>(collectionId.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorsTableCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('collectionId: $collectionId, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final CarsFts carsFts = CarsFts(this);
  late final $CollectionsTableTable collectionsTable = $CollectionsTableTable(
    this,
  );
  late final $CarsTableTable carsTable = $CarsTableTable(this);
  late final $CarImagesTableTable carImagesTable = $CarImagesTableTable(this);
  late final $KeywordsTableTable keywordsTable = $KeywordsTableTable(this);
  late final $CarKeywordsTableTable carKeywordsTable = $CarKeywordsTableTable(
    this,
  );
  late final $SyncCursorsTableTable syncCursorsTable = $SyncCursorsTableTable(
    this,
  );
  late final CollectionsDao collectionsDao = CollectionsDao(
    this as AppDatabase,
  );
  late final CarsDao carsDao = CarsDao(this as AppDatabase);
  late final KeywordsDao keywordsDao = KeywordsDao(this as AppDatabase);
  Selectable<String> searchCarsByText(String query) {
    return customSelect(
      'SELECT car_id FROM cars_fts WHERE cars_fts MATCH ?1 ORDER BY rank',
      variables: [Variable<String>(query)],
      readsFrom: {carsFts},
    ).map((QueryRow row) => row.read<String>('car_id'));
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    carsFts,
    collectionsTable,
    carsTable,
    carImagesTable,
    keywordsTable,
    carKeywordsTable,
    syncCursorsTable,
  ];
}

typedef $CarsFtsCreateCompanionBuilder =
    CarsFtsCompanion Function({
      required String carId,
      required String notes,
      required String keywords,
      Value<int> rowid,
    });
typedef $CarsFtsUpdateCompanionBuilder =
    CarsFtsCompanion Function({
      Value<String> carId,
      Value<String> notes,
      Value<String> keywords,
      Value<int> rowid,
    });

class $CarsFtsFilterComposer extends Composer<_$AppDatabase, CarsFts> {
  $CarsFtsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get carId => $composableBuilder(
    column: $table.carId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keywords => $composableBuilder(
    column: $table.keywords,
    builder: (column) => ColumnFilters(column),
  );
}

class $CarsFtsOrderingComposer extends Composer<_$AppDatabase, CarsFts> {
  $CarsFtsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get carId => $composableBuilder(
    column: $table.carId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keywords => $composableBuilder(
    column: $table.keywords,
    builder: (column) => ColumnOrderings(column),
  );
}

class $CarsFtsAnnotationComposer extends Composer<_$AppDatabase, CarsFts> {
  $CarsFtsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get carId =>
      $composableBuilder(column: $table.carId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get keywords =>
      $composableBuilder(column: $table.keywords, builder: (column) => column);
}

class $CarsFtsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          CarsFts,
          CarsFt,
          $CarsFtsFilterComposer,
          $CarsFtsOrderingComposer,
          $CarsFtsAnnotationComposer,
          $CarsFtsCreateCompanionBuilder,
          $CarsFtsUpdateCompanionBuilder,
          (CarsFt, BaseReferences<_$AppDatabase, CarsFts, CarsFt>),
          CarsFt,
          PrefetchHooks Function()
        > {
  $CarsFtsTableManager(_$AppDatabase db, CarsFts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CarsFtsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CarsFtsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CarsFtsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> carId = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> keywords = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CarsFtsCompanion(
                carId: carId,
                notes: notes,
                keywords: keywords,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String carId,
                required String notes,
                required String keywords,
                Value<int> rowid = const Value.absent(),
              }) => CarsFtsCompanion.insert(
                carId: carId,
                notes: notes,
                keywords: keywords,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $CarsFtsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      CarsFts,
      CarsFt,
      $CarsFtsFilterComposer,
      $CarsFtsOrderingComposer,
      $CarsFtsAnnotationComposer,
      $CarsFtsCreateCompanionBuilder,
      $CarsFtsUpdateCompanionBuilder,
      (CarsFt, BaseReferences<_$AppDatabase, CarsFts, CarsFt>),
      CarsFt,
      PrefetchHooks Function()
    >;
typedef $$CollectionsTableTableCreateCompanionBuilder =
    CollectionsTableCompanion Function({
      required String id,
      required String pairingCode,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CollectionsTableTableUpdateCompanionBuilder =
    CollectionsTableCompanion Function({
      Value<String> id,
      Value<String> pairingCode,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CollectionsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $CollectionsTableTable, CollectionData> {
  $$CollectionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CarsTableTable, List<CarData>>
  _carsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.carsTable,
    aliasName: 'collections__id__cars__collection_id',
  );

  $$CarsTableTableProcessedTableManager get carsTableRefs {
    final manager = $$CarsTableTableTableManager(
      $_db,
      $_db.carsTable,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_carsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$KeywordsTableTable, List<KeywordData>>
  _keywordsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.keywordsTable,
    aliasName: 'collections__id__keywords__collection_id',
  );

  $$KeywordsTableTableProcessedTableManager get keywordsTableRefs {
    final manager = $$KeywordsTableTableTableManager(
      $_db,
      $_db.keywordsTable,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_keywordsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SyncCursorsTableTable, List<SyncCursorData>>
  _syncCursorsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.syncCursorsTable,
    aliasName: 'collections__id__sync_cursors__collection_id',
  );

  $$SyncCursorsTableTableProcessedTableManager get syncCursorsTableRefs {
    final manager = $$SyncCursorsTableTableTableManager(
      $_db,
      $_db.syncCursorsTable,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _syncCursorsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CollectionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionsTableTable> {
  $$CollectionsTableTableFilterComposer({
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

  ColumnFilters<String> get pairingCode => $composableBuilder(
    column: $table.pairingCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> carsTableRefs(
    Expression<bool> Function($$CarsTableTableFilterComposer f) f,
  ) {
    final $$CarsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carsTable,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarsTableTableFilterComposer(
            $db: $db,
            $table: $db.carsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> keywordsTableRefs(
    Expression<bool> Function($$KeywordsTableTableFilterComposer f) f,
  ) {
    final $$KeywordsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.keywordsTable,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KeywordsTableTableFilterComposer(
            $db: $db,
            $table: $db.keywordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> syncCursorsTableRefs(
    Expression<bool> Function($$SyncCursorsTableTableFilterComposer f) f,
  ) {
    final $$SyncCursorsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncCursorsTable,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncCursorsTableTableFilterComposer(
            $db: $db,
            $table: $db.syncCursorsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionsTableTable> {
  $$CollectionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get pairingCode => $composableBuilder(
    column: $table.pairingCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CollectionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionsTableTable> {
  $$CollectionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pairingCode => $composableBuilder(
    column: $table.pairingCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> carsTableRefs<T extends Object>(
    Expression<T> Function($$CarsTableTableAnnotationComposer a) f,
  ) {
    final $$CarsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carsTable,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.carsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> keywordsTableRefs<T extends Object>(
    Expression<T> Function($$KeywordsTableTableAnnotationComposer a) f,
  ) {
    final $$KeywordsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.keywordsTable,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KeywordsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.keywordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> syncCursorsTableRefs<T extends Object>(
    Expression<T> Function($$SyncCursorsTableTableAnnotationComposer a) f,
  ) {
    final $$SyncCursorsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncCursorsTable,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncCursorsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.syncCursorsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionsTableTable,
          CollectionData,
          $$CollectionsTableTableFilterComposer,
          $$CollectionsTableTableOrderingComposer,
          $$CollectionsTableTableAnnotationComposer,
          $$CollectionsTableTableCreateCompanionBuilder,
          $$CollectionsTableTableUpdateCompanionBuilder,
          (CollectionData, $$CollectionsTableTableReferences),
          CollectionData,
          PrefetchHooks Function({
            bool carsTableRefs,
            bool keywordsTableRefs,
            bool syncCursorsTableRefs,
          })
        > {
  $$CollectionsTableTableTableManager(
    _$AppDatabase db,
    $CollectionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> pairingCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CollectionsTableCompanion(
                id: id,
                pairingCode: pairingCode,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String pairingCode,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CollectionsTableCompanion.insert(
                id: id,
                pairingCode: pairingCode,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CollectionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                carsTableRefs = false,
                keywordsTableRefs = false,
                syncCursorsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (carsTableRefs) db.carsTable,
                    if (keywordsTableRefs) db.keywordsTable,
                    if (syncCursorsTableRefs) db.syncCursorsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (carsTableRefs)
                        await $_getPrefetchedData<
                          CollectionData,
                          $CollectionsTableTable,
                          CarData
                        >(
                          currentTable: table,
                          referencedTable: $$CollectionsTableTableReferences
                              ._carsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CollectionsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).carsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.collectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (keywordsTableRefs)
                        await $_getPrefetchedData<
                          CollectionData,
                          $CollectionsTableTable,
                          KeywordData
                        >(
                          currentTable: table,
                          referencedTable: $$CollectionsTableTableReferences
                              ._keywordsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CollectionsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).keywordsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.collectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (syncCursorsTableRefs)
                        await $_getPrefetchedData<
                          CollectionData,
                          $CollectionsTableTable,
                          SyncCursorData
                        >(
                          currentTable: table,
                          referencedTable: $$CollectionsTableTableReferences
                              ._syncCursorsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CollectionsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).syncCursorsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.collectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CollectionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionsTableTable,
      CollectionData,
      $$CollectionsTableTableFilterComposer,
      $$CollectionsTableTableOrderingComposer,
      $$CollectionsTableTableAnnotationComposer,
      $$CollectionsTableTableCreateCompanionBuilder,
      $$CollectionsTableTableUpdateCompanionBuilder,
      (CollectionData, $$CollectionsTableTableReferences),
      CollectionData,
      PrefetchHooks Function({
        bool carsTableRefs,
        bool keywordsTableRefs,
        bool syncCursorsTableRefs,
      })
    >;
typedef $$CarsTableTableCreateCompanionBuilder =
    CarsTableCompanion Function({
      required String id,
      required String collectionId,
      Value<String?> notes,
      Value<Float32List?> embedding,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$CarsTableTableUpdateCompanionBuilder =
    CarsTableCompanion Function({
      Value<String> id,
      Value<String> collectionId,
      Value<String?> notes,
      Value<Float32List?> embedding,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> syncStatus,
      Value<int> rowid,
    });

final class $$CarsTableTableReferences
    extends BaseReferences<_$AppDatabase, $CarsTableTable, CarData> {
  $$CarsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CollectionsTableTable _collectionIdTable(_$AppDatabase db) =>
      db.collectionsTable.createAlias('cars__collection_id__collections__id');

  $$CollectionsTableTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<String>('collection_id')!;

    final manager = $$CollectionsTableTableTableManager(
      $_db,
      $_db.collectionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CarImagesTableTable, List<CarImageData>>
  _carImagesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.carImagesTable,
    aliasName: 'cars__id__car_images__car_id',
  );

  $$CarImagesTableTableProcessedTableManager get carImagesTableRefs {
    final manager = $$CarImagesTableTableTableManager(
      $_db,
      $_db.carImagesTable,
    ).filter((f) => f.carId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_carImagesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CarKeywordsTableTable, List<CarKeywordData>>
  _carKeywordsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.carKeywordsTable,
    aliasName: 'cars__id__car_keywords__car_id',
  );

  $$CarKeywordsTableTableProcessedTableManager get carKeywordsTableRefs {
    final manager = $$CarKeywordsTableTableTableManager(
      $_db,
      $_db.carKeywordsTable,
    ).filter((f) => f.carId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _carKeywordsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CarsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CarsTableTable> {
  $$CarsTableTableFilterComposer({
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

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Float32List?, Float32List, Uint8List>
  get embedding => $composableBuilder(
    column: $table.embedding,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$CollectionsTableTableFilterComposer get collectionId {
    final $$CollectionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collectionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableTableFilterComposer(
            $db: $db,
            $table: $db.collectionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> carImagesTableRefs(
    Expression<bool> Function($$CarImagesTableTableFilterComposer f) f,
  ) {
    final $$CarImagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carImagesTable,
      getReferencedColumn: (t) => t.carId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarImagesTableTableFilterComposer(
            $db: $db,
            $table: $db.carImagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> carKeywordsTableRefs(
    Expression<bool> Function($$CarKeywordsTableTableFilterComposer f) f,
  ) {
    final $$CarKeywordsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carKeywordsTable,
      getReferencedColumn: (t) => t.carId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarKeywordsTableTableFilterComposer(
            $db: $db,
            $table: $db.carKeywordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CarsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CarsTableTable> {
  $$CarsTableTableOrderingComposer({
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

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get embedding => $composableBuilder(
    column: $table.embedding,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$CollectionsTableTableOrderingComposer get collectionId {
    final $$CollectionsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collectionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableTableOrderingComposer(
            $db: $db,
            $table: $db.collectionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarsTableTable> {
  $$CarsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Float32List?, Uint8List> get embedding =>
      $composableBuilder(column: $table.embedding, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$CollectionsTableTableAnnotationComposer get collectionId {
    final $$CollectionsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collectionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.collectionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> carImagesTableRefs<T extends Object>(
    Expression<T> Function($$CarImagesTableTableAnnotationComposer a) f,
  ) {
    final $$CarImagesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carImagesTable,
      getReferencedColumn: (t) => t.carId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarImagesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.carImagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> carKeywordsTableRefs<T extends Object>(
    Expression<T> Function($$CarKeywordsTableTableAnnotationComposer a) f,
  ) {
    final $$CarKeywordsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carKeywordsTable,
      getReferencedColumn: (t) => t.carId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarKeywordsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.carKeywordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CarsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CarsTableTable,
          CarData,
          $$CarsTableTableFilterComposer,
          $$CarsTableTableOrderingComposer,
          $$CarsTableTableAnnotationComposer,
          $$CarsTableTableCreateCompanionBuilder,
          $$CarsTableTableUpdateCompanionBuilder,
          (CarData, $$CarsTableTableReferences),
          CarData,
          PrefetchHooks Function({
            bool collectionId,
            bool carImagesTableRefs,
            bool carKeywordsTableRefs,
          })
        > {
  $$CarsTableTableTableManager(_$AppDatabase db, $CarsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> collectionId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<Float32List?> embedding = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CarsTableCompanion(
                id: id,
                collectionId: collectionId,
                notes: notes,
                embedding: embedding,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String collectionId,
                Value<String?> notes = const Value.absent(),
                Value<Float32List?> embedding = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CarsTableCompanion.insert(
                id: id,
                collectionId: collectionId,
                notes: notes,
                embedding: embedding,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CarsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                collectionId = false,
                carImagesTableRefs = false,
                carKeywordsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (carImagesTableRefs) db.carImagesTable,
                    if (carKeywordsTableRefs) db.carKeywordsTable,
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
                        if (collectionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.collectionId,
                                    referencedTable: $$CarsTableTableReferences
                                        ._collectionIdTable(db),
                                    referencedColumn: $$CarsTableTableReferences
                                        ._collectionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (carImagesTableRefs)
                        await $_getPrefetchedData<
                          CarData,
                          $CarsTableTable,
                          CarImageData
                        >(
                          currentTable: table,
                          referencedTable: $$CarsTableTableReferences
                              ._carImagesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CarsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).carImagesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.carId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (carKeywordsTableRefs)
                        await $_getPrefetchedData<
                          CarData,
                          $CarsTableTable,
                          CarKeywordData
                        >(
                          currentTable: table,
                          referencedTable: $$CarsTableTableReferences
                              ._carKeywordsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CarsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).carKeywordsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.carId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CarsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CarsTableTable,
      CarData,
      $$CarsTableTableFilterComposer,
      $$CarsTableTableOrderingComposer,
      $$CarsTableTableAnnotationComposer,
      $$CarsTableTableCreateCompanionBuilder,
      $$CarsTableTableUpdateCompanionBuilder,
      (CarData, $$CarsTableTableReferences),
      CarData,
      PrefetchHooks Function({
        bool collectionId,
        bool carImagesTableRefs,
        bool carKeywordsTableRefs,
      })
    >;
typedef $$CarImagesTableTableCreateCompanionBuilder =
    CarImagesTableCompanion Function({
      required String id,
      required String carId,
      Value<String?> localPath,
      Value<String?> remoteUrl,
      Value<bool> isPrimary,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$CarImagesTableTableUpdateCompanionBuilder =
    CarImagesTableCompanion Function({
      Value<String> id,
      Value<String> carId,
      Value<String?> localPath,
      Value<String?> remoteUrl,
      Value<bool> isPrimary,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> syncStatus,
      Value<int> rowid,
    });

final class $$CarImagesTableTableReferences
    extends BaseReferences<_$AppDatabase, $CarImagesTableTable, CarImageData> {
  $$CarImagesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CarsTableTable _carIdTable(_$AppDatabase db) =>
      db.carsTable.createAlias('car_images__car_id__cars__id');

  $$CarsTableTableProcessedTableManager get carId {
    final $_column = $_itemColumn<String>('car_id')!;

    final manager = $$CarsTableTableTableManager(
      $_db,
      $_db.carsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_carIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CarImagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CarImagesTableTable> {
  $$CarImagesTableTableFilterComposer({
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

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteUrl => $composableBuilder(
    column: $table.remoteUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$CarsTableTableFilterComposer get carId {
    final $$CarsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carId,
      referencedTable: $db.carsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarsTableTableFilterComposer(
            $db: $db,
            $table: $db.carsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarImagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CarImagesTableTable> {
  $$CarImagesTableTableOrderingComposer({
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

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteUrl => $composableBuilder(
    column: $table.remoteUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$CarsTableTableOrderingComposer get carId {
    final $$CarsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carId,
      referencedTable: $db.carsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarsTableTableOrderingComposer(
            $db: $db,
            $table: $db.carsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarImagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarImagesTableTable> {
  $$CarImagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get remoteUrl =>
      $composableBuilder(column: $table.remoteUrl, builder: (column) => column);

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$CarsTableTableAnnotationComposer get carId {
    final $$CarsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carId,
      referencedTable: $db.carsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.carsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarImagesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CarImagesTableTable,
          CarImageData,
          $$CarImagesTableTableFilterComposer,
          $$CarImagesTableTableOrderingComposer,
          $$CarImagesTableTableAnnotationComposer,
          $$CarImagesTableTableCreateCompanionBuilder,
          $$CarImagesTableTableUpdateCompanionBuilder,
          (CarImageData, $$CarImagesTableTableReferences),
          CarImageData,
          PrefetchHooks Function({bool carId})
        > {
  $$CarImagesTableTableTableManager(
    _$AppDatabase db,
    $CarImagesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarImagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarImagesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarImagesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> carId = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<String?> remoteUrl = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CarImagesTableCompanion(
                id: id,
                carId: carId,
                localPath: localPath,
                remoteUrl: remoteUrl,
                isPrimary: isPrimary,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String carId,
                Value<String?> localPath = const Value.absent(),
                Value<String?> remoteUrl = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CarImagesTableCompanion.insert(
                id: id,
                carId: carId,
                localPath: localPath,
                remoteUrl: remoteUrl,
                isPrimary: isPrimary,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CarImagesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({carId = false}) {
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
                    if (carId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.carId,
                                referencedTable: $$CarImagesTableTableReferences
                                    ._carIdTable(db),
                                referencedColumn:
                                    $$CarImagesTableTableReferences
                                        ._carIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$CarImagesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CarImagesTableTable,
      CarImageData,
      $$CarImagesTableTableFilterComposer,
      $$CarImagesTableTableOrderingComposer,
      $$CarImagesTableTableAnnotationComposer,
      $$CarImagesTableTableCreateCompanionBuilder,
      $$CarImagesTableTableUpdateCompanionBuilder,
      (CarImageData, $$CarImagesTableTableReferences),
      CarImageData,
      PrefetchHooks Function({bool carId})
    >;
typedef $$KeywordsTableTableCreateCompanionBuilder =
    KeywordsTableCompanion Function({
      required String id,
      required String collectionId,
      required String label,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$KeywordsTableTableUpdateCompanionBuilder =
    KeywordsTableCompanion Function({
      Value<String> id,
      Value<String> collectionId,
      Value<String> label,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$KeywordsTableTableReferences
    extends BaseReferences<_$AppDatabase, $KeywordsTableTable, KeywordData> {
  $$KeywordsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CollectionsTableTable _collectionIdTable(_$AppDatabase db) => db
      .collectionsTable
      .createAlias('keywords__collection_id__collections__id');

  $$CollectionsTableTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<String>('collection_id')!;

    final manager = $$CollectionsTableTableTableManager(
      $_db,
      $_db.collectionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CarKeywordsTableTable, List<CarKeywordData>>
  _carKeywordsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.carKeywordsTable,
    aliasName: 'keywords__id__car_keywords__keyword_id',
  );

  $$CarKeywordsTableTableProcessedTableManager get carKeywordsTableRefs {
    final manager = $$CarKeywordsTableTableTableManager(
      $_db,
      $_db.carKeywordsTable,
    ).filter((f) => f.keywordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _carKeywordsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KeywordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $KeywordsTableTable> {
  $$KeywordsTableTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CollectionsTableTableFilterComposer get collectionId {
    final $$CollectionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collectionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableTableFilterComposer(
            $db: $db,
            $table: $db.collectionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> carKeywordsTableRefs(
    Expression<bool> Function($$CarKeywordsTableTableFilterComposer f) f,
  ) {
    final $$CarKeywordsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carKeywordsTable,
      getReferencedColumn: (t) => t.keywordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarKeywordsTableTableFilterComposer(
            $db: $db,
            $table: $db.carKeywordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KeywordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $KeywordsTableTable> {
  $$KeywordsTableTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CollectionsTableTableOrderingComposer get collectionId {
    final $$CollectionsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collectionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableTableOrderingComposer(
            $db: $db,
            $table: $db.collectionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KeywordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $KeywordsTableTable> {
  $$KeywordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CollectionsTableTableAnnotationComposer get collectionId {
    final $$CollectionsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collectionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.collectionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> carKeywordsTableRefs<T extends Object>(
    Expression<T> Function($$CarKeywordsTableTableAnnotationComposer a) f,
  ) {
    final $$CarKeywordsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carKeywordsTable,
      getReferencedColumn: (t) => t.keywordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarKeywordsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.carKeywordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KeywordsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KeywordsTableTable,
          KeywordData,
          $$KeywordsTableTableFilterComposer,
          $$KeywordsTableTableOrderingComposer,
          $$KeywordsTableTableAnnotationComposer,
          $$KeywordsTableTableCreateCompanionBuilder,
          $$KeywordsTableTableUpdateCompanionBuilder,
          (KeywordData, $$KeywordsTableTableReferences),
          KeywordData,
          PrefetchHooks Function({bool collectionId, bool carKeywordsTableRefs})
        > {
  $$KeywordsTableTableTableManager(_$AppDatabase db, $KeywordsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeywordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeywordsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeywordsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> collectionId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KeywordsTableCompanion(
                id: id,
                collectionId: collectionId,
                label: label,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String collectionId,
                required String label,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => KeywordsTableCompanion.insert(
                id: id,
                collectionId: collectionId,
                label: label,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KeywordsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({collectionId = false, carKeywordsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (carKeywordsTableRefs) db.carKeywordsTable,
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
                        if (collectionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.collectionId,
                                    referencedTable:
                                        $$KeywordsTableTableReferences
                                            ._collectionIdTable(db),
                                    referencedColumn:
                                        $$KeywordsTableTableReferences
                                            ._collectionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (carKeywordsTableRefs)
                        await $_getPrefetchedData<
                          KeywordData,
                          $KeywordsTableTable,
                          CarKeywordData
                        >(
                          currentTable: table,
                          referencedTable: $$KeywordsTableTableReferences
                              ._carKeywordsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KeywordsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).carKeywordsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.keywordId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$KeywordsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KeywordsTableTable,
      KeywordData,
      $$KeywordsTableTableFilterComposer,
      $$KeywordsTableTableOrderingComposer,
      $$KeywordsTableTableAnnotationComposer,
      $$KeywordsTableTableCreateCompanionBuilder,
      $$KeywordsTableTableUpdateCompanionBuilder,
      (KeywordData, $$KeywordsTableTableReferences),
      KeywordData,
      PrefetchHooks Function({bool collectionId, bool carKeywordsTableRefs})
    >;
typedef $$CarKeywordsTableTableCreateCompanionBuilder =
    CarKeywordsTableCompanion Function({
      required String carId,
      required String keywordId,
      Value<int> rowid,
    });
typedef $$CarKeywordsTableTableUpdateCompanionBuilder =
    CarKeywordsTableCompanion Function({
      Value<String> carId,
      Value<String> keywordId,
      Value<int> rowid,
    });

final class $$CarKeywordsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $CarKeywordsTableTable, CarKeywordData> {
  $$CarKeywordsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CarsTableTable _carIdTable(_$AppDatabase db) =>
      db.carsTable.createAlias('car_keywords__car_id__cars__id');

  $$CarsTableTableProcessedTableManager get carId {
    final $_column = $_itemColumn<String>('car_id')!;

    final manager = $$CarsTableTableTableManager(
      $_db,
      $_db.carsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_carIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $KeywordsTableTable _keywordIdTable(_$AppDatabase db) =>
      db.keywordsTable.createAlias('car_keywords__keyword_id__keywords__id');

  $$KeywordsTableTableProcessedTableManager get keywordId {
    final $_column = $_itemColumn<String>('keyword_id')!;

    final manager = $$KeywordsTableTableTableManager(
      $_db,
      $_db.keywordsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_keywordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CarKeywordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CarKeywordsTableTable> {
  $$CarKeywordsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CarsTableTableFilterComposer get carId {
    final $$CarsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carId,
      referencedTable: $db.carsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarsTableTableFilterComposer(
            $db: $db,
            $table: $db.carsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KeywordsTableTableFilterComposer get keywordId {
    final $$KeywordsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.keywordId,
      referencedTable: $db.keywordsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KeywordsTableTableFilterComposer(
            $db: $db,
            $table: $db.keywordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarKeywordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CarKeywordsTableTable> {
  $$CarKeywordsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CarsTableTableOrderingComposer get carId {
    final $$CarsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carId,
      referencedTable: $db.carsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarsTableTableOrderingComposer(
            $db: $db,
            $table: $db.carsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KeywordsTableTableOrderingComposer get keywordId {
    final $$KeywordsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.keywordId,
      referencedTable: $db.keywordsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KeywordsTableTableOrderingComposer(
            $db: $db,
            $table: $db.keywordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarKeywordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarKeywordsTableTable> {
  $$CarKeywordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CarsTableTableAnnotationComposer get carId {
    final $$CarsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.carId,
      referencedTable: $db.carsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.carsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KeywordsTableTableAnnotationComposer get keywordId {
    final $$KeywordsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.keywordId,
      referencedTable: $db.keywordsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KeywordsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.keywordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarKeywordsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CarKeywordsTableTable,
          CarKeywordData,
          $$CarKeywordsTableTableFilterComposer,
          $$CarKeywordsTableTableOrderingComposer,
          $$CarKeywordsTableTableAnnotationComposer,
          $$CarKeywordsTableTableCreateCompanionBuilder,
          $$CarKeywordsTableTableUpdateCompanionBuilder,
          (CarKeywordData, $$CarKeywordsTableTableReferences),
          CarKeywordData,
          PrefetchHooks Function({bool carId, bool keywordId})
        > {
  $$CarKeywordsTableTableTableManager(
    _$AppDatabase db,
    $CarKeywordsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarKeywordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarKeywordsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarKeywordsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> carId = const Value.absent(),
                Value<String> keywordId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CarKeywordsTableCompanion(
                carId: carId,
                keywordId: keywordId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String carId,
                required String keywordId,
                Value<int> rowid = const Value.absent(),
              }) => CarKeywordsTableCompanion.insert(
                carId: carId,
                keywordId: keywordId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CarKeywordsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({carId = false, keywordId = false}) {
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
                    if (carId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.carId,
                                referencedTable:
                                    $$CarKeywordsTableTableReferences
                                        ._carIdTable(db),
                                referencedColumn:
                                    $$CarKeywordsTableTableReferences
                                        ._carIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (keywordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.keywordId,
                                referencedTable:
                                    $$CarKeywordsTableTableReferences
                                        ._keywordIdTable(db),
                                referencedColumn:
                                    $$CarKeywordsTableTableReferences
                                        ._keywordIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$CarKeywordsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CarKeywordsTableTable,
      CarKeywordData,
      $$CarKeywordsTableTableFilterComposer,
      $$CarKeywordsTableTableOrderingComposer,
      $$CarKeywordsTableTableAnnotationComposer,
      $$CarKeywordsTableTableCreateCompanionBuilder,
      $$CarKeywordsTableTableUpdateCompanionBuilder,
      (CarKeywordData, $$CarKeywordsTableTableReferences),
      CarKeywordData,
      PrefetchHooks Function({bool carId, bool keywordId})
    >;
typedef $$SyncCursorsTableTableCreateCompanionBuilder =
    SyncCursorsTableCompanion Function({
      required String deviceId,
      required String collectionId,
      required DateTime lastSyncedAt,
      Value<int> rowid,
    });
typedef $$SyncCursorsTableTableUpdateCompanionBuilder =
    SyncCursorsTableCompanion Function({
      Value<String> deviceId,
      Value<String> collectionId,
      Value<DateTime> lastSyncedAt,
      Value<int> rowid,
    });

final class $$SyncCursorsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $SyncCursorsTableTable, SyncCursorData> {
  $$SyncCursorsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CollectionsTableTable _collectionIdTable(_$AppDatabase db) => db
      .collectionsTable
      .createAlias('sync_cursors__collection_id__collections__id');

  $$CollectionsTableTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<String>('collection_id')!;

    final manager = $$CollectionsTableTableTableManager(
      $_db,
      $_db.collectionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SyncCursorsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncCursorsTableTable> {
  $$SyncCursorsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CollectionsTableTableFilterComposer get collectionId {
    final $$CollectionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collectionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableTableFilterComposer(
            $db: $db,
            $table: $db.collectionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncCursorsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncCursorsTableTable> {
  $$SyncCursorsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CollectionsTableTableOrderingComposer get collectionId {
    final $$CollectionsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collectionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableTableOrderingComposer(
            $db: $db,
            $table: $db.collectionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncCursorsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncCursorsTableTable> {
  $$SyncCursorsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  $$CollectionsTableTableAnnotationComposer get collectionId {
    final $$CollectionsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collectionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.collectionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncCursorsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncCursorsTableTable,
          SyncCursorData,
          $$SyncCursorsTableTableFilterComposer,
          $$SyncCursorsTableTableOrderingComposer,
          $$SyncCursorsTableTableAnnotationComposer,
          $$SyncCursorsTableTableCreateCompanionBuilder,
          $$SyncCursorsTableTableUpdateCompanionBuilder,
          (SyncCursorData, $$SyncCursorsTableTableReferences),
          SyncCursorData,
          PrefetchHooks Function({bool collectionId})
        > {
  $$SyncCursorsTableTableTableManager(
    _$AppDatabase db,
    $SyncCursorsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncCursorsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncCursorsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncCursorsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<String> collectionId = const Value.absent(),
                Value<DateTime> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsTableCompanion(
                deviceId: deviceId,
                collectionId: collectionId,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required String collectionId,
                required DateTime lastSyncedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsTableCompanion.insert(
                deviceId: deviceId,
                collectionId: collectionId,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SyncCursorsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({collectionId = false}) {
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
                    if (collectionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.collectionId,
                                referencedTable:
                                    $$SyncCursorsTableTableReferences
                                        ._collectionIdTable(db),
                                referencedColumn:
                                    $$SyncCursorsTableTableReferences
                                        ._collectionIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$SyncCursorsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncCursorsTableTable,
      SyncCursorData,
      $$SyncCursorsTableTableFilterComposer,
      $$SyncCursorsTableTableOrderingComposer,
      $$SyncCursorsTableTableAnnotationComposer,
      $$SyncCursorsTableTableCreateCompanionBuilder,
      $$SyncCursorsTableTableUpdateCompanionBuilder,
      (SyncCursorData, $$SyncCursorsTableTableReferences),
      SyncCursorData,
      PrefetchHooks Function({bool collectionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $CarsFtsTableManager get carsFts => $CarsFtsTableManager(_db, _db.carsFts);
  $$CollectionsTableTableTableManager get collectionsTable =>
      $$CollectionsTableTableTableManager(_db, _db.collectionsTable);
  $$CarsTableTableTableManager get carsTable =>
      $$CarsTableTableTableManager(_db, _db.carsTable);
  $$CarImagesTableTableTableManager get carImagesTable =>
      $$CarImagesTableTableTableManager(_db, _db.carImagesTable);
  $$KeywordsTableTableTableManager get keywordsTable =>
      $$KeywordsTableTableTableManager(_db, _db.keywordsTable);
  $$CarKeywordsTableTableTableManager get carKeywordsTable =>
      $$CarKeywordsTableTableTableManager(_db, _db.carKeywordsTable);
  $$SyncCursorsTableTableTableManager get syncCursorsTable =>
      $$SyncCursorsTableTableTableManager(_db, _db.syncCursorsTable);
}
