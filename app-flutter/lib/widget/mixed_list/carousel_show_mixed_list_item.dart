import 'dart:ui';
// import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobisen_app/gen/assets.gen.dart';
import 'package:mobisen_app/app_router.dart';
import 'package:mobisen_app/constants.dart';
// import 'package:mobisen_app/gen/assets.gen.dart';
// import 'package:mobisen_app/viewmodel/home_view_model.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/widget/image_loader.dart';
import 'package:mobisen_app/widget/filter_view.dart';
import 'package:mobisen_app/styles/style_const.dart';

class CarouselShowMixedListItem extends StatefulWidget {
  final List<Show> shows;

  const CarouselShowMixedListItem({super.key, required this.shows});

  @override
  State<CarouselShowMixedListItem> createState() =>
      _CarouselShowMixedListItemState();
}

class _CarouselShowMixedListItemState extends State<CarouselShowMixedListItem> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // final homeViewModel = Provider.of<HomeViewModel>(context);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final double carouselSliderWidth = MediaQuery.of(context).size.width * .66;
    final double carouselSliderHeight =
        (carouselSliderWidth * (4 / 3)) + (2 * 0.7);
    const double carouselSliderConToDirect = 15.21;
    const double carouselSliderDirectSize = 9.0;
    final double carouselSliderToTop = statusBarHeight + 57.22
        // AppSize.statusBarHeight + 57.22
        // 103.2
        ;
    // print("🔥🔥🔥🔥🔥state change");
    return Stack(
      children: [
        Positioned.fill(
            top: 0,
            left: 0,
            child: Column(
              children: [
                Transform.translate(
                  offset: const Offset(0, -36.06),
                  child: SizedBox(
                    height: 330.66,
                    width: double.infinity,
                    child:
                        // ImageLoader.cover(
                        //   url: widget.shows[_currentPage].coverUrl,
                        // )
                        widget.shows.isNotEmpty
                            ? Stack(
                                children: [
                                  // Opacity(
                                  //     opacity: .4,
                                  //     child: ImageLoader.cover(
                                  //       url:
                                  //           widget.shows[_currentPage].coverUrl,
                                  //     )),
                                  FilterView(
                                    back: Opacity(
                                        opacity: .4,
                                        child: ImageLoader.cover(
                                          url: widget
                                              .shows[_currentPage].coverUrl,
                                        )),
                                    sigma: 36.8,
                                  ),
                                  Positioned.fill(
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                stops: [
                                              0,
                                              .2,
                                              1.0
                                            ],
                                                colors: [
                                              Color.fromRGBO(0, 0, 0, 1),
                                              Color.fromRGBO(0, 0, 0, .2),
                                              Color.fromRGBO(0, 0, 0, 0),
                                            ])),
                                      ))
                                ],
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        Assets.images.homeHeadbg.image().image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                  ),
                )
              ],
            )),
        Container(
            // color: Colors.red,
            padding: EdgeInsets.only(top: carouselSliderToTop, bottom: 8.05),
            child: Column(children: [
              CarouselSlider(
                options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                      // homeViewModel.changeCarouselImageUrl(
                      //     url: widget.shows[index].coverUrl);
                    },
                    autoPlay: widget.shows.length > 1,
                    autoPlayInterval: const Duration(seconds: 6),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 400),
                    height: carouselSliderHeight,
                    aspectRatio: 1,
                    viewportFraction: 0.7,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.6,
                    enlargeStrategy: CenterPageEnlargeStrategy.zoom),
                items: widget.shows.asMap().entries.map((entry) {
                  final show = entry.value;
                  final index = entry.key;
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.show,
                              arguments: CommonArgs(showId: show.showId));
                        },
                        child: Stack(alignment: Alignment.center, children: [
                          // Container(
                          //   color: Colors.red,
                          // ),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Opacity(
                                            opacity: index == _currentPage
                                                ? 1.0
                                                : .6,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    // color: Colors.blue,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    border: Border.all(
                                                        width: 0.7,
                                                        color: Colors.white
                                                            .withOpacity(.3))),
                                                alignment: Alignment.center,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: SizedBox(
                                                        // color: Colors.purpleAccent,
                                                        width:
                                                            carouselSliderWidth,
                                                        // height: 351.7 - 2 * 0.7,
                                                        child: AspectRatio(
                                                          aspectRatio: 3 / 4,
                                                          child:
                                                              ImageLoader.cover(
                                                                  url: show
                                                                      .coverUrl),
                                                        )))),
                                          )
                                        ])
                                  ],
                                ),
                              )),
                          Visibility(
                            visible: index == _currentPage,
                            child: Container(
                                width: 58.0,
                                height: 58.0,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(58.0 / 2)),
                                    border: Border.all(
                                        width: 0.8, color: Colors.white)),
                                alignment: Alignment.center,
                                child: ClipOval(
                                    child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned.fill(
                                        child: Container(
                                      color:
                                          const Color.fromRGBO(0, 0, 0, 0.16),
                                    )),
                                    Container(
                                        alignment: Alignment.center,
                                        width: 58.0,
                                        height: 58.0,
                                        child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 5.5,
                                              sigmaY: 5.5,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 7.95),
                                                  child:
                                                      Assets.images.play.image(
                                                    fit: BoxFit.contain,
                                                    width: 22,
                                                  ),
                                                )
                                              ],
                                            )))
                                  ],
                                ))),
                          )
                        ]),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: carouselSliderConToDirect),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.shows.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: carouselSliderDirectSize,
                    height: carouselSliderDirectSize,
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withOpacity(.12),
                    ),
                  );
                }),
              ),
            ]))
      ],
    );
  }
}
