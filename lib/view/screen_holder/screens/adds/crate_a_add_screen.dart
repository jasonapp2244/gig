import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/app_url/app_url.dart';
import 'package:gig/res/components/input.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/view/screen_holder/screen_holder_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
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
  final _formKey = GlobalKey<FormState>();

  String? selectedCategory;
  String? selectedCondition;

  // ✅ Categories will be fetched from API
  Map<String, String> categories = {};

  final Map<String, String> conditions = {'New': 'new', 'Used': 'used'};

  final titleController = TextEditingController();
  final oldPriceController = TextEditingController();
  final newPriceController = TextEditingController();
  final descController = TextEditingController();
  final locationController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories(); // fetch categories from API
  }

  Future<void> _loadCategories() async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}/api/get-list-category");
      String? token = await Utils.readSecureData('auth_token');
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          Map<String, String> loadedCats = {};
          for (var item in jsonResponse['data']) {
            loadedCats[item['category']] = item['id'].toString();
          }

          setState(() {
            categories = loadedCats;
          });
        }
      } else {
        print("Failed to load categories: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading categories: $e");
    }
  }

  Future<void> pickImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() => _images = pickedFiles);
    }
  }

  Future<void> _uploadAd() async {
    setState(() => _isLoading = true);

    try {
      if (_formKey.currentState?.validate() ?? false) {
        var uri = Uri.parse('${AppUrl.baseUrl}/api/add-list');
        var request = http.MultipartRequest('POST', uri);
        String? token = await Utils.readSecureData('auth_token');

        request.headers['Authorization'] = 'Bearer $token';

        request.fields['title'] = titleController.text;
        request.fields['old_price'] = oldPriceController.text;
        request.fields['new_price'] = newPriceController.text;
        request.fields['location'] = locationController.text;
        request.fields['description'] = descController.text;
        request.fields['condition'] = conditions[selectedCondition]!;
        request.fields['category_id'] =
            categories[selectedCategory]!; // ✅ send ID

        for (var i = 0; i < _images.length; i++) {
          var file = File(_images[i].path);
          var multipartFile = await http.MultipartFile.fromPath(
            'images[$i]',
            file.path,
            contentType: MediaType('image', 'jpeg'),
          );
          request.files.add(multipartFile);
        }

        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(responseString);
          if (jsonResponse['status'] == true) {
            _showSuccessDialog('Ad created successfully!');
            _clearForm();
          } else {
            _showErrorDialog(jsonResponse['message'] ?? 'Failed to create ad');
          }
        } else {
          _showErrorDialog('Failed. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.grayColor,
        content: Text(message, style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK', style: TextStyle(color: AppColor.primeColor)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.grayColor,
        content: Text(message, style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              Get.offAll(() => ScreenHolderScreen());
            },
            child: Text('OK', style: TextStyle(color: AppColor.primeColor)),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    titleController.clear();
    oldPriceController.clear();
    newPriceController.clear();
    descController.clear();
    locationController.clear();
    setState(() {
      selectedCategory = null;
      selectedCondition = null;
      _images = [];
    });
  }

  Widget buildInputField(
    String fieldType,
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        CustomInputField(
          fieldType: fieldType,
          controller: controller,
          hintText: label,
          validator: validator,
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget buildDropdown(
    String label,
    List<String> items,
    String? value,
    Function(String?) onChanged, {
    String? Function(String?)? validator, // 👈 added validator parameter
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          initialValue: value,

          onChanged: onChanged,
          validator: validator, // 👈 validation added here
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.grayColor, // background color
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 15,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white70),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            hintText: label,
            hintStyle: TextStyle(
              color: Colors.white60,
              fontFamily: AppFonts.appFont,
            ),
          ),

          dropdownColor: AppColor.grayColor,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.appFont,
          ),
          iconEnabledColor: AppColor.textColor,
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(
                val,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: AppFonts.appFont,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // AppBar Area
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      bottom: 10,
                      top: 10,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColor.primeColor,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 35,
                    left: 35,
                    child: Text(
                      'Create Ad',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColor.secondColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                                      Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Add Photo",
                                        style: TextStyle(color: Colors.white),
                                      ),
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
                                          image: FileImage(
                                            File(_images[index].path),
                                          ),
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
                      Text(
                        "Choose your listing's main photo first.",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "How to take a great listing photo",
                        style: TextStyle(color: AppColor.secondColor),
                      ),

                      SizedBox(height: 20),

                      // Form Fields - Updated to match API requirements
                      buildInputField(
                        "",
                        "Title",
                        titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Title is required';
                          return null;
                        },
                      ),

                      buildInputField(
                        "number",
                        "Old Price",
                        oldPriceController,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Old Price is required';
                          return null;
                        },
                      ),
                      buildInputField(
                        "number",
                        "New Price",
                        newPriceController,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'New Price is required';
                          return null;
                        },
                      ),
                      buildDropdown(
                        "Category",
                        categories.keys.toList(),
                        selectedCategory,
                        (val) => setState(() => selectedCategory = val),
                        validator: (value) {
                          if (selectedCategory!.isEmpty) {
                            return 'Category is required';
                          }
                          return null;
                        },
                      ),
                      buildDropdown(
                        "Condition",
                        conditions.keys.toList(),
                        selectedCondition,
                        (val) => setState(() => selectedCondition = val),
                        validator: (value) {
                          if (selectedCondition!.isEmpty) {
                            return 'Condition is required';
                          }
                          return null;
                        },
                      ),
                      buildInputField(
                        "",
                        "Description",
                        descController,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Description is required';
                          return null;
                        },
                      ),
                      buildInputField(
                        "",
                        "Location",
                        locationController,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Location is required';
                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      // Info text
                      Text(
                        "Anyone can contact them via chat to purchase the product.",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                        style: TextStyle(color: Colors.white70),
                      ),

                      SizedBox(height: 30),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _uploadAd,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primeColor,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Create Ad',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
