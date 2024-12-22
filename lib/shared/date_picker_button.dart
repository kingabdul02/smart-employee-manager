import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerButton extends StatelessWidget {
  final String selectedDate;
  final Function(String) onDateSelected;

  const DatePickerButton({
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(Icons.calendar_today),
      label:
          Text(DateFormat('MMM dd, yyyy').format(DateTime.parse(selectedDate))),
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.parse(selectedDate),
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
        );
        if (date != null) {
          onDateSelected(date.toString().split(' ')[0]);
        }
      },
    );
  }
}
