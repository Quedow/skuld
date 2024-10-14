import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/provider/database_service.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/utils/rules.dart';

class FormScreen extends StatefulWidget {
  final Map<QuestType, int>? questTypeAndId;

  const FormScreen({super.key, this.questTypeAndId});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final DatabaseService _db = DatabaseService();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final int? _idToUpdate;
  bool _isEditMode = false;

  late QuestType _questType;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dateController = DateTime.now();
  TimeOfDay _timeController = TimeOfDay.now();
  String _colorController = '#f44336';
  bool _isGoodController = true;

  @override
  void initState() {
    super.initState();
    _questType =  widget.questTypeAndId?.entries.first.key ?? QuestType.task;
    _idToUpdate = widget.questTypeAndId?.entries.first.value;
    _tryLoadQuest();
  }

  Future<void> _tryLoadQuest() async {
    if (_idToUpdate != null) {
      _isEditMode = true;

      if (_questType == QuestType.task) {
        final Task? taskToUpdate = await _db.getTask(_idToUpdate);

        if (taskToUpdate == null) { return; }

        setState(() {
          _titleController.text = taskToUpdate.title;
          _descriptionController.text = taskToUpdate.description;
          _dateController = taskToUpdate.dueDateTime;
          _timeController = TimeOfDay.fromDateTime(taskToUpdate.dueDateTime);
          _colorController = taskToUpdate.color;
        });
      } else if (_questType == QuestType.habit) {
        final Habit? habitToUpdate = await _db.getHabit(_idToUpdate);

        if (habitToUpdate == null) { return; }

        setState(() {
          _titleController.text = habitToUpdate.title;
          _descriptionController.text = habitToUpdate.description;
          _isGoodController = habitToUpdate.isGood;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_questType == QuestType.task) {
        final DateTime dueDateTime = DateTime(_dateController.year, _dateController.month, _dateController.day, _timeController.hour, _timeController.minute);

        Task task = Task(
          _titleController.text,
          _descriptionController.text,
          dueDateTime,
          _colorController,
        );
        _db.insertOrUpdateTask(_idToUpdate, task);
      } else {
        Habit habit = Habit(
          _titleController.text,
          _descriptionController.text,
          _isGoodController,
          _isGoodController ? '#4caf50' : '#f44336',
        );
        _db.insertOrUpdateHabit(habit);
      }
      _formKey.currentState!.reset();
      if (_isEditMode) { Navigator.pop(context, true); }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            children: [
              Text(_isEditMode ? 'Edit ${_questType == QuestType.task ? "Task" : "Habit"}' : 'Create ${_questType == QuestType.task ? "Task" : "Habit"}'),
              if (!_isEditMode)
                _segmentedButton(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _textField(_titleController, 'Title', Rules.isNotEmpty),
                    _textField(_descriptionController, 'Description', Rules.free),
                    ..._questForm(),
                    ElevatedButton(onPressed: _submitForm, child: const Text('Save')),
                    if (_isEditMode)
                      ElevatedButton(onPressed: _deleteQuest, child: const Text('Delete')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SegmentedButton _segmentedButton() {
    return SegmentedButton<QuestType>(
      selected: {_questType},
      segments: [
        const ButtonSegment<QuestType>(label: Text('Task'), value: QuestType.task),
        const ButtonSegment<QuestType>(label: Text('Habit'), value: QuestType.habit),
      ],
      onSelectionChanged: (Set<QuestType> questTypes) {
        setState(() {
          _questType = questTypes.first;
        });
      }
    );
  }

  TextFormField _textField(TextEditingController controller, String label, String? Function(String?) rules) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: rules,
    );
  }

  List<Widget> _questForm() {
    if (_questType == QuestType.task) {
      return [
        _dateSelector(),
        _timeSelector(),
        _colorSelector(),
      ];
    } else if (_questType == QuestType.habit) {
      return [_habitTypeSwitch()];
    }
    return [];
  }

  Row _dateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Due date'),
        Text(Functions.getDate(_dateController)),
        ElevatedButton(
          child: const Text('Pick Date'),
          onPressed: () => _selectDate(context),
        ),
      ],
    );
  }

  Row _timeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Due time'),
        Text(_timeController.format(context)),
        ElevatedButton(
          child: const Text('Pick Time'),
          onPressed: () => _selectTime(context),
        ),
      ],
    );
  }

  ElevatedButton _colorSelector() {
    return ElevatedButton(
      onPressed: () => _selectColor(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Select Color'),
          CircleAvatar(backgroundColor: Color(int.parse(_colorController.replaceFirst('#', '0xff'))), radius: 10),
        ],
      ),
    );
  }

  SegmentedButton _habitTypeSwitch() {
    return SegmentedButton<bool>(
      selected: {_isGoodController},
      segments: [
        ButtonSegment<bool>(label: Text('Good Habit'), value: true),
        ButtonSegment<bool>(label: Text('Bad Habit'), value: false),
      ],
      onSelectionChanged: (Set<bool> questTypes) {
        setState(() {
          _isGoodController = questTypes.first;
        });
      }
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
      setState(() {
        _dateController = dueDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? dueTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (dueTime != null && dueTime != _timeController) {
      setState(() {
        _timeController = dueTime;
      });
    }
  }

  Future<void> _selectColor() async {
    Color? color = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: BlockPicker(
            pickerColor: Color(0xfff44336),
            onColorChanged: (color) {
              Navigator.of(context).pop(color);
            },
          ),
        );
      },
    );

    if (color != null) {
      setState(() {
        _colorController = '#${color.value.toRadixString(16).padLeft(8, '0')}';
      });
    }
  }

  void _deleteQuest() {
    if (_questType == QuestType.task && _idToUpdate != null) {
      _db.clearTask(_idToUpdate);
    } else if (_questType == QuestType.habit && _idToUpdate != null) {
      _db.clearHabit(_idToUpdate);
    }
    Navigator.pop(context);
  }
}