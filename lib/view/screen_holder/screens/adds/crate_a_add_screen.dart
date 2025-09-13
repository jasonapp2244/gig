// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../../res/colors/app_color.dart';
// import '../../../../res/fonts/app_fonts.dart';

// class CreaAAddScreen extends StatefulWidget {
//   const CreaAAddScreen({super.key});

//   @override
//   State<CreaAAddScreen> createState() => _CreaAAddScreen();
// }

// class _CreaAAddScreen extends State<CreaAAddScreen> {
//   final picker = ImagePicker();
//   List<XFile> _images = [];

//   String? selectedCategory;
//   String? selectedCondition;

//   final List<String> categories = [
//     'Electronics',
//     'Furniture',
//     'Clothing',
//     'Books',
//   ];
//   final List<String> conditions = ['New', 'Used', 'Refurbished'];

//   final titleController = TextEditingController();
//   final priceController = TextEditingController();
//   final descController = TextEditingController();
//   final addressController = TextEditingController();

//   Future<void> pickImages() async {
//     final pickedFiles = await picker.pickMultiImage();
//     if (pickedFiles.isNotEmpty) {
//       setState(() => _images = pickedFiles);
//     }
//   }

//   Future<void> postAdd() async {
//     final url = Uri.parse("https://lavender-buffalo-882516.hostingersite.com/gig_app/api/add-list");

//     try {
//       if (titleController==) {

//       } else {

//       }
//     } catch (e) {

//     }
//   }

//   Widget buildInputField(
//     String label,
//     TextEditingController controller, {
//     int maxLines = 1,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Text(label, style: TextStyle(color: Colors.white)),
//         SizedBox(height: 5),
//         TextField(
//           controller: controller,
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             hintText: label,
//             hintStyle: const TextStyle(
//               color: Colors.white60,
//               fontFamily: AppFonts.appFont,
//             ),
//             filled: true,
//             fillColor: AppColor.grayColor,
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 15,
//               horizontal: 17,
//             ),
//             border: OutlineInputBorder(),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.white24, width: 1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.white24, width: 1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.red, width: 1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.red, width: 1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//         SizedBox(height: 15),
//       ],
//     );
//   }

//   Widget buildDropdown(
//     String label,
//     List<String> items,
//     String? value,
//     Function(String?) onChanged,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: 5),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: AppColor.grayColor,
//             border: Border.all(color: Colors.white24),
//           ),
//           child: DropdownButton<String>(
//             isExpanded: true,
//             value: value,
//             hint: Text(
//               label,
//               style: TextStyle(
//                 color: Colors.white60,
//                 fontFamily: AppFonts.appFont,
//               ),
//             ),
//             items: items.map((String val) {
//               return DropdownMenuItem<String>(
//                 value: val,
//                 child: Text(
//                   val,
//                   style: TextStyle(
//                     color: Colors.white60,
//                     fontFamily: AppFonts.appFont,
//                   ),
//                 ),
//               );
//             }).toList(),
//             onChanged: onChanged,
//             underline: SizedBox(),
//             dropdownColor: AppColor.grayColor, // Optional: dropdown bg color
//           ),
//         ),
//         SizedBox(height: 15),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appBodyBG,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // AppBar Area
//             Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: InkWell(
//                       onTap: () => Navigator.pop(context),
//                       child: Icon(Icons.arrow_back, color: AppColor.primeColor),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   right: 35,
//                   left: 35,
//                   child: Text(
//                     'Create Add',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: AppColor.secondColor,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Image Picker
//                     GestureDetector(
//                       onTap: pickImages,
//                       child: Container(
//                         height: 150,
//                         decoration: BoxDecoration(
//                           color: Colors.white10,
//                           border: Border.all(color: Colors.white),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: _images.isEmpty
//                             ? Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.add_a_photo,
//                                       color: Colors.white,
//                                     ),
//                                     SizedBox(height: 10),
//                                     Text(
//                                       "Add Photo",
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: _images.length,
//                                 itemBuilder: (context, index) {
//                                   return Container(
//                                     margin: EdgeInsets.all(8),
//                                     width: 100,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       image: DecorationImage(
//                                         image: FileImage(
//                                           File(_images[index].path),
//                                         ),
//                                         fit: BoxFit.fill,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                       ),
//                     ),
//                     SizedBox(height: 10),

//                     // Photo description
//                     Text(
//                       "Choose your listing's main photo first.",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     SizedBox(height: 6),
//                     Text(
//                       "How to take a great listing photo",
//                       style: TextStyle(color: AppColor.secondColor),
//                     ),

//                     SizedBox(height: 20),

