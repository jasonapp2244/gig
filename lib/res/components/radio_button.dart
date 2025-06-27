import 'package:flutter/material.dart';

import '../colors/app_color.dart';

class RadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T?> onChanged;

  const RadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: isSelected ? AppColor.primeColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
