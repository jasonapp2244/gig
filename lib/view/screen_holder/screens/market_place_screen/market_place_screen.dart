import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/view/screen_holder/screens/adds/crate_a_add_screen.dart';
import '../../../../res/colors/app_color.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:http/http.dart' as http;  // <-- this fixes "Undefined name 'http'"
class MarketPlaceView extends StatefulWidget {
  const MarketPlaceView({super.key});

  @override
  State<MarketPlaceView> createState() => _MarketPlaceView();
}

class _MarketPlaceView extends State<MarketPlaceView> {
  int selectedTab = 0;
  // bool _isBottomSheetShown = false;
  bool _isLoading = true;
  List<dynamic> items = [];
  int currentPage = 1;
  bool hasMore = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchItems();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Function to get user token from shared preferences
  Future<String?> _getUserToken() async {
    // Check if token exists before making API call
    String? token = await Utils.readSecureData('auth_token');
    if (token == null || token.isEmpty) {}
    return token;
  }

  Future<void> _fetchItems({bool loadMore = false}) async {
    if (!loadMore) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final token = await _getUserToken();

      if (token == null || token.isEmpty) {
        setState(() => _isLoading = false);
        Get.snackbar(
          'Error',
          'No authentication token found. Please log in again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final url = Uri.parse(
        'https://lavender-buffalo-882516.hostingersite.com/gig_app/api/get-list?page=$currentPage',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // ✅ Stronger null safety check
        final dataWrapper = jsonResponse['data'];
        if (dataWrapper != null && dataWrapper['data'] != null) {
          final List<dynamic> data = dataWrapper['data'];

          setState(() {
            if (loadMore) {
              items.addAll(data);
            } else {
              items = data;
            }

            hasMore = dataWrapper['next_page_url'] != null;
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
          Get.snackbar(
            'Error',
            'Invalid response format',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else if (response.statusCode == 401) {
        // ✅ Unauthorized → logout user
        setState(() => _isLoading = false);
        Get.snackbar(
          'Session Expired',
          'Please log in again.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        // TODO: Navigate to login screen
      } else {
        setState(() => _isLoading = false);
        Get.snackbar(
          'Error',
          'Failed to fetch items. Status: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loadMore() async {
    if (hasMore && !_isLoading) {
      setState(() {
        currentPage++;
      });
      await _fetchItems(loadMore: true);
    }
  }

  String _getImageUrl(dynamic item) {
    if (item['images'] != null && item['images'].isNotEmpty) {
      String path = item['images'][0]['path'];
      print("4321$path");
      // Check if the path is a full URL or needs to be constructed
      if (path.startsWith('http')) {
        print("asfdasf$path");
        return 'https://lavender-buffalo-882516.hostingersite.com/gig_app/storage/$path';
      } else {
        print(
          'https://lavender-buffalo-882516.hostingersite.com/gig_app/storage/$path',
        );
        return 'https://lavender-buffalo-882516.hostingersite.com/gig_app/storage/app/public/$path';
      }
    }
    // Return a placeholder image if no image is available
    return 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      floatingActionButton: FloatingActionButton(
        // onPressed: _showBottomSheet,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CreaAAddScreen()),
        ),
        backgroundColor: AppColor.primeColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
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
                    'Market Place',
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

            // Tabs + Grid in Expanded
            Expanded(
              child: Column(
                children: [
                  // Top Tab Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedTab = 0),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedTab == 0
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sell,
                                    color: selectedTab == 0
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Sell",
                                    style: TextStyle(
                                      color: selectedTab == 0
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedTab = 1),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedTab == 1
                                    ? Colors.orange
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.category,
                                    color: selectedTab == 1
                                        ? Colors.white
                                        : Colors.orange,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Categories",
                                    style: TextStyle(
                                      color: selectedTab == 1
                                          ? Colors.white
                                          : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Loading indicator or Grid View
                  Expanded(
                    child: _isLoading && items.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primeColor,
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                currentPage = 1;
                                hasMore = true;
                              });
                              await _fetchItems();
                            },
                            child: items.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.inbox,
                                          size: 64,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'No items found',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Create a new listing to get started',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  )
                                : GridView.builder(
                                    controller: _scrollController,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 0,
                                    ),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 1,
                                          crossAxisSpacing: 16,
                                          childAspectRatio: 0.75,
                                        ),
                                    itemCount: items.length + (hasMore ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index >= items.length) {
                                        return Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(
                                              color: AppColor.primeColor,
                                            ),
                                          ),
                                        );
                                      }

                                      final item = items[index];
                                      return GestureDetector(
                                        onTap: () {
                                          // Get.toNamed(
                                          //   RoutesName.singleProductScreen,
                                          //   arguments: item,
                                          // );
                                          Get.toNamed(
                                            RoutesName.detailScreenView,
                                            arguments: item,
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                _getImageUrl(item),
                                                height: 120,
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (
                                                      BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                      loadingProgress,
                                                    ) {
                                                      if (loadingProgress ==
                                                          null)
                                                        return child;
                                                      return Container(
                                                        height: 120,
                                                        color: Colors.grey[300],
                                                        child: Center(
                                                          child: CircularProgressIndicator(
                                                            value:
                                                                loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                          .cumulativeBytesLoaded /
                                                                      loadingProgress
                                                                          .expectedTotalBytes!
                                                                : null,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Container(
                                                        height: 120,
                                                        color: Colors.grey[300],
                                                        child: Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        ),
                                                      );
                                                    },
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              item['title'] ?? 'No Title',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '\$${item['new_price'] ?? '0'}',
                                              style: TextStyle(
                                                color: AppColor.primeColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              item['category'] != null
                                                  ? item['category']['category'] ??
                                                        'No Category'
                                                  : 'No Category',
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 12,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
