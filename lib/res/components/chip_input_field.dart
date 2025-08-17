import 'package:flutter/material.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/fonts/app_fonts.dart';

class ChipInputField extends StatelessWidget {
  final List<String> selectedChips;
  final Function(String) onChipAdded;
  final Function(String) onChipRemoved;
  final String hintText;
  final TextEditingController textController;

  const ChipInputField({
    super.key,
    required this.selectedChips,
    required this.onChipAdded,
    required this.onChipRemoved,
    this.hintText = 'Add skills, tags, etc.',
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input field for adding chips
          TextField(
            controller: textController,
            style: TextStyle(color: Colors.white),

            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 17,
              ),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white24, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white24, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: AppColor.grayColor,
              hintText: hintText,
              hintStyle: TextStyle(color: AppColor.grayColor, fontSize: 16),

              suffixIcon: IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: AppColor.primeColor,
                  size: 24,
                ),
                onPressed: () {
                  if (textController.text.trim().isNotEmpty) {
                    onChipAdded(textController.text.trim());
                    textController.clear();
                  }
                },
              ),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                onChipAdded(value.trim());
                textController.clear();
              }
            },
          ),

          const SizedBox(height: 16),

          // Display selected chips in a bordered container like the image
          if (selectedChips.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.grayColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skills',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: selectedChips.map((chip) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.grayColor,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              chip,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => onChipRemoved(chip),
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // Always show placeholder when no chips
          if (selectedChips.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.grayColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Text(
                'No chips added yet. Type in the field above and press Enter or click +',
                style: TextStyle(
                  fontSize: 14,

                  color: Colors.white60,
                  fontFamily: AppFonts.appFont,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
