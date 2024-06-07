import 'dart:convert';

import 'package:blog_app/core/global/api_url_container.dart';
import 'package:blog_app/view/screens/home/home/inner_widgets/home_category/home_category_controller.dart';
import 'package:blog_app/view/screens/home/home/inner_widgets/home_fashion/home_fashion_model.dart';
import 'package:blog_app/view/screens/search/search_model/search_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:http/http.dart' as http;

class SearchPostController extends GetxController {
  List<HomeFashionModel> allPost = [];

  HomeCategoryController homeCategoryController =
      Get.find<HomeCategoryController>();

  List<HomeFashionModel> filterPost = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isSearch = false;

  Future<void> getSearch() async {
    isLoading = true;
    update();

    var urlName =
        "${ApiUrlContainer.baseURL}${ApiUrlContainer.search}${searchController.text}";

    try {
      http.Response response = await http.get(
        Uri.parse(urlName),
      );

      if (response.statusCode == 200) {
        allPost = [];
        final List<dynamic> data = jsonDecode(response.body);

        print("Search===========------->${data[0]}");

        // Use map method to convert each item in the list to HomeCategoryModel
        allPost = data.map((json) => HomeFashionModel.fromJson(json)).toList();



        for (int i = 0; i < allPost.length; i++) {
          var data = allPost[i];
          List<int>catID =[];

           for (var element in homeCategoryController.categoryDetails) {
             catID.add(element["id"]);
           }

          String? template;
          //List<int> categoryIds = homeCategoryController.categoryDetails[i]["id"];

          for (var categoryId in catID) {
            for (int j = 0; j < allPost[i].categories!.length; j++) {
              if (allPost[i].categories![j] == categoryId) {
                template = homeCategoryController.categoryDetails[i]["name"];

                print("====================>>>>>>>>>>>>>>>${template}");
                break; // Stop searching for template once found
              }
            }
            if (template != null) {
              break; // Stop searching for template once found
            }
          }

          //bool containsCategory = data.categories!.any((categoryId) => catID.contains(categoryId));

          filterPost.add(
              HomeFashionModel(
            id: data.id,
            date: data.date,
            slug: data.slug,
            link: data.link,
            title: data.title,
            content: data.content,
            excerpt: data.excerpt,
            template: template,
            categories: data.categories,
            yoastHeadJson: data.yoastHeadJson,
          ));
        }




        debugPrint("Length+++++++++++++++++++++++>>>>>>>>>>>>>>>>>>>${filterPost[6].template}");



        print("search=============${allPost[0].title?.rendered}");
        print("search=============${allPost[1].id}");

        print("UrlName ========================> ${urlName}");

        isSearch = true;
        update();
      } else {
        print("==================Search");
      }
    } catch (e) {
      print(e);
    }

    isLoading = false;
    update();
  }

  @override
  void onInit() {
    getSearch();
    super.onInit();
  }
}
