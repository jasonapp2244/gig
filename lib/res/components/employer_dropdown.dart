import 'package:flutter/material.dart';
import 'package:gig/res/fonts/app_fonts.dart';
import '../colors/app_color.dart';

class EmployerDropdown extends StatefulWidget {
  final TextEditingController controller;
  final List<Map<String, dynamic>> employers;
  final List<Map<String, dynamic>> filteredEmployers;
  final Function(String) onSearchChanged;
  final Function(String) onDeleteEmployer;
  final bool isLoading;

  const EmployerDropdown({
    Key? key,
    required this.controller,
    required this.employers,
    required this.filteredEmployers,
    required this.onSearchChanged,
    required this.onDeleteEmployer,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<EmployerDropdown> createState() => _EmployerDropdownState();
}

class _EmployerDropdownState extends State<EmployerDropdown> {
  final TextEditingController searchController = TextEditingController();
  bool showResults = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();

    // Initialize searchController with the main controller's value
    if (widget.controller.text.isNotEmpty) {
      searchController.text = widget.controller.text;
    }

    // Listen to changes in the main controller
    widget.controller.addListener(_onMainControllerChanged);

    searchController.addListener(_onSearchControllerChanged);
  }

  void _onMainControllerChanged() {
    if (!_disposed &&
        mounted &&
        widget.controller.text != searchController.text) {
      searchController.text = widget.controller.text;
    }
  }

  void _onSearchControllerChanged() {
    if (!_disposed && mounted) {
      widget.onSearchChanged(searchController.text);
      setState(() {
        showResults = searchController.text.isNotEmpty;
      });
    }
  }

  void _selectEmployer(String employerName) {
    if (!_disposed && mounted) {
      // Ensure both controllers are updated
      widget.controller.text = employerName;
      searchController.text = employerName;
      setState(() {
        showResults = false;
      });
      print('✅ Employer selected: $employerName');
      print('🔍 Main controller value: "${widget.controller.text}"');
    }
  }

  void _useCustomEmployer() {
    if (!_disposed && mounted) {
      final customEmployer = searchController.text.trim();
      if (customEmployer.isNotEmpty) {
        widget.controller.text = customEmployer;
        setState(() {
          showResults = false;
        });
        print('✅ Custom employer set: $customEmployer');
        print('🔍 Main controller value: "${widget.controller.text}"');
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    widget.controller.removeListener(_onMainControllerChanged);
    searchController.removeListener(_onSearchControllerChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search TextField
        TextField(
          cursorColor: AppColor.whiteColor,
          style: const TextStyle(color: Colors.white),
          controller: searchController,

          decoration: InputDecoration(
            hintStyle: const TextStyle(
              color: Colors.white60,
              fontFamily: AppFonts.appFont,
            ),
            filled: true,
            fillColor: AppColor.grayColor,
            hintText: 'Employer Name',
            suffix: const Icon(Icons.search, color: Colors.white60),

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

            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 17,
            ),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              _useCustomEmployer();
            }
          },
          onChanged: (value) {
            // Update main controller when user types
            if (!_disposed && mounted && value.trim().isNotEmpty) {
              widget.controller.text = value;
            }
          },

          onTap: () {
            setState(() {
              showResults = searchController.text.isNotEmpty;
            });
          },
        ),

        // Results container
        if (showResults)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Loading indicator
                if (widget.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (widget.filteredEmployers.isEmpty &&
                    widget.employers.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No employers available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else if (widget.filteredEmployers.isEmpty &&
                    widget.employers.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Search Employeer',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                else
                  // Employers list
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        // Custom employer option (if search text doesn't match any existing employer)
                        if (searchController.text.isNotEmpty &&
                            !widget.filteredEmployers.any((employer) {
                              final name =
                                  (employer['employer_name'] ??
                                          employer['name'] ??
                                          '')
                                      .toString()
                                      .toLowerCase();
                              return name ==
                                  searchController.text.toLowerCase();
                            }))
                          _buildCustomEmployerItem(),
                        // Existing employers
                        ...widget.filteredEmployers
                            .map((employer) => _buildEmployerItem(employer))
                            .toList(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCustomEmployerItem() {
    return InkWell(
      onTap: _useCustomEmployer,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          color: Colors.blue.shade50,
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_circle_outline,
              color: AppColor.primeColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Use "${searchController.text}" as new employer',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.primeColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Add as custom employer',
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployerItem(Map<String, dynamic> employer) {
    // Get employer name with better fallback logic
    String employerName = '';
    if (employer['employer_name'] != null &&
        employer['employer_name'].toString().isNotEmpty) {
      employerName = employer['employer_name'].toString();
    } else if (employer['name'] != null &&
        employer['name'].toString().isNotEmpty) {
      employerName = employer['name'].toString();
    } else if (employer['company'] != null &&
        employer['company'].toString().isNotEmpty) {
      employerName = employer['company'].toString();
    } else {
      // If no valid name found, skip this item
      return const SizedBox.shrink();
    }

    final employerId = employer['id']?.toString() ?? '';

    return InkWell(
      onTap: () => _selectEmployer(employerName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColor.grayColor,
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                employerName,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            // Delete button
            if (employerId.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _showDeleteConfirmation(employerName, employerId);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.red.shade600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String employerName, String employerId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Employer'),
          content: Text('Are you sure you want to delete "$employerName"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDeleteEmployer(employerId);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
