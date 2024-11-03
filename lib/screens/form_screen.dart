import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/provider/quest_provider.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/utils/rules.dart';
import 'package:skuld/widgets/alerts.dart';
import 'package:skuld/widgets/form_components.dart';

class FormScreen extends StatefulWidget {
  final Map<QuestType, dynamic>? typeAndQuest;

  const FormScreen({super.key, this.typeAndQuest});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final DatabaseService _db = DatabaseService();
  late final QuestProvider _questProvider;
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late dynamic _quest;
  bool _isEditMode = false;

  QuestType _questType = QuestType.task;
  
  // For all
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // For tasks and routines
  DateTime _dateController = DateTime.now();
  TimeOfDay _timeController = TimeOfDay.now();

  // For tasks
  int _priorityController = 1;

  // For habits
  bool _isGoodController = true;

  // For routines
  final TextEditingController _frequencyController = TextEditingController(text: '1');
  String _periodController = 'd';
  List<int> _daysController = [1];

  @override
  void initState() {
    super.initState();
    _questProvider = Provider.of<QuestProvider>(context, listen: false);
    
    if (widget.typeAndQuest == null) { return; }

    _questType =  widget.typeAndQuest!.entries.first.key;
    _quest = _tryCast(widget.typeAndQuest?.entries.first.value);

    if (_quest == null) { return; }

    _tryLoadQuest();
  }

  dynamic _tryCast(dynamic quest) {
    switch (_questType) {
      case QuestType.task:
        return Functions.tryCast<Task>(quest);
      case QuestType.habit:
        return Functions.tryCast<Habit>(quest);
      case QuestType.routine:
        return Functions.tryCast<Routine>(quest);
      default:
        return null;
    }
  }

