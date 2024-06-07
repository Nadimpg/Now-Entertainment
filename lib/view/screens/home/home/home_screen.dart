import 'package:blog_app/main.dart';
import 'package:blog_app/utils/app_colors.dart';
import 'package:blog_app/utils/app_images.dart';
import 'package:blog_app/utils/app_strings.dart';
import 'package:blog_app/view/screens/home/home/inner_widgets/home_category/home_category_controller.dart';
import 'package:blog_app/view/screens/home/inner_widgets/music/home_music_section.dart';
import 'package:blog_app/view/widgets/appbar/custom_appbar.dart';
import 'package:blog_app/view/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:blog_app/view/widgets/image/custom_image.dart';
import 'package:blog_app/view/widgets/text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/helper/date_converter.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../utils/app_icons.dart';
import '../../../widgets/container/custom_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
/*  HomeCategoryPostController homeCategoryPostController =
      Get.put(HomeCategoryPostController());*/

  HomeCategoryController homeCategoryController =
      Get.find<HomeCategoryController>();

  @override
  void initState() {
    super.initState();
    homeCategoryController.fastLoad();
    homeCategoryController.controllerScroll =
        ScrollController(initialScrollOffset: 0.0);
    homeCategoryController.controllerScroll.addListener(() {
      setState(() {
        currentIndex =
            (homeCategoryController.controllerScroll.offset / itemSize).round() +
                1;

        adFive();
      });
      debugPrint("========> Scroll listen ${homeCategoryController.controllerScroll.position.pixels}");
      if (homeCategoryController.controllerScroll.position.pixels ==
          homeCategoryController.controllerScroll.position.maxScrollExtent) {
        homeCategoryController.loadMore();
      }
    });
    String url =
        "https://www.nowentertainment.net/wp-json/wp/v2/categories?page=1&per_page=25";
    homeCategoryController.getCategory(url);

    loadBannerAd();
    loadBannerAdd();
    loadBannerAddd();

    super.initState();
    print('===========controller ${currentIndex}');
  }
  final itemSize = 100.0;
  int currentIndex = 0;

  bool showBannerADD = false;


  void adFive() {
    if (currentIndex % 5 == 0) {
      setState(() {
        showBannerADD = true;
      });
    }
  }

  String title = "Books";

  BannerAd? bannerAd;
  BannerAd? bannerAdd;
  BannerAd? bannerAddd;

  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: AppStrings.bannerAdsId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {});
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }
  bool isBannerAddLoaded = false;
  List<BannerAd> bannerAds = [];
  void loadBannerAdd() {
    /*bannerAdd = BannerAd(
      adUnitId: AppStrings.bannerAddsId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(

        onAdLoaded: (add) {
          debugPrint('$add loaded.');
          setState(() {
            // bannerAdd?.load();
            bannerAdd = add as BannerAd?;
            isBannerAddLoaded = true;
          });
        },
        onAdFailedToLoad: (add, err) {
          add.dispose();
        },
      ),
    )..load();*/
    for (int i = 0; i < 20; i++) {
      // Load 10 banner ads, adjust as needed
      BannerAd bannerAdd = BannerAd(
        adUnitId: AppStrings.bannerAddsId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              // Banner ad loaded
            });
          },
          onAdFailedToLoad: (_, error) {
            print('Ad failed to load: $error');
          },
        ),
      )..load();
      bannerAds.add(bannerAdd); // Add the loaded banner ad to the list
    }
  }

  void loadBannerAddd() {
    bannerAddd = BannerAd(
      adUnitId: AppStrings.bannerAdddsId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (addd) {
          debugPrint('$addd loaded.');
          setState(() {});
        },
        onAdFailedToLoad: (addd, err) {
          addd.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    homeCategoryController.controllerScroll.dispose();
    bannerAds.forEach((bannerAdd) {
      bannerAdd.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: const NavBar(currentIndex: 0),
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
          appBarContent: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          CustomImage(
            imageSrc: 'assets/images/apple phone number logo.png',
            imageType: ImageType.png,
            size: 52,
          ),
          SizedBox()
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Column(
          children: [
            bannerAd != null
                ? SizedBox(
                    // width: bannerAd!.size.width.toDouble(),
                    height: bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: bannerAd!),
                  )
                : SizedBox(),
            SizedBox(
              height: 8.h,
            ),
            GetBuilder<HomeCategoryController>(builder: (controller) {
              if (controller.isCategoryLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      List.generate(controller.categories.length, (index) {
                    return InkWell(
                      onTap: () {
                        controller.selectedTabIndex = index;

                        controller.id[controller.selectedTabIndex];
                        controller.fastLoad();
                        // controller.getPost();

                        title = controller.categories[index].name!;

                        setState(() {});
                      },
                      child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border(
                                bottom: BorderSide(
                              width: 1,
                              color: controller.selectedTabIndex == index
                                  ? AppColors.red_500
                                  : AppColors.white,
                            )),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1E000000),
                                blurRadius: 8,
                                offset: Offset(0, -2),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: CustomText(
                            text: controller.categories[index].name.toString(),
                            color: AppColors.red_500,
                            fontWeight: FontWeight.w500,
                          )),
                    );
                  }),
                ),
              );
            }),
            SizedBox(
              height: mq.height * .02,
            ),

            /// ============ category based article ================
            Expanded(
                child: SingleChildScrollView(
                    controller: homeCategoryController.controllerScroll,
                   // physics: NeverScrollableScrollPhysics(),
                    child: GetBuilder<HomeCategoryController>(
                        builder: (controller) {
                      if (controller.isFirstLoadRunning.value) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return Obx(
                        () =>controller.AllPost.isEmpty ? Center(
                          child: CustomText(
                            text: 'No articles found',
                            color: AppColors.red_500,
                            fontSize: 16.h,
                            top: 200.h,
                          ),
                        ):
                        ListView.builder(
                         // controller: homeCategoryController.scrollController,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.AllPost.length +
                              (showBannerADD ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index % 6 == 5) {
                              // Show ad
                              int adIndex = index ~/ 6; // Calculate the index of the banner ad
                              BannerAd? bannerAdd = adIndex < bannerAds.length ? bannerAds[adIndex] : null;
                              return SizedBox(
                                height: 100,
                                child: bannerAdd != null ? AdWidget(ad: bannerAdd) : SizedBox(),
                              );
                            }
                            else {
                              if (index < controller.AllPost.value.length) {
                                var data = controller.AllPost[index];
                                return  GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.readMoreScreen,
                                        arguments: [
                                          data,
                                          data.content!.rendered.toString(),
                                          title
                                        ]);
                                  },
                                  child: CustomContainer(
                                    isDetailsDescription: true,
                                    isBookMarkImage: false,
                                    //widget.data[index].yoastHeadJson!.ogDescription.toString()
                                    //widget.data[index].yoastHeadJson!.schema!.graph![index].articleSection.toString()
                                    mediaText: title,
                                    mediaTitle:
                                        data.title!.rendered.toString() ?? " ",
                                    mediaPerson: data
                                        .yoastHeadJson!.author!.reactive
                                        .toString(),
                                    date: DateConverter.formatValidityDate(
                                        data.date.toString()),
                                    mediaTag: data.slug.toString(),
                                    mediaDescription:
                                        data.excerpt!.rendered.toString(),
                                    detailsDescription: 'Read more',
                                    onTap: () {
                                      Get.toNamed(AppRoutes.readMoreScreen,
                                          arguments: [
                                            data,
                                            data.content!.rendered.toString(),
                                            title
                                          ]);
                                      // Get.toNamed(AppRoutes.readMoreScreen,
                                      //     arguments: [
                                      //       data,
                                      //       data.content!.rendered.toString()
                                      //     ]);
                                    },
                                    content: Container(
                                      width: mq.width,
                                      height: mq.height * .28,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(data
                                                  .yoastHeadJson!
                                                  .ogImage![0]
                                                  .url
                                                  .toString()),
                                              fit: BoxFit.fill)),
                                    ),
                                    userIcon: AppIcons.user,
                                    calenderIcon: AppIcons.calendar,
                                    tagIcon: AppIcons.tag,
                                  ),
                                );
                              } else {
                                if (homeCategoryController
                                    .isLoadMoreRunning.value) {
                                  return const SizedBox(
                                    height: 50.0,
                                    width: 50.0,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }
                            }
                          },

                        ),
                      );
                    }))),
            bannerAddd != null
                ? SizedBox(
                    // width: bannerAd!.size.width.toDouble(),
                    height: bannerAddd!.size.height.toDouble(),
                    child: AdWidget(ad: bannerAddd!),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
