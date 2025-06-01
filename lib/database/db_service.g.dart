// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_service.dart';

// ignore_for_file: type=lint
class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueDateTimeMeta =
      const VerificationMeta('dueDateTime');
  @override
  late final GeneratedColumn<DateTime> dueDateTime = GeneratedColumn<DateTime>(
      'dueDateTime', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
      'isDone', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("isDone" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isReclaimedMeta =
      const VerificationMeta('isReclaimed');
  @override
  late final GeneratedColumn<bool> isReclaimed = GeneratedColumn<bool>(
      'isReclaimed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("isReclaimed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, description, dueDateTime, priority, isDone, isReclaimed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'Tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('dueDateTime')) {
      context.handle(
          _dueDateTimeMeta,
          dueDateTime.isAcceptableOrUnknown(
              data['dueDateTime']!, _dueDateTimeMeta));
    } else if (isInserting) {
      context.missing(_dueDateTimeMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('isDone')) {
      context.handle(_isDoneMeta,
          isDone.isAcceptableOrUnknown(data['isDone']!, _isDoneMeta));
    }
    if (data.containsKey('isReclaimed')) {
      context.handle(
          _isReclaimedMeta,
          isReclaimed.isAcceptableOrUnknown(
              data['isReclaimed']!, _isReclaimedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      dueDateTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}dueDateTime'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      isDone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}isDone'])!,
      isReclaimed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}isReclaimed'])!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  int id;
  String title;
  String? description;
  DateTime dueDateTime;
  int priority;
  bool isDone;
  bool isReclaimed;
  Task(
      {required this.id,
      required this.title,
      this.description,
      required this.dueDateTime,
      required this.priority,
      required this.isDone,
      required this.isReclaimed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['dueDateTime'] = Variable<DateTime>(dueDateTime);
    map['priority'] = Variable<int>(priority);
    map['isDone'] = Variable<bool>(isDone);
    map['isReclaimed'] = Variable<bool>(isReclaimed);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueDateTime: Value(dueDateTime),
      priority: Value(priority),
      isDone: Value(isDone),
      isReclaimed: Value(isReclaimed),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueDateTime: serializer.fromJson<DateTime>(json['dueDateTime']),
      priority: serializer.fromJson<int>(json['priority']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      isReclaimed: serializer.fromJson<bool>(json['isReclaimed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueDateTime': serializer.toJson<DateTime>(dueDateTime),
      'priority': serializer.toJson<int>(priority),
      'isDone': serializer.toJson<bool>(isDone),
      'isReclaimed': serializer.toJson<bool>(isReclaimed),
    };
  }

  Task copyWith(
          {int? id,
          String? title,
          Value<String?> description = const Value.absent(),
          DateTime? dueDateTime,
          int? priority,
          bool? isDone,
          bool? isReclaimed}) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        dueDateTime: dueDateTime ?? this.dueDateTime,
        priority: priority ?? this.priority,
        isDone: isDone ?? this.isDone,
        isReclaimed: isReclaimed ?? this.isReclaimed,
      );
  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDateTime: $dueDateTime, ')
          ..write('priority: $priority, ')
          ..write('isDone: $isDone, ')
          ..write('isReclaimed: $isReclaimed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, description, dueDateTime, priority, isDone, isReclaimed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDateTime == this.dueDateTime &&
          other.priority == this.priority &&
          other.isDone == this.isDone &&
          other.isReclaimed == this.isReclaimed);
}

class TasksCompanion extends UpdateCompanion<Task> {
  Value<int> id;
  Value<String> title;
  Value<String?> description;
  Value<DateTime> dueDateTime;
  Value<int> priority;
  Value<bool> isDone;
  Value<bool> isReclaimed;
  TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDateTime = const Value.absent(),
    this.priority = const Value.absent(),
    this.isDone = const Value.absent(),
    this.isReclaimed = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required DateTime dueDateTime,
    required int priority,
    this.isDone = const Value.absent(),
    this.isReclaimed = const Value.absent(),
  })  : title = Value(title),
        dueDateTime = Value(dueDateTime),
        priority = Value(priority);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueDateTime,
    Expression<int>? priority,
    Expression<bool>? isDone,
    Expression<bool>? isReclaimed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDateTime != null) 'dueDateTime': dueDateTime,
      if (priority != null) 'priority': priority,
      if (isDone != null) 'isDone': isDone,
      if (isReclaimed != null) 'isReclaimed': isReclaimed,
    });
  }

  TasksCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime>? dueDateTime,
      Value<int>? priority,
      Value<bool>? isDone,
      Value<bool>? isReclaimed}) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDateTime: dueDateTime ?? this.dueDateTime,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
      isReclaimed: isReclaimed ?? this.isReclaimed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDateTime.present) {
      map['dueDateTime'] = Variable<DateTime>(dueDateTime.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (isDone.present) {
      map['isDone'] = Variable<bool>(isDone.value);
    }
    if (isReclaimed.present) {
      map['isReclaimed'] = Variable<bool>(isReclaimed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDateTime: $dueDateTime, ')
          ..write('priority: $priority, ')
          ..write('isDone: $isDone, ')
          ..write('isReclaimed: $isReclaimed')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isGoodMeta = const VerificationMeta('isGood');
  @override
  late final GeneratedColumn<bool> isGood = GeneratedColumn<bool>(
      'isGood', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("isGood" IN (0, 1))'));
  static const VerificationMeta _lastDateTimeMeta =
      const VerificationMeta('lastDateTime');
  @override
  late final GeneratedColumn<DateTime> lastDateTime = GeneratedColumn<DateTime>(
      'lastDateTime', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _counterMeta =
      const VerificationMeta('counter');
  @override
  late final GeneratedColumn<int> counter = GeneratedColumn<int>(
      'counter', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, description, isGood, lastDateTime, counter];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'Habits';
  @override
  VerificationContext validateIntegrity(Insertable<Habit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('isGood')) {
      context.handle(_isGoodMeta,
          isGood.isAcceptableOrUnknown(data['isGood']!, _isGoodMeta));
    } else if (isInserting) {
      context.missing(_isGoodMeta);
    }
    if (data.containsKey('lastDateTime')) {
      context.handle(
          _lastDateTimeMeta,
          lastDateTime.isAcceptableOrUnknown(
              data['lastDateTime']!, _lastDateTimeMeta));
    }
    if (data.containsKey('counter')) {
      context.handle(_counterMeta,
          counter.isAcceptableOrUnknown(data['counter']!, _counterMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      isGood: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}isGood'])!,
      lastDateTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}lastDateTime']),
      counter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}counter'])!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  int id;
  String title;
  String description;
  bool isGood;
  DateTime? lastDateTime;
  int counter;
  Habit(
      {required this.id,
      required this.title,
      required this.description,
      required this.isGood,
      this.lastDateTime,
      required this.counter});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['isGood'] = Variable<bool>(isGood);
    if (!nullToAbsent || lastDateTime != null) {
      map['lastDateTime'] = Variable<DateTime>(lastDateTime);
    }
    map['counter'] = Variable<int>(counter);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      isGood: Value(isGood),
      lastDateTime: lastDateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDateTime),
      counter: Value(counter),
    );
  }

  factory Habit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      isGood: serializer.fromJson<bool>(json['isGood']),
      lastDateTime: serializer.fromJson<DateTime?>(json['lastDateTime']),
      counter: serializer.fromJson<int>(json['counter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'isGood': serializer.toJson<bool>(isGood),
      'lastDateTime': serializer.toJson<DateTime?>(lastDateTime),
      'counter': serializer.toJson<int>(counter),
    };
  }

  Habit copyWith(
          {int? id,
          String? title,
          String? description,
          bool? isGood,
          Value<DateTime?> lastDateTime = const Value.absent(),
          int? counter}) =>
      Habit(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isGood: isGood ?? this.isGood,
        lastDateTime:
            lastDateTime.present ? lastDateTime.value : this.lastDateTime,
        counter: counter ?? this.counter,
      );
  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isGood: $isGood, ')
          ..write('lastDateTime: $lastDateTime, ')
          ..write('counter: $counter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, isGood, lastDateTime, counter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.isGood == this.isGood &&
          other.lastDateTime == this.lastDateTime &&
          other.counter == this.counter);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  Value<int> id;
  Value<String> title;
  Value<String> description;
  Value<bool> isGood;
  Value<DateTime?> lastDateTime;
  Value<int> counter;
  HabitsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.isGood = const Value.absent(),
    this.lastDateTime = const Value.absent(),
    this.counter = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    required bool isGood,
    this.lastDateTime = const Value.absent(),
    this.counter = const Value.absent(),
  })  : title = Value(title),
        description = Value(description),
        isGood = Value(isGood);
  static Insertable<Habit> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<bool>? isGood,
    Expression<DateTime>? lastDateTime,
    Expression<int>? counter,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (isGood != null) 'isGood': isGood,
      if (lastDateTime != null) 'lastDateTime': lastDateTime,
      if (counter != null) 'counter': counter,
    });
  }

  HabitsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? description,
      Value<bool>? isGood,
      Value<DateTime?>? lastDateTime,
      Value<int>? counter}) {
    return HabitsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isGood: isGood ?? this.isGood,
      lastDateTime: lastDateTime ?? this.lastDateTime,
      counter: counter ?? this.counter,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isGood.present) {
      map['isGood'] = Variable<bool>(isGood.value);
    }
    if (lastDateTime.present) {
      map['lastDateTime'] = Variable<DateTime>(lastDateTime.value);
    }
    if (counter.present) {
      map['counter'] = Variable<int>(counter.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isGood: $isGood, ')
          ..write('lastDateTime: $lastDateTime, ')
          ..write('counter: $counter')
          ..write(')'))
        .toString();
  }
}

