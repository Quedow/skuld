import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/provider/quest_provider.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/utils/rules.dart';

class FormScreen extends StatefulWidget {
  final QuestProvider questProvider;
  final Map<QuestType, int>? questTypeAndId;

  const FormScreen({super.key, required this.questProvider, this.questTypeAndId});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final QuestProvider _questProvider;
  int _existingIndex = -1;

  QuestType _questType = QuestType.task;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dateController = DateTime.now();
  TimeOfDay _timeController = TimeOfDay.now();
  String _colorController = '#f44336';
  bool _isGoodController = true;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _questProvider = widget.questProvider;

    QuestType? existingQuestType = widget.questTypeAndId?.entries.first.key;
    int? existingId = widget.questTypeAndId?.entries.first.value;

    print(existingId);

    if (existingId != null) {
      _isEditMode = true;
      
      if (existingQuestType == QuestType.task) {
        final Task existingTask = _questProvider.tasks.firstWhere((task) => task.id == existingId);
        _existingIndex = _questProvider.tasks.indexOf(existingTask);

        _questType = QuestType.task;

        _titleController.text = existingTask.title;
        _descriptionController.text = existingTask.description;
        _dateController = existingTask.dueDateTime;
        _timeController = TimeOfDay.fromDateTime(existingTask.dueDateTime);
        _colorController = existingTask.color;
      } else if (existingQuestType == QuestType.habit) {
        final existingHabit = widget.questProvider.habits.firstWhere((habit) => habit.id == existingId);
        _existingIndex = _questProvider.habits.indexOf(existingHabit);
        
        _questType = QuestType.habit;

        _titleController.text = existingHabit.title;
        _descriptionController.text = existingHabit.description;
        _isGoodController = existingHabit.isGood;
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
        final dueDateTime = DateTime(
          _dateController.year,
          _dateController.month,
          _dateController.day,
          _timeController.hour,
          _timeController.minute,
        );

        Task newTask = Task(
          id: _questProvider.tasks.length + 1,
          title: _titleController.text,
          description: _descriptionController.text,
          dueDateTime: dueDateTime,
          color: _colorController,
        );
        _questProvider.addOrUpdateTask(newTask, _existingIndex);
      } else {
        Habit newHabit = Habit(
          id: _questProvider.habits.length + 1,
          title: _titleController.text,
          description: _descriptionController.text,
          isGood: _isGoodController,
          color: _isGoodController ? '#4caf50' : '#f44336',
        );
        _questProvider.addOrUpdateHabit(newHabit, _existingIndex);
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
                    ElevatedButton(onPressed: _submitForm, child: Text('Save')),
                    if (_isEditMode)
                      ElevatedButton(onPressed: _deleteQuest, child: Text('Delete')),
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
        ButtonSegment<QuestType>(label: Text('Task'), value: QuestType.task),
        ButtonSegment<QuestType>(label: Text('Habit'), value: QuestType.habit),
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
        Text('Due date'),
        Text(Functions.getDate(_dateController)),
        ElevatedButton(
          child: Text('Pick Date'),
          onPressed: () => _selectDate(context),
        ),
      ],
    );
  }

  Row _timeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Due time'),
        Text(_timeController.format(context)),
        ElevatedButton(
          child: Text('Pick Time'),
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
    if (_questType == QuestType.task && _existingIndex != -1) {
      _questProvider.removeTask(_existingIndex);
    } else if (_questType == QuestType.habit && _existingIndex != -1) {
      widget.questProvider.removeHabit(_existingIndex);
    }
    Navigator.pop(context);
  }
}