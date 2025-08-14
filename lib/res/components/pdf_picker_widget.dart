import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gig/res/colors/app_color.dart';

class PdfPickerWidget extends StatelessWidget {
  final File? pdfFile;
  final String pdfFileName;
  final VoidCallback onPickPdf;
  final VoidCallback onRemovePdf;

  const PdfPickerWidget({
    super.key,
    this.pdfFile,
    required this.pdfFileName,
    required this.onPickPdf,
    required this.onRemovePdf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.grayColor,

        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white24,
          width: pdfFile != null ? 2 : 1,
        ),
      ),
      child: pdfFile == null ? _buildPickerButton() : _buildSelectedPdf(),
    );
  }

  Widget _buildPickerButton() {
    return Column(
      children: [
        Icon(Icons.picture_as_pdf, size: 48, color: Colors.red.shade400),
        const SizedBox(height: 8),
        const Text(
          'Upload PDF Document',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        const Text(
          'Tap to select PDF file',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: onPickPdf,
          icon: const Icon(Icons.upload_file),
          label: const Text('Choose PDF'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primeColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedPdf() {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.picture_as_pdf, size: 32, color: AppColor.primeColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pdfFileName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PDF Selected',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRemovePdf,
              icon: Icon(Icons.close, color: AppColor.primeColor),
              style: IconButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onPickPdf,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Change PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primeColor,
                foregroundColor: Colors.grey.shade700,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
