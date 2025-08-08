import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Controller class to access widget methods from outside
class CustomPhotoController {
  _CustomPhotoWidgetState? _state;

  void _attach(_CustomPhotoWidgetState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  // Public method to trigger image picking
  Future<void> pickImage() async {
    await _state?.pickImage();
  }

  // Public method to trigger image picker options
  Future<void> showImagePickerOptions() async {
    await _state?._showImagePickerOptions();
  }

  // Get current image file
  File? get currentImage => _state?._imageFile;

  // Remove current image
  void removeImage() {
    _state?._removeImage();
  }
}

class CustomPhotoWidget extends StatefulWidget {
  final Function(File?)? onImagePicked;
  final String? initialImagePath;
  final double radius;
  final Color backgroundColor;
  final CustomPhotoController? controller;

  const CustomPhotoWidget({
    super.key,
    this.onImagePicked,
    this.initialImagePath,
    this.radius = 40,
    this.backgroundColor = Colors.orange,
    this.controller,
  });

  @override
  State<CustomPhotoWidget> createState() => _CustomPhotoWidgetState();
}

class _CustomPhotoWidgetState extends State<CustomPhotoWidget> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.initialImagePath != null) {
      _imageFile = File(widget.initialImagePath!);
    }
    // Attach controller if provided
    widget.controller?._attach(this);
  }

  @override
  void dispose() {
    // Detach controller
    widget.controller?._detach();
    super.dispose();
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        
        // Notify parent widget about the picked image
        if (widget.onImagePicked != null) {
          widget.onImagePicked!(_imageFile);
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromSource(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromSource(ImageSource.camera);
                },
              ),
              if (_imageFile != null)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remove Photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _removeImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        
        if (widget.onImagePicked != null) {
          widget.onImagePicked!(_imageFile);
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
    
    if (widget.onImagePicked != null) {
      widget.onImagePicked!(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _showImagePickerOptions,
          child: CircleAvatar(
            radius: widget.radius,
            backgroundColor: widget.backgroundColor,
            child: _imageFile == null
                ? Icon(
                    Icons.add_photo_alternate,
                    color: Colors.white,
                    size: widget.radius * 0.875, // Proportional icon size
                  )
                : ClipOval(
                    child: Image.file(
                      _imageFile!,
                      width: widget.radius * 2,
                      height: widget.radius * 2,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Add Photo",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
