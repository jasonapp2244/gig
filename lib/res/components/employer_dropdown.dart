import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      widget.onSearchChanged(searchController.text);
      setState(() {
        showResults = searchController.text.isNotEmpty;
      });
    });
  }

  void _selectEmployer(String employerName) {
    widget.controller.text = employerName;
    searchController.text = employerName;
    setState(() {
      showResults = false;
    });
  }

  void _useCustomEmployer() {
    final customEmployer = searchController.text.trim();
    if (customEmployer.isNotEmpty) {
      widget.controller.text = customEmployer;
    }
  }

  @override
  void dispose() {
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
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search employers or type new employer name...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _useCustomEmployer,
                    tooltip: 'Use as custom employer',
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              _useCustomEmployer();
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
              color: Colors.white,
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
                      'No employers found matching your search',
                      style: TextStyle(color: Colors.grey),
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
              color: Colors.blue.shade600,
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
                      color: Colors.blue.shade700,
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
    final employerName =
        employer['employer_name'] ??
        employer['name'] ??
        employer['company'] ??
        'Unknown';
    final employerId = employer['id']?.toString() ?? '';

    return InkWell(
      onTap: () => _selectEmployer(employerName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(employerName, style: const TextStyle(fontSize: 16)),
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
