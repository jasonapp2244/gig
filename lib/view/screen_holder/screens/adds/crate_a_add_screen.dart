import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../res/fonts/app_fonts.dart';

class CreaAAddScreen extends StatefulWidget {
  const CreaAAddScreen({super.key});

  @override
  State<CreaAAddScreen> createState() => _CreaAAddScreen();
}

class _CreaAAddScreen extends State<CreaAAddScreen> {

  final picker = ImagePicker();
  List<XFile> _images = [];

  String? selectedCategory;
  String? selectedCondition;

  final List<String> categories = ['Electronics', 'Furniture', 'Clothing', 'Books'];
  final List<String> conditions = ['New', 'Used', 'Refurbished'];

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final addressController = TextEditingController();

  Future<void> pickImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() => _images = pickedFiles);
    }
  }

  Widget buildInputField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(label, style: TextStyle(color: Colors.white)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(color: Colors.white60, fontFamily: AppFonts.appFont),
            filled: true,
            fillColor: AppColor.grayColor,
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
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

 Widget buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 5),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.grayColor,
          border: Border.all(color: Colors.white24),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            label,
            style: TextStyle(color: Colors.white60, fontFamily: AppFonts.appFont),
          ),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(
                val,
                style: TextStyle(color: Colors.white60, fontFamily: AppFonts.appFont),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          underline: SizedBox(),
          dropdownColor: AppColor.grayColor, // Optional: dropdown bg color
        ),
      ),
      SizedBox(height: 15),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar Area
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, color: AppColor.primeColor),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 35,
                  left: 35,
                  child: Text(
                    'Create Add',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.secondColor,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Picker
                  GestureDetector(
                    onTap: pickImages,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _images.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, color: Colors.white),
                                  SizedBox(height: 10),
                                  Text("Add Photo", style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _images.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.all(8),
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: FileImage(File(_images[index].path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Photo description
                  Text("Choose your listing's main photo first.",
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 6),
                  Text("How to take a great listing photo",
                      style: TextStyle(color: AppColor.secondColor)),

                  SizedBox(height: 20),

                  // Form Fields
                  buildInputField("Title", titleController),
                  buildInputField("Price", priceController),
                  buildDropdown("Category", categories, selectedCategory,
                      (val) => setState(() => selectedCategory = val)),
                  buildDropdown("Condition", conditions, selectedCondition,
                      (val) => setState(() => selectedCondition = val)),
                  buildInputField("Description", descController, maxLines: 4),
                  buildInputField("Address", addressController),

                  SizedBox(height: 20),

                  // Info text
                  Text(
                    "Anyone can contact them via chat to purchase the product.",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                    "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                    style: TextStyle(color: Colors.white70),
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}


