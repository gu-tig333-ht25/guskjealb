import 'package:flutter/material.dart';
import 'filter.dart';

class DropdownFilter {
  final List<String> list = ['All', 'Done', 'Not Done'];

  static final List<TodoFilter> menuEntries = UnmodifiableListView<TodoFilter>(
    list.map<TodoFilter>((String name) => menuEntries(value: name, label: name)),
  );
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: menuEntries,
    );
  }
}