import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/provider/database_service.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/utils/rules.dart';
import 'package:skuld/utils/styles.dart';

class FormScreen extends StatefulWidget {
  final Map<QuestType, dynamic>? typeAndQuest;

  const FormScreen({super.key, this.typeAndQuest});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final DatabaseService _db = DatabaseService();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late dynamic _quest;
  bool _isEditMode = false;

  QuestType _questType = QuestType.task;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dateController = DateTime.now();
  TimeOfDay _timeController = TimeOfDay.now();
  String _colorController = Styles.redColor;
  bool _isGoodController = true;

  @override
  void initState() {
    super.initState();
    if (widget.typeAndQuest == null) { return; }

    _questType =  widget.typeAndQuest!.entries.first.key;
    _quest = (_questType == QuestType.task)
      ? Functions.tryCast<Task>(widget.typeAndQuest?.entries.first.value)
      : Functions.tryCast<Habit>(widget.typeAndQuest?.entries.first.value);

    if (_quest == null) { return; }

    _tryLoadQuest();
  }

  Future<void> _tryLoadQuest() async {
    _isEditMode = true;

    if (_questType == QuestType.task) {
      setState(() {
        _titleController.text = _quest.title;
        _descriptionController.text = _quest.description;
        _dateController = _quest.dueDateTime;
        _timeController = TimeOfDay.fromDateTime(_quest.dueDateTime);
        _colorController = _quest.color;
      });
    } else if (_questType == QuestType.habit) {
      setState(() {
        _titleController.text = _quest.title;
        _descriptionController.text = _quest.description;
        _isGoodController = _quest.isGood;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) { return; }

    switch (_questType) {
      case QuestType.task:
        _isEditMode ? await _updateTask() : await _addTask();
        break;
      case QuestType.habit:
        _isEditMode ? await _updateHabit() : await _addHabit();
        break;
      case QuestType.routine:
        break;
    }
    _formKey.currentState!.reset();
    if (_isEditMode && mounted) { Navigator.pop(context, true); }
  }

  Future<void> _addTask() async {
    final DateTime dueDateTime = DateTime(_dateController.year, _dateController.month, _dateController.day, _timeController.hour, _timeController.minute);

    await _db.insertOrUpdateTask(Task(
      _titleController.text,
      _descriptionController.text,
      dueDateTime,
      _colorController,
    ),);
  }

  Future<void> _updateTask() async {
    final DateTime dueDateTime = DateTime(_dateController.year, _dateController.month, _dateController.day, _timeController.hour, _timeController.minute);
             
    _quest.title = _titleController.text;
    _quest.description = _descriptionController.text;
    _quest.dueDateTime = dueDateTime;
    _quest.color = _colorController;
    
    await _db.insertOrUpdateTask(_quest);
  }

  Future<void> _addHabit() async {
    await _db.insertOrUpdateHabit(Habit(
      _titleController.text,
      _descriptionController.text,
      _isGoodController,
      _isGoodController ? Styles.greenColor : Styles.redColor,
    ),);
  }

  Future<void> _updateHabit() async {
      _quest.title = _titleController.text;
      _quest.description = _descriptionController.text;
      _quest.isGood = _isGoodController;
      _quest.color = _isGoodController ? Styles.greenColor : Styles.redColor;
      await _db.insertOrUpdateHabit(_quest);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Texts.textTitleForm(_isEditMode, _questType)),
        actions: _isEditMode ? [
          IconButton(onPressed: _deleteQuest, icon: const Icon(Icons.delete_rounded)),
        ] : null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!_isEditMode)
                _segmentedButton(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _textField(_titleController, 'Title', Rules.isNotEmpty),
                    _textField(_descriptionController, 'Description', Rules.free),
                    ..._questForm(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton(onPressed: _submitForm, child: const Text('Save')),
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

  Padding _segmentedButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SegmentedButton<QuestType>(
        selected: {_questType},
        segments: [
          const ButtonSegment<QuestType>(label: Text('Task'), value: QuestType.task),
          const ButtonSegment<QuestType>(label: Text('Habit'), value: QuestType.habit),
        ],
        onSelectionChanged: (Set<QuestType> questTypes) {
          setState(() => _questType = questTypes.first);
        },
      ),
    );
  }

  Padding _textField(TextEditingController controller, String label, String? Function(String?) rules) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(Styles.borderRadius)),
        ),
        validator: rules,
      ),
    );
  }

  List<Widget> _questForm() {
    if (_questType == QuestType.task) {
      return [
        _selector(Icons.calendar_today_rounded, 'Due Date', Functions.getDate(_dateController), () => _selectDate(context)),
        _selector(Icons.access_time_rounded, 'Time', _timeController.format(context), () => _selectTime(context)),
        _colorSelector(),
      ];
    } else if (_questType == QuestType.habit) {
      return [_habitTypeSwitch()];
    }
    return [];
  }

  Padding _selector(IconData icon, String label, String data, void Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),  // Black border
          borderRadius: BorderRadius.circular(Styles.borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(data),
            IconButton(icon: Icon(icon), onPressed: onPressed),
          ],
        ),
      ),
    );
  }

  Padding _colorSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),  // Black border
          borderRadius: BorderRadius.circular(Styles.borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Select Color'),
            TextButton(
              style: const ButtonStyle(shape: WidgetStatePropertyAll(CircleBorder())),
              child: CircleAvatar(backgroundColor: Color(int.parse(_colorController.replaceFirst('#', '0xff'))), radius: 12),
              onPressed: () => _selectColor(),
            ),
          ],
        ),
      ),
    );
  }

  Padding _habitTypeSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SegmentedButton<bool>(
        selected: {_isGoodController},
        segments: [
          const ButtonSegment<bool>(label: Text('Good Habit'), value: true),
          const ButtonSegment<bool>(label: Text('Bad Habit'), value: false),
        ],
        onSelectionChanged: (Set<bool> questTypes) {
          setState(() => _isGoodController = questTypes.first);
        },
      ),
    );
  }

 Future<void> _selectDate(BuildContext context) async {
    final DateTime? dueDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      initialTime: TimeOfDay.now(),
    );
    if (dueTime != null && dueTime != _timeController) {
      setState(() => _timeController = dueTime);
    }
  }

  Future<void> _selectColor() async {
    Color? color = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: BlockPicker(
            pickerColor: const Color(0xfff44336),
            onColorChanged: (color) {
              Navigator.of(context).pop(color);
            },
          ),
        );
      },
    );

    if (color != null) {
      setState(() => _colorController = '#${color.value.toRadixString(16).padLeft(8, '0')}');
    }
  }

  Future<void> _deleteQuest() async {
    if (_questType == QuestType.task && _quest != null) {
      await _db.clearTask(_quest.id);
    } else if (_questType == QuestType.habit && _quest != null) {
      await _db.clearHabit(_quest.id);
    }

    if(mounted) {
      Navigator.pop(context, true);
    }
  }
}