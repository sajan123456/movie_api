import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/get_core.dart';
import 'package:movie_from_api/api.dart';
import 'package:movie_from_api/common_widgets/tabbat_widget.dart';
import 'package:movie_from_api/provider/movie_provider.dart';
import 'package:movie_from_api/screens/searchpage.dart';
// import 'dart:html';

final searchController = TextEditingController();

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
            // appBar: AppBar(
            //   toolbarHeight: 100,
            //   backgroundColor: Colors.white,
            //   elevation: 0,

            // ),
            body: StreamBuilder<ConnectivityResult>(
                stream: Connectivity().onConnectivityChanged,
                builder: (context, snapshot) {
                  return Container(
                    child: Column(children: [
                      Stack(
                        children: [
                          ImageSlideshow(
                            /// Width of the [ImageSlideshow].
                            width: double.infinity,

                            /// Height of the [ImageSlideshow].
                            height: 150,

                            /// The page to show when first creating the [ImageSlideshow].
                            initialPage: 0,

                            /// The color to paint the indicator.
                            indicatorColor: Colors.blue,

                            /// The color to paint behind th indicator.
                            indicatorBackgroundColor: Colors.grey,

                            /// The widgets to display in the [ImageSlideshow].
                            /// Add the sample image file into the images folder
                            children: [
                              // Image.network(
                              //   imageWatcher.movies[0].poster_path,
                              // ),
                              // Image.network(imageWatcher.movies[1].poster_path),
                              // Image.network(imageWatcher.movies[2].poster_path),
                              // Image.network(imageWatcher.movies[3].poster_path),
                              // Image.network(imageWatcher.movies[4].poster_path),
                              Image.network(
                                'https://th.bing.com/th/id/R.c7a8c47b50f7d85b938b500513490d0d?rik=ayYD%2bLici602zQ&riu=http%3a%2f%2fdigitalspyuk.cdnds.net%2f13%2f16%2f640x320%2flandscape_movies_thor2_poster.jpg&ehk=qzEu56aAYTJdYM7fbyEQJQwuIxQWKBqDb3R5WABR8q4%3d&risl=&pid=ImgRaw&r=0',
                                fit: BoxFit.cover,
                              ),
                              Image.network(
                                'https://th.bing.com/th/id/OIP.hU4TlvObwilNahL8ch-6bgHaEK?pid=ImgDet&rs=1',
                                fit: BoxFit.cover,
                              ),
                              Image.network(
                                'https://www.filmofilia.com/wp-content/uploads/2009/07/shutter-island-b.jpg',
                                fit: BoxFit.cover,
                              ),
                              Image.network(
                                'https://th.bing.com/th/id/OIP.htgIxeP0qhwBDxpdHrp-AAAAAA?pid=ImgDet&w=460&h=153&rs=1',
                                fit: BoxFit.cover,
                              ),
                            ],

                            /// Called whenever the page in the center of the viewport changes.
                            // onPageChanged: (value) {
                            //   print('Page changed: $value');
                            // },

                            /// Auto scroll interval.
                            /// Do not auto scroll with null or 0.
                            autoPlayInterval: 6000,

                            /// Loops back to first slide.
                            isLoop: true,
                          ),
                          Positioned(
                              right: 5,
                              child: Container(
                                  width: 200,
                                  height: 35,
                                  padding: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color:
                                          Color.fromARGB(169, 107, 107, 123)),
                                  child:
                                      Consumer(builder: (context, ref, child) {
                                    final searchWatch =
                                        ref.watch(movieProvider);
                                    return TextFormField(
                                      controller: searchController,
                                      onFieldSubmitted: (value) {
                                        if (value.isEmpty) {
                                          Get.defaultDialog(
                                              title: 'Empty ',
                                              content:
                                                  Text('Nothing to search'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: Text('Ok'))
                                              ]);
                                        } else {
                                          ref
                                              .read(movieProvider.notifier)
                                              .searchMovie(value);
                                          searchController.clear();
                                        }
                                      },
                                      // onTap: () {
                                      //   // Get.to(SearchPage());
                                      //   // Get.to(() => SearchPage());
                                      // },
                                      decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.search,
                                            color: Color.fromARGB(
                                                255, 197, 197, 197),
                                          ),
                                          hintText: 'Search',
                                          hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 197, 197, 197))),
                                    );
                                  }))),
                        ],
                      ),

                      // TextFormField(
                      //   decoration: InputDecoration(
                      //       hintText: 'Search Movie',
                      //       contentPadding: EdgeInsets.all(10)),
                      // ),

                      Consumer(builder: (context, ref, child) {
                        final movieData = ref.watch(movieProvider);
                        return Container(
                          color: Colors.black,
                          width: double.infinity,
                          child: TabBar(
                              onTap: (value) {
                                if (value == 1) {
                                  ref
                                      .read(movieProvider.notifier)
                                      .updateApi(Api.topRatedMovieApi);
                                } else if (value == 2) {
                                  ref
                                      .read(movieProvider.notifier)
                                      .updateApi(Api.upcomingMovieApi);
                                } else {
                                  ref
                                      .read(movieProvider.notifier)
                                      .updateApi(Api.popularMovieApi);
                                }
                              },
                              // physics: NeverScrollableScrollPhysics(),
                              indicator: BoxDecoration(
                                  color: Color.fromARGB(255, 231, 21, 6)),
                              tabs: [
                                Tab(
                                  text: 'Popular',
                                ),
                                Tab(
                                  text: 'Top Rated',
                                ),
                                Tab(
                                  text: 'Upcoming',
                                ),
                              ]),
                        );
                      }),
                      Expanded(
                          child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                            TabBarWidget(snapshot.data!),
                            TabBarWidget(snapshot.data!),
                            TabBarWidget(snapshot.data!),
                          ]))
                    ]),
                  );
                })),
      ),
    );
  }
}
