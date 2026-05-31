// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderTimeMeta = const VerificationMeta(
    'reminderTime',
  );
  @override
  late final GeneratedColumn<String> reminderTime = GeneratedColumn<String>(
    'reminder_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gracePerWeekMeta = const VerificationMeta(
    'gracePerWeek',
  );
  @override
  late final GeneratedColumn<int> gracePerWeek = GeneratedColumn<int>(
    'grace_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
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
  static const VerificationMeta _totalCheckInCountMeta = const VerificationMeta(
    'totalCheckInCount',
  );
  @override
  late final GeneratedColumn<int> totalCheckInCount = GeneratedColumn<int>(
    'total_check_in_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bestStreakMeta = const VerificationMeta(
    'bestStreak',
  );
  @override
  late final GeneratedColumn<int> bestStreak = GeneratedColumn<int>(
    'best_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icon,
    color,
    reminderEnabled,
    reminderTime,
    gracePerWeek,
    status,
    sortOrder,
    totalCheckInCount,
    bestStreak,
    currentStreak,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
        _reminderTimeMeta,
        reminderTime.isAcceptableOrUnknown(
          data['reminder_time']!,
          _reminderTimeMeta,
        ),
      );
    }
    if (data.containsKey('grace_per_week')) {
      context.handle(
        _gracePerWeekMeta,
        gracePerWeek.isAcceptableOrUnknown(
          data['grace_per_week']!,
          _gracePerWeekMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('total_check_in_count')) {
      context.handle(
        _totalCheckInCountMeta,
        totalCheckInCount.isAcceptableOrUnknown(
          data['total_check_in_count']!,
          _totalCheckInCountMeta,
        ),
      );
    }
    if (data.containsKey('best_streak')) {
      context.handle(
        _bestStreakMeta,
        bestStreak.isAcceptableOrUnknown(data['best_streak']!, _bestStreakMeta),
      );
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      reminderTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_time'],
      ),
      gracePerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grace_per_week'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      totalCheckInCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_check_in_count'],
      )!,
      bestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_streak'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
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
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final String id;
  final String name;
  final String? icon;
  final String color;
  final bool reminderEnabled;
  final String? reminderTime;
  final int gracePerWeek;
  final String status;
  final int sortOrder;
  final int totalCheckInCount;
  final int bestStreak;
  final int currentStreak;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Habit({
    required this.id,
    required this.name,
    this.icon,
    required this.color,
    required this.reminderEnabled,
    this.reminderTime,
    required this.gracePerWeek,
    required this.status,
    required this.sortOrder,
    required this.totalCheckInCount,
    required this.bestStreak,
    required this.currentStreak,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['color'] = Variable<String>(color);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<String>(reminderTime);
    }
    map['grace_per_week'] = Variable<int>(gracePerWeek);
    map['status'] = Variable<String>(status);
    map['sort_order'] = Variable<int>(sortOrder);
    map['total_check_in_count'] = Variable<int>(totalCheckInCount);
    map['best_streak'] = Variable<int>(bestStreak);
    map['current_streak'] = Variable<int>(currentStreak);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color: Value(color),
      reminderEnabled: Value(reminderEnabled),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      gracePerWeek: Value(gracePerWeek),
      status: Value(status),
      sortOrder: Value(sortOrder),
      totalCheckInCount: Value(totalCheckInCount),
      bestStreak: Value(bestStreak),
      currentStreak: Value(currentStreak),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String>(json['color']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderTime: serializer.fromJson<String?>(json['reminderTime']),
      gracePerWeek: serializer.fromJson<int>(json['gracePerWeek']),
      status: serializer.fromJson<String>(json['status']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      totalCheckInCount: serializer.fromJson<int>(json['totalCheckInCount']),
      bestStreak: serializer.fromJson<int>(json['bestStreak']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String>(color),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderTime': serializer.toJson<String?>(reminderTime),
      'gracePerWeek': serializer.toJson<int>(gracePerWeek),
      'status': serializer.toJson<String>(status),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'totalCheckInCount': serializer.toJson<int>(totalCheckInCount),
      'bestStreak': serializer.toJson<int>(bestStreak),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Habit copyWith({
    String? id,
    String? name,
    Value<String?> icon = const Value.absent(),
    String? color,
    bool? reminderEnabled,
    Value<String?> reminderTime = const Value.absent(),
    int? gracePerWeek,
    String? status,
    int? sortOrder,
    int? totalCheckInCount,
    int? bestStreak,
    int? currentStreak,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Habit(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon.present ? icon.value : this.icon,
    color: color ?? this.color,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderTime: reminderTime.present ? reminderTime.value : this.reminderTime,
    gracePerWeek: gracePerWeek ?? this.gracePerWeek,
    status: status ?? this.status,
    sortOrder: sortOrder ?? this.sortOrder,
    totalCheckInCount: totalCheckInCount ?? this.totalCheckInCount,
    bestStreak: bestStreak ?? this.bestStreak,
    currentStreak: currentStreak ?? this.currentStreak,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      gracePerWeek: data.gracePerWeek.present
          ? data.gracePerWeek.value
          : this.gracePerWeek,
      status: data.status.present ? data.status.value : this.status,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      totalCheckInCount: data.totalCheckInCount.present
          ? data.totalCheckInCount.value
          : this.totalCheckInCount,
      bestStreak: data.bestStreak.present
          ? data.bestStreak.value
          : this.bestStreak,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('gracePerWeek: $gracePerWeek, ')
          ..write('status: $status, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('totalCheckInCount: $totalCheckInCount, ')
          ..write('bestStreak: $bestStreak, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    icon,
    color,
    reminderEnabled,
    reminderTime,
    gracePerWeek,
    status,
    sortOrder,
    totalCheckInCount,
    bestStreak,
    currentStreak,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderTime == this.reminderTime &&
          other.gracePerWeek == this.gracePerWeek &&
          other.status == this.status &&
          other.sortOrder == this.sortOrder &&
          other.totalCheckInCount == this.totalCheckInCount &&
          other.bestStreak == this.bestStreak &&
          other.currentStreak == this.currentStreak &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<String> color;
  final Value<bool> reminderEnabled;
  final Value<String?> reminderTime;
  final Value<int> gracePerWeek;
  final Value<String> status;
  final Value<int> sortOrder;
  final Value<int> totalCheckInCount;
  final Value<int> bestStreak;
  final Value<int> currentStreak;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.gracePerWeek = const Value.absent(),
    this.status = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.totalCheckInCount = const Value.absent(),
    this.bestStreak = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String name,
    this.icon = const Value.absent(),
    required String color,
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.gracePerWeek = const Value.absent(),
    this.status = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.totalCheckInCount = const Value.absent(),
    this.bestStreak = const Value.absent(),
    this.currentStreak = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       color = Value(color),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Habit> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<bool>? reminderEnabled,
    Expression<String>? reminderTime,
    Expression<int>? gracePerWeek,
    Expression<String>? status,
    Expression<int>? sortOrder,
    Expression<int>? totalCheckInCount,
    Expression<int>? bestStreak,
    Expression<int>? currentStreak,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (gracePerWeek != null) 'grace_per_week': gracePerWeek,
      if (status != null) 'status': status,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (totalCheckInCount != null) 'total_check_in_count': totalCheckInCount,
      if (bestStreak != null) 'best_streak': bestStreak,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? icon,
    Value<String>? color,
    Value<bool>? reminderEnabled,
    Value<String?>? reminderTime,
    Value<int>? gracePerWeek,
    Value<String>? status,
    Value<int>? sortOrder,
    Value<int>? totalCheckInCount,
    Value<int>? bestStreak,
    Value<int>? currentStreak,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      gracePerWeek: gracePerWeek ?? this.gracePerWeek,
      status: status ?? this.status,
      sortOrder: sortOrder ?? this.sortOrder,
      totalCheckInCount: totalCheckInCount ?? this.totalCheckInCount,
      bestStreak: bestStreak ?? this.bestStreak,
      currentStreak: currentStreak ?? this.currentStreak,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<String>(reminderTime.value);
    }
    if (gracePerWeek.present) {
      map['grace_per_week'] = Variable<int>(gracePerWeek.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (totalCheckInCount.present) {
      map['total_check_in_count'] = Variable<int>(totalCheckInCount.value);
    }
    if (bestStreak.present) {
      map['best_streak'] = Variable<int>(bestStreak.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('gracePerWeek: $gracePerWeek, ')
          ..write('status: $status, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('totalCheckInCount: $totalCheckInCount, ')
          ..write('bestStreak: $bestStreak, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckInRecordsTable extends CheckInRecords
    with TableInfo<$CheckInRecordsTable, CheckInRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckInRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkInDateMeta = const VerificationMeta(
    'checkInDate',
  );
  @override
  late final GeneratedColumn<String> checkInDate = GeneratedColumn<String>(
    'check_in_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
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
    habitId,
    checkInDate,
    source,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'check_in_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<CheckInRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('check_in_date')) {
      context.handle(
        _checkInDateMeta,
        checkInDate.isAcceptableOrUnknown(
          data['check_in_date']!,
          _checkInDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checkInDateMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {habitId, checkInDate},
  ];
  @override
  CheckInRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckInRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      checkInDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_in_date'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CheckInRecordsTable createAlias(String alias) {
    return $CheckInRecordsTable(attachedDatabase, alias);
  }
}

class CheckInRecord extends DataClass implements Insertable<CheckInRecord> {
  final String id;
  final String habitId;
  final String checkInDate;
  final String source;
  final DateTime createdAt;
  const CheckInRecord({
    required this.id,
    required this.habitId,
    required this.checkInDate,
    required this.source,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['check_in_date'] = Variable<String>(checkInDate);
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CheckInRecordsCompanion toCompanion(bool nullToAbsent) {
    return CheckInRecordsCompanion(
      id: Value(id),
      habitId: Value(habitId),
      checkInDate: Value(checkInDate),
      source: Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory CheckInRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckInRecord(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      checkInDate: serializer.fromJson<String>(json['checkInDate']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'checkInDate': serializer.toJson<String>(checkInDate),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CheckInRecord copyWith({
    String? id,
    String? habitId,
    String? checkInDate,
    String? source,
    DateTime? createdAt,
  }) => CheckInRecord(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    checkInDate: checkInDate ?? this.checkInDate,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
  );
  CheckInRecord copyWithCompanion(CheckInRecordsCompanion data) {
    return CheckInRecord(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      checkInDate: data.checkInDate.present
          ? data.checkInDate.value
          : this.checkInDate,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckInRecord(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('checkInDate: $checkInDate, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, checkInDate, source, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckInRecord &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.checkInDate == this.checkInDate &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class CheckInRecordsCompanion extends UpdateCompanion<CheckInRecord> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<String> checkInDate;
  final Value<String> source;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CheckInRecordsCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.checkInDate = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckInRecordsCompanion.insert({
    required String id,
    required String habitId,
    required String checkInDate,
    required String source,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       habitId = Value(habitId),
       checkInDate = Value(checkInDate),
       source = Value(source),
       createdAt = Value(createdAt);
  static Insertable<CheckInRecord> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<String>? checkInDate,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (checkInDate != null) 'check_in_date': checkInDate,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckInRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? habitId,
    Value<String>? checkInDate,
    Value<String>? source,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CheckInRecordsCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      checkInDate: checkInDate ?? this.checkInDate,
      source: source ?? this.source,
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
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (checkInDate.present) {
      map['check_in_date'] = Variable<String>(checkInDate.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
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
    return (StringBuffer('CheckInRecordsCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('checkInDate: $checkInDate, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitPausePeriodsTable extends HabitPausePeriods
    with TableInfo<$HabitPausePeriodsTable, HabitPausePeriod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitPausePeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    habitId,
    startDate,
    endDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_pause_periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitPausePeriod> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitPausePeriod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitPausePeriod(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HabitPausePeriodsTable createAlias(String alias) {
    return $HabitPausePeriodsTable(attachedDatabase, alias);
  }
}

class HabitPausePeriod extends DataClass
    implements Insertable<HabitPausePeriod> {
  final String id;
  final String habitId;
  final String startDate;
  final String? endDate;
  final DateTime createdAt;
  const HabitPausePeriod({
    required this.id,
    required this.habitId,
    required this.startDate,
    this.endDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['start_date'] = Variable<String>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HabitPausePeriodsCompanion toCompanion(bool nullToAbsent) {
    return HabitPausePeriodsCompanion(
      id: Value(id),
      habitId: Value(habitId),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      createdAt: Value(createdAt),
    );
  }

  factory HabitPausePeriod.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitPausePeriod(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HabitPausePeriod copyWith({
    String? id,
    String? habitId,
    String? startDate,
    Value<String?> endDate = const Value.absent(),
    DateTime? createdAt,
  }) => HabitPausePeriod(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    createdAt: createdAt ?? this.createdAt,
  );
  HabitPausePeriod copyWithCompanion(HabitPausePeriodsCompanion data) {
    return HabitPausePeriod(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitPausePeriod(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, startDate, endDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitPausePeriod &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.createdAt == this.createdAt);
}

class HabitPausePeriodsCompanion extends UpdateCompanion<HabitPausePeriod> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<String> startDate;
  final Value<String?> endDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HabitPausePeriodsCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitPausePeriodsCompanion.insert({
    required String id,
    required String habitId,
    required String startDate,
    this.endDate = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       habitId = Value(habitId),
       startDate = Value(startDate),
       createdAt = Value(createdAt);
  static Insertable<HabitPausePeriod> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitPausePeriodsCompanion copyWith({
    Value<String>? id,
    Value<String>? habitId,
    Value<String>? startDate,
    Value<String?>? endDate,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return HabitPausePeriodsCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
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
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
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
    return (StringBuffer('HabitPausePeriodsCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $CheckInRecordsTable checkInRecords = $CheckInRecordsTable(this);
  late final $HabitPausePeriodsTable habitPausePeriods =
      $HabitPausePeriodsTable(this);
  late final HabitDao habitDao = HabitDao(this as AppDatabase);
  late final CheckInDao checkInDao = CheckInDao(this as AppDatabase);
  late final PausePeriodDao pausePeriodDao = PausePeriodDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    habits,
    checkInRecords,
    habitPausePeriods,
  ];
}

typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      required String id,
      required String name,
      Value<String?> icon,
      required String color,
      Value<bool> reminderEnabled,
      Value<String?> reminderTime,
      Value<int> gracePerWeek,
      Value<String> status,
      Value<int> sortOrder,
      Value<int> totalCheckInCount,
      Value<int> bestStreak,
      Value<int> currentStreak,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> icon,
      Value<String> color,
      Value<bool> reminderEnabled,
      Value<String?> reminderTime,
      Value<int> gracePerWeek,
      Value<String> status,
      Value<int> sortOrder,
      Value<int> totalCheckInCount,
      Value<int> bestStreak,
      Value<int> currentStreak,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gracePerWeek => $composableBuilder(
    column: $table.gracePerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCheckInCount => $composableBuilder(
    column: $table.totalCheckInCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
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
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gracePerWeek => $composableBuilder(
    column: $table.gracePerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCheckInCount => $composableBuilder(
    column: $table.totalCheckInCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
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
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gracePerWeek => $composableBuilder(
    column: $table.gracePerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get totalCheckInCount => $composableBuilder(
    column: $table.totalCheckInCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
          Habit,
          PrefetchHooks Function()
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<String?> reminderTime = const Value.absent(),
                Value<int> gracePerWeek = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> totalCheckInCount = const Value.absent(),
                Value<int> bestStreak = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                name: name,
                icon: icon,
                color: color,
                reminderEnabled: reminderEnabled,
                reminderTime: reminderTime,
                gracePerWeek: gracePerWeek,
                status: status,
                sortOrder: sortOrder,
                totalCheckInCount: totalCheckInCount,
                bestStreak: bestStreak,
                currentStreak: currentStreak,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> icon = const Value.absent(),
                required String color,
                Value<bool> reminderEnabled = const Value.absent(),
                Value<String?> reminderTime = const Value.absent(),
                Value<int> gracePerWeek = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> totalCheckInCount = const Value.absent(),
                Value<int> bestStreak = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                color: color,
                reminderEnabled: reminderEnabled,
                reminderTime: reminderTime,
                gracePerWeek: gracePerWeek,
                status: status,
                sortOrder: sortOrder,
                totalCheckInCount: totalCheckInCount,
                bestStreak: bestStreak,
                currentStreak: currentStreak,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
      Habit,
      PrefetchHooks Function()
    >;
typedef $$CheckInRecordsTableCreateCompanionBuilder =
    CheckInRecordsCompanion Function({
      required String id,
      required String habitId,
      required String checkInDate,
      required String source,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CheckInRecordsTableUpdateCompanionBuilder =
    CheckInRecordsCompanion Function({
      Value<String> id,
      Value<String> habitId,
      Value<String> checkInDate,
      Value<String> source,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CheckInRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckInRecordsTable> {
  $$CheckInRecordsTableFilterComposer({
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

  ColumnFilters<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkInDate => $composableBuilder(
    column: $table.checkInDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CheckInRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckInRecordsTable> {
  $$CheckInRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkInDate => $composableBuilder(
    column: $table.checkInDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CheckInRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckInRecordsTable> {
  $$CheckInRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get habitId =>
      $composableBuilder(column: $table.habitId, builder: (column) => column);

  GeneratedColumn<String> get checkInDate => $composableBuilder(
    column: $table.checkInDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CheckInRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckInRecordsTable,
          CheckInRecord,
          $$CheckInRecordsTableFilterComposer,
          $$CheckInRecordsTableOrderingComposer,
          $$CheckInRecordsTableAnnotationComposer,
          $$CheckInRecordsTableCreateCompanionBuilder,
          $$CheckInRecordsTableUpdateCompanionBuilder,
          (
            CheckInRecord,
            BaseReferences<_$AppDatabase, $CheckInRecordsTable, CheckInRecord>,
          ),
          CheckInRecord,
          PrefetchHooks Function()
        > {
  $$CheckInRecordsTableTableManager(
    _$AppDatabase db,
    $CheckInRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckInRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckInRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckInRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<String> checkInDate = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckInRecordsCompanion(
                id: id,
                habitId: habitId,
                checkInDate: checkInDate,
                source: source,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String habitId,
                required String checkInDate,
                required String source,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CheckInRecordsCompanion.insert(
                id: id,
                habitId: habitId,
                checkInDate: checkInDate,
                source: source,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CheckInRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckInRecordsTable,
      CheckInRecord,
      $$CheckInRecordsTableFilterComposer,
      $$CheckInRecordsTableOrderingComposer,
      $$CheckInRecordsTableAnnotationComposer,
      $$CheckInRecordsTableCreateCompanionBuilder,
      $$CheckInRecordsTableUpdateCompanionBuilder,
      (
        CheckInRecord,
        BaseReferences<_$AppDatabase, $CheckInRecordsTable, CheckInRecord>,
      ),
      CheckInRecord,
      PrefetchHooks Function()
    >;
typedef $$HabitPausePeriodsTableCreateCompanionBuilder =
    HabitPausePeriodsCompanion Function({
      required String id,
      required String habitId,
      required String startDate,
      Value<String?> endDate,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$HabitPausePeriodsTableUpdateCompanionBuilder =
    HabitPausePeriodsCompanion Function({
      Value<String> id,
      Value<String> habitId,
      Value<String> startDate,
      Value<String?> endDate,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$HabitPausePeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitPausePeriodsTable> {
  $$HabitPausePeriodsTableFilterComposer({
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

  ColumnFilters<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitPausePeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitPausePeriodsTable> {
  $$HabitPausePeriodsTableOrderingComposer({
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

  ColumnOrderings<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitPausePeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitPausePeriodsTable> {
  $$HabitPausePeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get habitId =>
      $composableBuilder(column: $table.habitId, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HabitPausePeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitPausePeriodsTable,
          HabitPausePeriod,
          $$HabitPausePeriodsTableFilterComposer,
          $$HabitPausePeriodsTableOrderingComposer,
          $$HabitPausePeriodsTableAnnotationComposer,
          $$HabitPausePeriodsTableCreateCompanionBuilder,
          $$HabitPausePeriodsTableUpdateCompanionBuilder,
          (
            HabitPausePeriod,
            BaseReferences<
              _$AppDatabase,
              $HabitPausePeriodsTable,
              HabitPausePeriod
            >,
          ),
          HabitPausePeriod,
          PrefetchHooks Function()
        > {
  $$HabitPausePeriodsTableTableManager(
    _$AppDatabase db,
    $HabitPausePeriodsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitPausePeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitPausePeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitPausePeriodsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitPausePeriodsCompanion(
                id: id,
                habitId: habitId,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String habitId,
                required String startDate,
                Value<String?> endDate = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => HabitPausePeriodsCompanion.insert(
                id: id,
                habitId: habitId,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitPausePeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitPausePeriodsTable,
      HabitPausePeriod,
      $$HabitPausePeriodsTableFilterComposer,
      $$HabitPausePeriodsTableOrderingComposer,
      $$HabitPausePeriodsTableAnnotationComposer,
      $$HabitPausePeriodsTableCreateCompanionBuilder,
      $$HabitPausePeriodsTableUpdateCompanionBuilder,
      (
        HabitPausePeriod,
        BaseReferences<
          _$AppDatabase,
          $HabitPausePeriodsTable,
          HabitPausePeriod
        >,
      ),
      HabitPausePeriod,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$CheckInRecordsTableTableManager get checkInRecords =>
      $$CheckInRecordsTableTableManager(_db, _db.checkInRecords);
  $$HabitPausePeriodsTableTableManager get habitPausePeriods =>
      $$HabitPausePeriodsTableTableManager(_db, _db.habitPausePeriods);
}

mixin _$HabitDaoMixin on DatabaseAccessor<AppDatabase> {
  $HabitsTable get habits => attachedDatabase.habits;
  HabitDaoManager get managers => HabitDaoManager(this);
}

class HabitDaoManager {
  final _$HabitDaoMixin _db;
  HabitDaoManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db.attachedDatabase, _db.habits);
}

mixin _$CheckInDaoMixin on DatabaseAccessor<AppDatabase> {
  $CheckInRecordsTable get checkInRecords => attachedDatabase.checkInRecords;
  CheckInDaoManager get managers => CheckInDaoManager(this);
}

class CheckInDaoManager {
  final _$CheckInDaoMixin _db;
  CheckInDaoManager(this._db);
  $$CheckInRecordsTableTableManager get checkInRecords =>
      $$CheckInRecordsTableTableManager(
        _db.attachedDatabase,
        _db.checkInRecords,
      );
}

mixin _$PausePeriodDaoMixin on DatabaseAccessor<AppDatabase> {
  $HabitPausePeriodsTable get habitPausePeriods =>
      attachedDatabase.habitPausePeriods;
  PausePeriodDaoManager get managers => PausePeriodDaoManager(this);
}

class PausePeriodDaoManager {
  final _$PausePeriodDaoMixin _db;
  PausePeriodDaoManager(this._db);
  $$HabitPausePeriodsTableTableManager get habitPausePeriods =>
      $$HabitPausePeriodsTableTableManager(
        _db.attachedDatabase,
        _db.habitPausePeriods,
      );
}
