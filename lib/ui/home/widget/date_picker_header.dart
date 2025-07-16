import 'package:calorie_tracker_app/core/ui/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerHeader extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSelectDate;

  const DatePickerHeader({
    super.key,
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
    required this.onSelectDate,
  });

  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) return "Today";
    if (checkDate == yesterday) return "Yesterday";
    if (checkDate == tomorrow) return "Tomorrow";
    return DateFormat.yMMMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
     final label = _formatDateLabel(selectedDate);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: const Icon(Icons.arrow_back), onPressed: onPrevious),
        GestureDetector(
          onTap: onSelectDate,
          child: CustomText(
            label: label,
          ),
        ),
        IconButton(icon: const Icon(Icons.arrow_forward), onPressed: onNext),
      ],
    );
  }
}
