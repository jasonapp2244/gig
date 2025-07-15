import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/routes/routes_name.dart';
import '../../../../res/colors/app_color.dart';

class EmployerScreen extends StatefulWidget {
  const EmployerScreen({super.key});

  @override
  State<EmployerScreen> createState() => _EmployerScreenState();
}

class _EmployerScreenState extends State<EmployerScreen> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, String>> companies = [
    {
      'name': 'Google Inc.',
      'salary': '\$500 - \$1,000',
      'location': 'Medan, Indonesia',
      'logo': 'https://logo.clearbit.com/google.com',
      // 'logo':
      //     'https://upload.wikimedia.org/wikipedia/commons/2/2f/Google_2015_logo.svg',
    },
    {
      'name': 'Facebook Ltd.',
      'salary': '\$800 - \$1,200',
      'location': 'Jakarta, Indonesia',
      'logo': 'https://logo.clearbit.com/facebook.com',

      // 'logo':
      //     'https://upload.wikimedia.org/wikipedia/commons/5/51/Facebook_f_logo_%282019%29.svg',
    },
    {
      'name': 'Amazon Co.',
      'salary': '\$600 - \$1,100',
      'location': 'Bandung, Indonesia',
      'logo': 'https://logo.clearbit.com/amazon.com',

      // 'logo':
      //     'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
    },
  ];

  List<Map<String, String>> filteredCompanies = [];

  @override
  void initState() {
    super.initState();
    filteredCompanies = companies;
  }

  void filterCompanies(String query) {
    setState(() {
      filteredCompanies = companies.where((company) {
        final name = company['name']!.toLowerCase();
        final salary = company['salary']!.toLowerCase();
        final location = company['location']!.toLowerCase();
        final input = query.toLowerCase();

        return name.contains(input) ||
            salary.contains(input) ||
            location.contains(input);
      }).toList();
    });
  }

  Widget buildCompanyBlock(Map<String, String> company) {
    return InkWell(
      onTap: () {
        print('Company clicked: ${company['name']}');
        Get.toNamed(RoutesName.employerDetailScreen);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Logo
            Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: ClipOval(
                child: Image.network(company['logo']!, fit: BoxFit.contain),
              ),
            ),
            SizedBox(width: 12),

            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company['name']!,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 16, color: Colors.white60),
                      SizedBox(width: 4),
                      Text(
                        company['salary']!,
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.business_center,
                        size: 16,
                        color: Colors.white60,
                      ),
                      SizedBox(width: 4),
                      Text(
                        company['location']!,
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.appBodyBG,
        centerTitle: true,
        title: Text(
          "Employer Info",
          style: TextStyle(color: AppColor.secondColor, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.primeColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              onChanged: filterCompanies,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by company, salary or location',
                hintStyle: TextStyle(color: Colors.white60),
                filled: true,
                fillColor: AppColor.grayColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white54),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.white60),
              ),
            ),
            SizedBox(height: 20),

            // Company List
            Expanded(
              child: ListView.builder(
                itemCount: filteredCompanies.length,
                itemBuilder: (context, index) {
                  return buildCompanyBlock(filteredCompanies[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
