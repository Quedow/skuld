import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/utils/rules.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  QuestTypes _questType = QuestTypes.task;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedColor = 'FF0000';
  bool _isGoodHabit = true;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_questType == QuestTypes.task) {
        final dueDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        Task newTask = Task(
          title: _titleController.text,
          description: _descriptionController.text,
          dueDateTime: dueDateTime,
          color: _selectedColor,
        );

        print("Task created: ${newTask.title}");
      } else {
        // Create Habit
        Habit newHabit = Habit(
          title: _titleController.text,
          description: _descriptionController.text,
          isGood: _isGoodHabit,
          color: _isGoodHabit ? 'fff44336' : 'fff44336',
        );

        print("Habit created: ${newHabit.title} - Is bad: ${newHabit.isGood}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: Column(
        children: [
          Text('Create Task'),
          _segmentedButton(),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _textField(_titleController, 'Title', Rules.isNotEmpty),
                _textField(_descriptionController, 'Description', Rules.isNotEmpty),
                ..._questForm(),
                ElevatedButton(onPressed: _submitForm, child: Text('Add')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  SegmentedButton _segmentedButton() {
    return SegmentedButton<QuestTypes>(
      selected: {_questType},
      segments: [
        ButtonSegment<QuestTypes>(label: Text('Task'), value: QuestTypes.task),
        ButtonSegment<QuestTypes>(label: Text('Habit'), value: QuestTypes.habit),
      ],
      onSelectionChanged: (Set<QuestTypes> questTypes) {
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
    if (_questType == QuestTypes.task) {
      return [
        _dateSelector(),
        _timeSelector(),
        _colorSelector(),
      ];
    } else if (_questType == QuestTypes.habit) {
      return [_habitTypeSwitch()];
    }
    return [];
  }

  Row _dateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Due date'),
        Text(DateFormat('MM/dd/yyyy').format(_selectedDate)),
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
        Text(_selectedTime.format(context)),
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
          CircleAvatar(backgroundColor: Color(int.parse(_selectedColor.replaceFirst('#', '0xff'))), radius: 10),
        ],
      ),
    );
  }

  SegmentedButton _habitTypeSwitch() {
    return SegmentedButton<bool>(
      selected: {_isGoodHabit},
      segments: [
        ButtonSegment<bool>(label: Text('Good Habit'), value: true),
        ButtonSegment<bool>(label: Text('Bad Habit'), value: false),
      ],
      onSelectionChanged: (Set<bool> questTypes) {
        setState(() {
          _isGoodHabit = questTypes.first;
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

    if (dueDate != null && dueDate != _selectedDate) {
      setState(() {
        _selectedDate = dueDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? dueTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (dueTime != null && dueTime != _selectedTime) {
      setState(() {
        _selectedTime = dueTime;
      });
    }
  }

  Future<void> _selectColor() async {
    Color? color = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: BlockPicker(
            pickerColor: Color(0xFFFF0000),
            onColorChanged: (color) {
              Navigator.of(context).pop(color);
            },
          ),
        );
      },
    );

    if (color != null) {
      setState(() {
        _selectedColor = '#${color.value.toRadixString(16).padLeft(8, '0')}';
      });
    }
  }
}

enum QuestTypes { task, habit, routine }