import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_api/api.dart';
import 'package:todo_list_app/app/common/todo_actions.dart';
class TodoFilterWidget extends StatefulWidget {
  const TodoFilterWidget({required this.onFilter,super.key});

  final TodoFilterCallback onFilter;
  @override
  State<TodoFilterWidget> createState() => _TodoFilterWidgetState();
}

class _TodoFilterWidgetState extends State<TodoFilterWidget> {
  int? _value = 0;
  List<Filter> filters=Filter.values.toList();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: List<Widget>.generate(
        filters.length,
            (int index) {
          return ChoiceChip(
            label: Text(filters[index].name.capitalize),
            selected: _value == index,
            onSelected: (bool selected) {
              setState(() {
                _value = selected ? index : null;
                widget.onFilter(filters[index]);
              });
            },
          );
        },
      ).toList(),
    );
  }
}