//                     // Form Fields
//                     buildInputField("Title", titleController),
//                     buildInputField("Price", priceController),
//                     buildDropdown(
//                       "Category",
//                       categories,
//                       selectedCategory,
//                       (val) => setState(() => selectedCategory = val),
//                     ),
//                     buildDropdown(
//                       "Condition",
//                       conditions,
//                       selectedCondition,
//                       (val) => setState(() => selectedCondition = val),
//                     ),
//                     buildInputField("Description", descController, maxLines: 4),
//                     buildInputField("Address", addressController),

//                     SizedBox(height: 20),

//                     // Info text
//                     Text(
//                       "Anyone can contact them via chat to purchase the product.",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
//                       "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
//                       style: TextStyle(color: Colors.white70),
//                     ),

//                     SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Updated to use IDs instead of names if needed by your API
  final Map<String, String> categories = {
    'Electronics': '1',
    'Furniture': '2',
    'Clothing': '3',
    'Books': '4',
  };

  final Map<String, String> conditions = {
    'New': 'new',
    'Used': 'used',
    'Refurbished': 'refurbished',
  };

  final titleController = TextEditingController();
  final oldPriceController = TextEditingController();
  final newPriceController = TextEditingController();
  final descController = TextEditingController();
  final locationController = TextEditingController();

  bool _isLoading = false;

  Future<void> pickImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() => _images = pickedFiles);
    }
  }

  // Function to get user token from shared preferences
  Future<String?> _getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token'); // Adjust this key as per your app
  }

  // Function to upload the ad
  Future<void> _uploadAd() async {
    // Validate required fields
    if (_images.isEmpty) {
      _showErrorDialog('Please select at least one image');
      return;
    }

    if (titleController.text.isEmpty ||
        oldPriceController.text.isEmpty ||
        newPriceController.text.isEmpty ||
        descController.text.isEmpty ||
        locationController.text.isEmpty ||
        selectedCategory == null ||
        selectedCondition == null) {
      _showErrorDialog('Please fill all required fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get user token
      // final token = await _getUserToken();
      // if (token == null) {
      //   _showErrorDialog('Please login to create an ad');
      //   setState(() => _isLoading = false);
      //   return;
      // }

      // Create multipart request
      var uri = Uri.parse(
        'https://lavender-buffalo-882516.hostingersite.com/gig_app/api/add-list',
      );
      var request = http.MultipartRequest('POST', uri);

      // Add headers
      // request.headers['Authorization'] = 'Bearer $token';

      request.headers['Authorization'] = 'Bearer 126|qksaUczKY1shrR6x3kng0lzCB6AMPpL41uGgtdx3fa2c6dc2';
      // Add text fields based on your API requirements
      request.fields['title'] = titleController.text;
      request.fields['old_price'] = oldPriceController.text;
      request.fields['new_price'] = newPriceController.text;
      request.fields['location'] = locationController.text;
      request.fields['description'] = descController.text;
      request.fields['condition'] = conditions[selectedCondition]!;
      request.fields['category_id'] = categories[selectedCategory]!;

      // Add images with proper field names (images[0], images[1], etc.)
      for (var i = 0; i < _images.length; i++) {
        var file = File(_images[i].path);
        var multipartFile = await http.MultipartFile.fromPath(
          'images[$i]', // Field name format as per your API
          file.path,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      // Send request
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        // Parse response
        var jsonResponse = json.decode(responseString);

        if (jsonResponse['status'] == true) {
          // Success
          _showSuccessDialog('Ad created successfully!');
          _clearForm();
        } else {
          // API returned error
          _showErrorDialog(jsonResponse['message'] ?? 'Failed to create ad');
        }
      } else {
        // HTTP error
        _showErrorDialog(
          'Failed to create ad. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
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
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); // Go back to previous screen
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
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(
              color: Colors.white60,
              fontFamily: AppFonts.appFont,
            ),
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

  Widget buildDropdown(
    String label,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
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
              style: TextStyle(
                color: Colors.white60,
                fontFamily: AppFonts.appFont,
              ),
            ),
            items: items.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(
                  val,
                  style: TextStyle(
                    color: Colors.white60,
                    fontFamily: AppFonts.appFont,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            underline: SizedBox(),
            dropdownColor: AppColor.grayColor,
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
                    buildInputField("Title", titleController),
                    buildInputField(
                      "Old Price",
                      oldPriceController,
                      keyboardType: TextInputType.number,
                    ),
                    buildInputField(
                      "New Price",
                      newPriceController,
                      keyboardType: TextInputType.number,
                    ),
                    buildDropdown(
                      "Category",
                      categories.keys.toList(),
                      selectedCategory,
                      (val) => setState(() => selectedCategory = val),
                    ),
                    buildDropdown(
                      "Condition",
                      conditions.keys.toList(),
                      selectedCondition,
                      (val) => setState(() => selectedCondition = val),
                    ),
                    buildInputField("Description", descController, maxLines: 4),
                    buildInputField("Location", locationController),

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
    );
  }
}