class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<int> frequency = GeneratedColumn<int>(
      'frequency', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
      'period', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _daysMeta = const VerificationMeta('days');
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String> days =
      GeneratedColumn<String>('days', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<int>>($RoutinesTable.$converterdays);
  static const VerificationMeta _dueDateTimeMeta =
      const VerificationMeta('dueDateTime');
  @override
  late final GeneratedColumn<DateTime> dueDateTime = GeneratedColumn<DateTime>(
      'dueDateTime', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastDueDateTimeMeta =
      const VerificationMeta('lastDueDateTime');
  @override
  late final GeneratedColumn<DateTime> lastDueDateTime =
      GeneratedColumn<DateTime>('lastDueDateTime', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
      'isDone', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("isDone" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        frequency,
        period,
        days,
        dueDateTime,
        lastDueDateTime,
        isDone
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'Routines';
  @override
  VerificationContext validateIntegrity(Insertable<Routine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('period')) {
      context.handle(_periodMeta,
          period.isAcceptableOrUnknown(data['period']!, _periodMeta));
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    context.handle(_daysMeta, const VerificationResult.success());
    if (data.containsKey('dueDateTime')) {
      context.handle(
          _dueDateTimeMeta,
          dueDateTime.isAcceptableOrUnknown(
              data['dueDateTime']!, _dueDateTimeMeta));
    } else if (isInserting) {
      context.missing(_dueDateTimeMeta);
    }
    if (data.containsKey('lastDueDateTime')) {
      context.handle(
          _lastDueDateTimeMeta,
          lastDueDateTime.isAcceptableOrUnknown(
              data['lastDueDateTime']!, _lastDueDateTimeMeta));
    }
    if (data.containsKey('isDone')) {
      context.handle(_isDoneMeta,
          isDone.isAcceptableOrUnknown(data['isDone']!, _isDoneMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}frequency'])!,
      period: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}period'])!,
      days: $RoutinesTable.$converterdays.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}days'])!),
      dueDateTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}dueDateTime'])!,
      lastDueDateTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}lastDueDateTime']),
      isDone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}isDone'])!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<int>, String> $converterdays =
      const IntListConverter();
}

class Routine extends DataClass implements Insertable<Routine> {
  int id;
  String title;
  String description;
  int frequency;
  String period;
  List<int> days;
  DateTime dueDateTime;
  DateTime? lastDueDateTime;
  bool isDone;
  Routine(
      {required this.id,
      required this.title,
      required this.description,
      required this.frequency,
      required this.period,
      required this.days,
      required this.dueDateTime,
      this.lastDueDateTime,
      required this.isDone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['frequency'] = Variable<int>(frequency);
    map['period'] = Variable<String>(period);
    {
      map['days'] = Variable<String>($RoutinesTable.$converterdays.toSql(days));
    }
    map['dueDateTime'] = Variable<DateTime>(dueDateTime);
    if (!nullToAbsent || lastDueDateTime != null) {
      map['lastDueDateTime'] = Variable<DateTime>(lastDueDateTime);
    }
    map['isDone'] = Variable<bool>(isDone);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      frequency: Value(frequency),
      period: Value(period),
      days: Value(days),
      dueDateTime: Value(dueDateTime),
      lastDueDateTime: lastDueDateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDueDateTime),
      isDone: Value(isDone),
    );
  }

  factory Routine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      frequency: serializer.fromJson<int>(json['frequency']),
      period: serializer.fromJson<String>(json['period']),
      days: serializer.fromJson<List<int>>(json['days']),
      dueDateTime: serializer.fromJson<DateTime>(json['dueDateTime']),
      lastDueDateTime: serializer.fromJson<DateTime?>(json['lastDueDateTime']),
      isDone: serializer.fromJson<bool>(json['isDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'frequency': serializer.toJson<int>(frequency),
      'period': serializer.toJson<String>(period),
      'days': serializer.toJson<List<int>>(days),
      'dueDateTime': serializer.toJson<DateTime>(dueDateTime),
      'lastDueDateTime': serializer.toJson<DateTime?>(lastDueDateTime),
      'isDone': serializer.toJson<bool>(isDone),
    };
  }

  Routine copyWith(
          {int? id,
          String? title,
          String? description,
          int? frequency,
          String? period,
          List<int>? days,
          DateTime? dueDateTime,
          Value<DateTime?> lastDueDateTime = const Value.absent(),
          bool? isDone}) =>
      Routine(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        frequency: frequency ?? this.frequency,
        period: period ?? this.period,
        days: days ?? this.days,
        dueDateTime: dueDateTime ?? this.dueDateTime,
        lastDueDateTime: lastDueDateTime.present
            ? lastDueDateTime.value
            : this.lastDueDateTime,
        isDone: isDone ?? this.isDone,
      );
  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('frequency: $frequency, ')
          ..write('period: $period, ')
          ..write('days: $days, ')
          ..write('dueDateTime: $dueDateTime, ')
          ..write('lastDueDateTime: $lastDueDateTime, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, frequency, period,
      days, dueDateTime, lastDueDateTime, isDone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.frequency == this.frequency &&
          other.period == this.period &&
          other.days == this.days &&
          other.dueDateTime == this.dueDateTime &&
          other.lastDueDateTime == this.lastDueDateTime &&
          other.isDone == this.isDone);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  Value<int> id;
  Value<String> title;
  Value<String> description;
  Value<int> frequency;
  Value<String> period;
  Value<List<int>> days;
  Value<DateTime> dueDateTime;
  Value<DateTime?> lastDueDateTime;
  Value<bool> isDone;
  RoutinesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.frequency = const Value.absent(),
    this.period = const Value.absent(),
    this.days = const Value.absent(),
    this.dueDateTime = const Value.absent(),
    this.lastDueDateTime = const Value.absent(),
    this.isDone = const Value.absent(),
  });
  RoutinesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    required int frequency,
    required String period,
    required List<int> days,
    required DateTime dueDateTime,
    this.lastDueDateTime = const Value.absent(),
    this.isDone = const Value.absent(),
  })  : title = Value(title),
        description = Value(description),
        frequency = Value(frequency),
        period = Value(period),
        days = Value(days),
        dueDateTime = Value(dueDateTime);
  static Insertable<Routine> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? frequency,
    Expression<String>? period,
    Expression<String>? days,
    Expression<DateTime>? dueDateTime,
    Expression<DateTime>? lastDueDateTime,
    Expression<bool>? isDone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (frequency != null) 'frequency': frequency,
      if (period != null) 'period': period,
      if (days != null) 'days': days,
      if (dueDateTime != null) 'dueDateTime': dueDateTime,
      if (lastDueDateTime != null) 'lastDueDateTime': lastDueDateTime,
      if (isDone != null) 'isDone': isDone,
    });
  }

  RoutinesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? description,
      Value<int>? frequency,
      Value<String>? period,
      Value<List<int>>? days,
      Value<DateTime>? dueDateTime,
      Value<DateTime?>? lastDueDateTime,
      Value<bool>? isDone}) {
    return RoutinesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      period: period ?? this.period,
      days: days ?? this.days,
      dueDateTime: dueDateTime ?? this.dueDateTime,
      lastDueDateTime: lastDueDateTime ?? this.lastDueDateTime,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(frequency.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (days.present) {
      map['days'] =
          Variable<String>($RoutinesTable.$converterdays.toSql(days.value));
    }
    if (dueDateTime.present) {
      map['dueDateTime'] = Variable<DateTime>(dueDateTime.value);
    }
    if (lastDueDateTime.present) {
      map['lastDueDateTime'] = Variable<DateTime>(lastDueDateTime.value);
    }
    if (isDone.present) {
      map['isDone'] = Variable<bool>(isDone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('frequency: $frequency, ')
          ..write('period: $period, ')
          ..write('days: $days, ')
          ..write('dueDateTime: $dueDateTime, ')
          ..write('lastDueDateTime: $lastDueDateTime, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }
}

class $PlayersTable extends Players with TableInfo<$PlayersTable, Player> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hpMeta = const VerificationMeta('hp');
  @override
  late final GeneratedColumn<int> hp = GeneratedColumn<int>(
      'hp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(100));
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
      'xp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _creditsMeta =
      const VerificationMeta('credits');
  @override
  late final GeneratedColumn<int> credits = GeneratedColumn<int>(
      'credits', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, level, hp, xp, credits];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'Players';
  @override
  VerificationContext validateIntegrity(Insertable<Player> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('hp')) {
      context.handle(_hpMeta, hp.isAcceptableOrUnknown(data['hp']!, _hpMeta));
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('credits')) {
      context.handle(_creditsMeta,
          credits.isAcceptableOrUnknown(data['credits']!, _creditsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Player map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Player(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      hp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hp'])!,
      xp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp'])!,
      credits: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}credits'])!,
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }
}

class Player extends DataClass implements Insertable<Player> {
  int id;
  int level;
  int hp;
  int xp;
  int credits;
  Player(
      {required this.id,
      required this.level,
      required this.hp,
      required this.xp,
      required this.credits});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<int>(level);
    map['hp'] = Variable<int>(hp);
    map['xp'] = Variable<int>(xp);
    map['credits'] = Variable<int>(credits);
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      level: Value(level),
      hp: Value(hp),
      xp: Value(xp),
      credits: Value(credits),
    );
  }

  factory Player.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Player(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<int>(json['level']),
      hp: serializer.fromJson<int>(json['hp']),
      xp: serializer.fromJson<int>(json['xp']),
      credits: serializer.fromJson<int>(json['credits']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<int>(level),
      'hp': serializer.toJson<int>(hp),
      'xp': serializer.toJson<int>(xp),
      'credits': serializer.toJson<int>(credits),
    };
  }

  Player copyWith({int? id, int? level, int? hp, int? xp, int? credits}) =>
      Player(
        id: id ?? this.id,
        level: level ?? this.level,
        hp: hp ?? this.hp,
        xp: xp ?? this.xp,
        credits: credits ?? this.credits,
      );
  @override
  String toString() {
    return (StringBuffer('Player(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('hp: $hp, ')
          ..write('xp: $xp, ')
          ..write('credits: $credits')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, level, hp, xp, credits);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Player &&
          other.id == this.id &&
          other.level == this.level &&
          other.hp == this.hp &&
          other.xp == this.xp &&
          other.credits == this.credits);
}

class PlayersCompanion extends UpdateCompanion<Player> {
  Value<int> id;
  Value<int> level;
  Value<int> hp;
  Value<int> xp;
  Value<int> credits;
  Value<int> rowid;
  PlayersCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.hp = const Value.absent(),
    this.xp = const Value.absent(),
    this.credits = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayersCompanion.insert({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.hp = const Value.absent(),
    this.xp = const Value.absent(),
    this.credits = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<Player> custom({
    Expression<int>? id,
    Expression<int>? level,
    Expression<int>? hp,
    Expression<int>? xp,
    Expression<int>? credits,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (hp != null) 'hp': hp,
      if (xp != null) 'xp': xp,
      if (credits != null) 'credits': credits,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayersCompanion copyWith(
      {Value<int>? id,
      Value<int>? level,
      Value<int>? hp,
      Value<int>? xp,
      Value<int>? credits,
      Value<int>? rowid}) {
    return PlayersCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      hp: hp ?? this.hp,
      xp: xp ?? this.xp,
      credits: credits ?? this.credits,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (hp.present) {
      map['hp'] = Variable<int>(hp.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (credits.present) {
      map['credits'] = Variable<int>(credits.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('hp: $hp, ')
          ..write('xp: $xp, ')
          ..write('credits: $credits, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$DatabaseService extends GeneratedDatabase {
  _$DatabaseService(QueryExecutor e) : super(e);
  _$DatabaseServiceManager get managers => _$DatabaseServiceManager(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final Index taskDueDateTime = Index('task_dueDateTime',
      'CREATE INDEX task_dueDateTime ON Tasks (dueDateTime)');
  late final Index routineDueDateTime = Index('routine_dueDateTime',
      'CREATE INDEX routine_dueDateTime ON Routines (dueDateTime)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [tasks, habits, routines, players, taskDueDateTime, routineDueDateTime];
}

typedef $$TasksTableInsertCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  required String title,
  Value<String?> description,
  required DateTime dueDateTime,
  required int priority,
  Value<bool> isDone,
  Value<bool> isReclaimed,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String?> description,
  Value<DateTime> dueDateTime,
  Value<int> priority,
  Value<bool> isDone,
  Value<bool> isReclaimed,
});

class $$TasksTableTableManager extends RootTableManager<
    _$DatabaseService,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableProcessedTableManager,
    $$TasksTableInsertCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder> {
  $$TasksTableTableManager(_$DatabaseService db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TasksTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TasksTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$TasksTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> dueDateTime = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<bool> isDone = const Value.absent(),
            Value<bool> isReclaimed = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            title: title,
            description: description,
            dueDateTime: dueDateTime,
            priority: priority,
            isDone: isDone,
            isReclaimed: isReclaimed,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<String?> description = const Value.absent(),
            required DateTime dueDateTime,
            required int priority,
            Value<bool> isDone = const Value.absent(),
            Value<bool> isReclaimed = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            title: title,
            description: description,
            dueDateTime: dueDateTime,
            priority: priority,
            isDone: isDone,
            isReclaimed: isReclaimed,
          ),
        ));
}

class $$TasksTableProcessedTableManager extends ProcessedTableManager<
    _$DatabaseService,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableProcessedTableManager,
    $$TasksTableInsertCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder> {
  $$TasksTableProcessedTableManager(super.$state);
}

class $$TasksTableFilterComposer
    extends FilterComposer<_$DatabaseService, $TasksTable> {
  $$TasksTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dueDateTime => $state.composableBuilder(
      column: $state.table.dueDateTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get priority => $state.composableBuilder(
      column: $state.table.priority,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDone => $state.composableBuilder(
      column: $state.table.isDone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isReclaimed => $state.composableBuilder(
      column: $state.table.isReclaimed,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TasksTableOrderingComposer
    extends OrderingComposer<_$DatabaseService, $TasksTable> {
  $$TasksTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dueDateTime => $state.composableBuilder(
      column: $state.table.dueDateTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get priority => $state.composableBuilder(
      column: $state.table.priority,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDone => $state.composableBuilder(
      column: $state.table.isDone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isReclaimed => $state.composableBuilder(
      column: $state.table.isReclaimed,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$HabitsTableInsertCompanionBuilder = HabitsCompanion Function({
  Value<int> id,
  required String title,
  required String description,
  required bool isGood,
  Value<DateTime?> lastDateTime,
  Value<int> counter,
});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> description,
  Value<bool> isGood,
  Value<DateTime?> lastDateTime,
  Value<int> counter,
});

class $$HabitsTableTableManager extends RootTableManager<
    _$DatabaseService,
    $HabitsTable,
    Habit,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableProcessedTableManager,
    $$HabitsTableInsertCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder> {
  $$HabitsTableTableManager(_$DatabaseService db, $HabitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$HabitsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$HabitsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$HabitsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<bool> isGood = const Value.absent(),
            Value<DateTime?> lastDateTime = const Value.absent(),
            Value<int> counter = const Value.absent(),
          }) =>
              HabitsCompanion(
            id: id,
            title: title,
            description: description,
            isGood: isGood,
            lastDateTime: lastDateTime,
            counter: counter,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String description,
            required bool isGood,
            Value<DateTime?> lastDateTime = const Value.absent(),
            Value<int> counter = const Value.absent(),
          }) =>
              HabitsCompanion.insert(
            id: id,
            title: title,
            description: description,
            isGood: isGood,
            lastDateTime: lastDateTime,
            counter: counter,
          ),
        ));
}

class $$HabitsTableProcessedTableManager extends ProcessedTableManager<
    _$DatabaseService,
    $HabitsTable,
    Habit,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableProcessedTableManager,
    $$HabitsTableInsertCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder> {
  $$HabitsTableProcessedTableManager(super.$state);
}

class $$HabitsTableFilterComposer
    extends FilterComposer<_$DatabaseService, $HabitsTable> {
  $$HabitsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isGood => $state.composableBuilder(
      column: $state.table.isGood,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastDateTime => $state.composableBuilder(
      column: $state.table.lastDateTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get counter => $state.composableBuilder(
      column: $state.table.counter,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$HabitsTableOrderingComposer
    extends OrderingComposer<_$DatabaseService, $HabitsTable> {
  $$HabitsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isGood => $state.composableBuilder(
      column: $state.table.isGood,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastDateTime => $state.composableBuilder(
      column: $state.table.lastDateTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get counter => $state.composableBuilder(
      column: $state.table.counter,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$RoutinesTableInsertCompanionBuilder = RoutinesCompanion Function({
  Value<int> id,
  required String title,
  required String description,
  required int frequency,
  required String period,
  required List<int> days,
  required DateTime dueDateTime,
  Value<DateTime?> lastDueDateTime,
  Value<bool> isDone,
});
typedef $$RoutinesTableUpdateCompanionBuilder = RoutinesCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> description,
  Value<int> frequency,
  Value<String> period,
  Value<List<int>> days,
  Value<DateTime> dueDateTime,
  Value<DateTime?> lastDueDateTime,
  Value<bool> isDone,
});

class $$RoutinesTableTableManager extends RootTableManager<
    _$DatabaseService,
    $RoutinesTable,
    Routine,
    $$RoutinesTableFilterComposer,
    $$RoutinesTableOrderingComposer,
    $$RoutinesTableProcessedTableManager,
    $$RoutinesTableInsertCompanionBuilder,
    $$RoutinesTableUpdateCompanionBuilder> {
  $$RoutinesTableTableManager(_$DatabaseService db, $RoutinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$RoutinesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$RoutinesTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$RoutinesTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> frequency = const Value.absent(),
            Value<String> period = const Value.absent(),
            Value<List<int>> days = const Value.absent(),
            Value<DateTime> dueDateTime = const Value.absent(),
            Value<DateTime?> lastDueDateTime = const Value.absent(),
            Value<bool> isDone = const Value.absent(),
          }) =>
              RoutinesCompanion(
            id: id,
            title: title,
            description: description,
            frequency: frequency,
            period: period,
            days: days,
            dueDateTime: dueDateTime,
            lastDueDateTime: lastDueDateTime,
            isDone: isDone,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String description,
            required int frequency,
            required String period,
            required List<int> days,
            required DateTime dueDateTime,
            Value<DateTime?> lastDueDateTime = const Value.absent(),
            Value<bool> isDone = const Value.absent(),
          }) =>
              RoutinesCompanion.insert(
            id: id,
            title: title,
            description: description,
            frequency: frequency,
            period: period,
            days: days,
            dueDateTime: dueDateTime,
            lastDueDateTime: lastDueDateTime,
            isDone: isDone,
          ),
        ));
}

class $$RoutinesTableProcessedTableManager extends ProcessedTableManager<
    _$DatabaseService,
    $RoutinesTable,
    Routine,
    $$RoutinesTableFilterComposer,
    $$RoutinesTableOrderingComposer,
    $$RoutinesTableProcessedTableManager,
    $$RoutinesTableInsertCompanionBuilder,
    $$RoutinesTableUpdateCompanionBuilder> {
  $$RoutinesTableProcessedTableManager(super.$state);
}

class $$RoutinesTableFilterComposer
    extends FilterComposer<_$DatabaseService, $RoutinesTable> {
  $$RoutinesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get frequency => $state.composableBuilder(
      column: $state.table.frequency,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get period => $state.composableBuilder(
      column: $state.table.period,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<List<int>, List<int>, String> get days =>
      $state.composableBuilder(
          column: $state.table.days,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dueDateTime => $state.composableBuilder(
      column: $state.table.dueDateTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastDueDateTime => $state.composableBuilder(
      column: $state.table.lastDueDateTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDone => $state.composableBuilder(
      column: $state.table.isDone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$RoutinesTableOrderingComposer
    extends OrderingComposer<_$DatabaseService, $RoutinesTable> {
  $$RoutinesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get frequency => $state.composableBuilder(
      column: $state.table.frequency,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get period => $state.composableBuilder(
      column: $state.table.period,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get days => $state.composableBuilder(
      column: $state.table.days,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dueDateTime => $state.composableBuilder(
      column: $state.table.dueDateTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastDueDateTime => $state.composableBuilder(
      column: $state.table.lastDueDateTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDone => $state.composableBuilder(
      column: $state.table.isDone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PlayersTableInsertCompanionBuilder = PlayersCompanion Function({
  Value<int> id,
  Value<int> level,
  Value<int> hp,
  Value<int> xp,
  Value<int> credits,
  Value<int> rowid,
});
typedef $$PlayersTableUpdateCompanionBuilder = PlayersCompanion Function({
  Value<int> id,
  Value<int> level,
  Value<int> hp,
  Value<int> xp,
  Value<int> credits,
  Value<int> rowid,
});

class $$PlayersTableTableManager extends RootTableManager<
    _$DatabaseService,
    $PlayersTable,
    Player,
    $$PlayersTableFilterComposer,
    $$PlayersTableOrderingComposer,
    $$PlayersTableProcessedTableManager,
    $$PlayersTableInsertCompanionBuilder,
    $$PlayersTableUpdateCompanionBuilder> {
  $$PlayersTableTableManager(_$DatabaseService db, $PlayersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PlayersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PlayersTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$PlayersTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> hp = const Value.absent(),
            Value<int> xp = const Value.absent(),
            Value<int> credits = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlayersCompanion(
            id: id,
            level: level,
            hp: hp,
            xp: xp,
            credits: credits,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> hp = const Value.absent(),
            Value<int> xp = const Value.absent(),
            Value<int> credits = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlayersCompanion.insert(
            id: id,
            level: level,
            hp: hp,
            xp: xp,
            credits: credits,
            rowid: rowid,
          ),
        ));
}

class $$PlayersTableProcessedTableManager extends ProcessedTableManager<
    _$DatabaseService,
    $PlayersTable,
    Player,
    $$PlayersTableFilterComposer,
    $$PlayersTableOrderingComposer,
    $$PlayersTableProcessedTableManager,
    $$PlayersTableInsertCompanionBuilder,
    $$PlayersTableUpdateCompanionBuilder> {
  $$PlayersTableProcessedTableManager(super.$state);
}

class $$PlayersTableFilterComposer
    extends FilterComposer<_$DatabaseService, $PlayersTable> {
  $$PlayersTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get level => $state.composableBuilder(
      column: $state.table.level,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get hp => $state.composableBuilder(
      column: $state.table.hp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get xp => $state.composableBuilder(
      column: $state.table.xp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get credits => $state.composableBuilder(
      column: $state.table.credits,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PlayersTableOrderingComposer
    extends OrderingComposer<_$DatabaseService, $PlayersTable> {
  $$PlayersTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get level => $state.composableBuilder(
      column: $state.table.level,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get hp => $state.composableBuilder(
      column: $state.table.hp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get xp => $state.composableBuilder(
      column: $state.table.xp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get credits => $state.composableBuilder(
      column: $state.table.credits,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$DatabaseServiceManager {
  final _$DatabaseService _db;
  _$DatabaseServiceManager(this._db);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
}
