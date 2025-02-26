import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:skuld/utils/rules.dart';
import 'package:skuld/utils/styles.dart';

class SegmentedButtonQuest<T> extends StatelessWidget {
  final T selectedValue;
  final Map<T, String> segmentsMap;
  final void Function(Set<T>) onSelectionChanged;

  const SegmentedButtonQuest({super.key, required this.selectedValue, required this.segmentsMap, required this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SegmentedButton<T>(
        selected: {selectedValue},
        segments: segmentsMap.entries.map<ButtonSegment<T>>((entry) {
          return ButtonSegment<T>(value: entry.key, label: Text(entry.value));
        }).toList(),
        onSelectionChanged: onSelectionChanged,
        showSelectedIcon: false,
      ),
    );
  }
}

class InputText extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) rules;
  final bool multiLines;

  const InputText({super.key, required this.controller, required this.label, required this.rules, this.multiLines = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        maxLines: multiLines ? 5 : 1,
        decoration: InputDecoration(labelText: label, alignLabelWithHint: true),
        validator: rules,
      ),
    );
  }
}

class IconSelector extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final void Function()? onPressed;

  const IconSelector({super.key, required this.icon, required this.label, required this.value, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Styles.borderRadius),
          border: Border.all(color: Theme.of(context).hintColor, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            Text(value, style: Theme.of(context).textTheme.bodyMedium),
            IconButton(icon: Icon(icon), onPressed: onPressed, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}

class PriorityDropdown extends StatelessWidget {
  final int controller;
  final Map<int, Color> priorityToColor;
  final Map<int, String> priorityToLabel;
  final void Function(int?)? onChanged;

  const PriorityDropdown({super.key, required this.controller, required this.priorityToColor, required this.priorityToLabel, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<int>(
        value: controller,
        decoration: const InputDecoration(labelText: 'Select Priority'),
        onChanged: onChanged,
        items: priorityToLabel.entries.map((entry) {
          return DropdownMenuItem<int>(
            value: entry.key,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: priorityToColor[entry.key],
                  ),
                ),
                Text(entry.value, style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class FrequencySelector extends StatelessWidget {
  final TextEditingController frequencyController;
  final String periodController;
  final List<int> daysController;
  final Map<String, String> periodToLabel;
  final Map<int, String> dayToLabel;
  final void Function(String?)? onPeriodChanged;
  final void Function(List<int>?)? onFormSaved;

  const FrequencySelector({super.key, required this.frequencyController, required this.periodController, required this.daysController, required this.periodToLabel, required this.dayToLabel, required this.onPeriodChanged, required this.onFormSaved});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Styles.borderRadius),
          border: Border.all(color: Theme.of(context).hintColor, width: 1),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Repeat all', style: Theme.of(context).textTheme.labelLarge),
                SizedBox(
                  width: 40,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: frequencyController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration.collapsed(
                      hintText: '',
                      border: UnderlineInputBorder(),
                    ),
                    validator: Rules.isInteger,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    value: periodController,
                    iconEnabledColor: Theme.of(context).colorScheme.primary,
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                    onChanged: onPeriodChanged,
                    items: periodToLabel.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(entry.value, style: Theme.of(context).textTheme.labelLarge),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            if (periodController == 'w')
              SizedBox(
                width: double.infinity,
                child: DaysChoice(daysController: daysController, options: dayToLabel, onSaved: onFormSaved),
              ),
          ],
        ),
      ),
    );
  }
}

class DaysChoice extends StatelessWidget {
  final List<int> daysController;
  final Map<int, String> options;
  final void Function(List<int>?)? onSaved;

  const DaysChoice({super.key, required this.daysController, required this.options, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return FormField<List<int>>(
      initialValue: daysController,
      onSaved: onSaved,
      builder: (formState) {
        return InlineChoice<int>(
          multiple: true,
          value: formState.value ?? [],
          onChanged: formState.didChange,
          itemCount: options.length,
          itemBuilder: (selection, i) => ChoiceChip(
            showCheckmark: false,
            shape: const CircleBorder(),
            labelStyle: const TextStyle(fontSize: 12),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            selected: selection.selected(options.keys.elementAt(i)),
            onSelected: selection.onSelected(options.keys.elementAt(i)),
            label: Text(options.values.elementAt(i)),
          ),
          listBuilder: ChoiceList.createWrapped(
            spacing: 4,
            alignment: WrapAlignment.center,
            padding: const EdgeInsets.only(top: 5, bottom: 15),
          ),
        );
      },
    );
  }
}