  Future<void> _tryLoadQuest() async {
    _isEditMode = true;

    switch (_questType) {
      case QuestType.task:
        setState(() {
          _titleController.text = _quest.title;
          _descriptionController.text = _quest.description;
          _dateController = _quest.dueDateTime;
          _timeController = TimeOfDay.fromDateTime(_quest.dueDateTime);
          _priorityController = _quest.priority;
        }); 
        break;
      case QuestType.habit:
        setState(() {
          _titleController.text = _quest.title;
          _descriptionController.text = _quest.description;
          _isGoodController = _quest.isGood;
        });
        break;
      case QuestType.routine:
        setState(() {
          _titleController.text = _quest.title;
          _descriptionController.text = _quest.description;
          _dateController = _quest.dueDateTime;
          _timeController = TimeOfDay.fromDateTime(_quest.dueDateTime);
          _frequencyController.text = _quest.frequency.toString();
          _periodController = _quest.period;
          _daysController = _quest.days;
        });
        break;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Texts.textTitleForm(_isEditMode, _questType), style: Theme.of(context).textTheme.titleLarge),
        actions: _isEditMode ? [
          IconButton(onPressed: () => Alerts.deletionDialog(context, _deleteQuest), icon: const Icon(Icons.delete_rounded)),
        ] : null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!_isEditMode)
                SegmentedButtonQuest(selectedValue: _questType, segmentsMap: questToLabel, onSelectionChanged: (Set<QuestType> questTypes) => setState(() => _questType = questTypes.first)),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputText(controller: _titleController, label: 'Title', rules: Rules.isNotEmpty),
                    InputText(controller: _descriptionController, label: 'Description', rules: Rules.free, multiLines: true),
                    ..._questForm(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: FilledButton(onPressed: _submitForm, child: Text('Save', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white))),
                    ),
                    if (_questType == QuestType.habit && _isEditMode)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(Texts.textLastTime(_quest.lastDateTime), style: Theme.of(context).textTheme.bodyMedium),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _questForm() {
    switch (_questType) {
      case QuestType.task:
        return [
          IconSelector(icon: Icons.calendar_today_rounded, label: 'Due Date', value: Functions.getDate(_dateController), onPressed: () => _selectDate(context)),
          IconSelector(icon: Icons.access_time_rounded, label: 'Time', value: _timeController.format(context), onPressed: () => _selectTime(context)),
          PriorityDropdown(controller: _priorityController, priorityToLabel: priorityToLabel, priorityToColor: priorityToColor, onChanged: (int? value) => setState(() => _priorityController = value ?? 1)),
        ];
      case QuestType.habit:
        return [SegmentedButtonQuest(selectedValue: _isGoodController, segmentsMap: isGoodToLabel, onSelectionChanged: (Set<bool> questTypes) => setState(() => _isGoodController = questTypes.first))];
      case QuestType.routine:
        return [
          IconSelector(icon: Icons.calendar_today_rounded, label: 'Start Date', value: Functions.getDate(_dateController), onPressed: () => _selectDate(context)),
          IconSelector(icon: Icons.access_time_rounded, label: 'Time', value: _timeController.format(context), onPressed: () => _selectTime(context)),
          FrequencySelector(frequencyController: _frequencyController, periodController: _periodController, daysController: _daysController, periodToLabel: periodToLabel, dayToLabel: dayToLabel, onPeriodChanged: (String? value) => setState(() => _periodController = value ?? 'd'), onFormSaved: (value) => _daysController = value ?? []),
          if (_isEditMode)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: OutlinedButton(onPressed: _endRoutine, child: Text(Texts.textEndRoutine(_quest.isDone), style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.primary))),
            ),
        ];
    }
  }

  Future<void> _selectDate(BuildContext context) async {
      final DateTime? dueDate = await showDatePicker(
        context: context,
        initialDate: _dateController,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (dueDate != null && dueDate != _dateController) {
        setState(() => _dateController = dueDate);
      }
    }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? dueTime = await showTimePicker(
      context: context,
      initialTime: _timeController,
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );

    if (dueTime != null && dueTime != _timeController) {
      setState(() => _timeController = dueTime);
    }
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) { return; }

    _formKey.currentState!.save();

    switch (_questType) {
      case QuestType.task:
        _isEditMode ? await _updateTask() : await _addTask();
        break;
      case QuestType.habit:
        _isEditMode ? await _updateHabit() : await _addHabit();
        break;
      case QuestType.routine:
        _isEditMode ? await _updateRoutine() : await _addRoutine();
        break;
    }
    await _questProvider.refreshData(_questType);

    _formKey.currentState!.reset();
    if (mounted) { Navigator.pop(context); }
  }

  Future<void> _addTask() async {
    final DateTime dueDateTime = DateTime(_dateController.year, _dateController.month, _dateController.day, _timeController.hour, _timeController.minute);

    await _db.insertOrUpdateTask(Task(
      _titleController.text,
      _descriptionController.text,
      dueDateTime,
      _priorityController,
    ));
  }

  Future<void> _updateTask() async {
    final DateTime dueDateTime = DateTime(_dateController.year, _dateController.month, _dateController.day, _timeController.hour, _timeController.minute);
             
    _quest.title = _titleController.text;
    _quest.description = _descriptionController.text;
    _quest.dueDateTime = dueDateTime;
    _quest.priority = _priorityController;
    
    await _db.insertOrUpdateTask(_quest);
  }

  Future<void> _addHabit() async {
    await _db.insertOrUpdateHabit(Habit(
      _titleController.text,
      _descriptionController.text,
      _isGoodController,
    ));
  }

  Future<void> _updateHabit() async {
    _quest.title = _titleController.text;
    _quest.description = _descriptionController.text;
    _quest.isGood = _isGoodController;

    await _db.insertOrUpdateHabit(_quest);
  }

  Future<void> _addRoutine() async {
    final DateTime dueDateTime = DateTime(_dateController.year, _dateController.month, _dateController.day, _timeController.hour, _timeController.minute);

    await _db.insertOrUpdateRoutine(Routine(
      _titleController.text,
      _descriptionController.text,
      int.tryParse(_frequencyController.text) ?? 1,
      _periodController,
      _daysController,
      dueDateTime,
    ));
  }

  Future<void> _updateRoutine() async {
    final DateTime dueDateTime = DateTime(_dateController.year, _dateController.month, _dateController.day, _timeController.hour, _timeController.minute);
             
    _quest.title = _titleController.text;
    _quest.description = _descriptionController.text;
    _quest.frequency = int.tryParse(_frequencyController.text) ?? 1;
    _quest.period = _periodController;
    _quest.days = _daysController;
    _quest.dueDateTime = dueDateTime;
    
    await _db.insertOrUpdateRoutine(_quest);
  }

  Future<void> _endRoutine() async {
    await _questProvider.endRoutine(_quest);
    if (mounted) { Navigator.pop(context); }
  }

  Future<void> _deleteQuest() async {
    if (_quest != null) {
      switch (_questType) {
        case QuestType.task:
          await _db.clearTask(_quest.id);
          break;
        case QuestType.habit:
          await _db.clearHabit(_quest.id);
          break;
        case QuestType.routine:
          await _db.clearRoutine(_quest.id);
          break;
      }
      await _questProvider.refreshData(_questType);

      if(mounted) { Navigator.pop(context); }
    }
  }
}