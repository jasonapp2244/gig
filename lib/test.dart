import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  bool isLoading = false;
  List<dynamic> listData = [];

  Future<void> getList() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        "https://lavender-buffalo-882516.hostingersite.com/gig_app/api/get-list?page=1");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization":
              "Bearer 126|qksaUczKY1shrR6x3kng0lzCB6AMPpL41uGgtdx3fa2c6dc2",
          "Accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          listData = data['data']['data']; // inner "data" wali list
        });
      } else {
        debugPrint("Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getList(); // screen open hote hi fetch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("API List Test")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listData.length,
              itemBuilder: (context, index) {
                final item = listData[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(item['title']),
                    subtitle: Text(
                        "${item['location']} - ${item['new_price']} USD"),
                    trailing: Text(item['condition']),
                  ),
                );
              },
            ),
    );
  }
}
