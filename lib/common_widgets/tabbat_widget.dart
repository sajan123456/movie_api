// import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:movie_from_api/constants.dart';
import 'package:movie_from_api/provider/movie_provider.dart';
import 'package:movie_from_api/screens/detail_page.dart';

class TabBarWidget extends StatelessWidget {
  // const TabBarWidget({Key? key}) : super(key: key);
  final ConnectivityResult snapshot;
  TabBarWidget(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://i.pinimg.com/564x/08/f6/d1/08f6d151609e6e90a2f4daa4bad35720.jpg'),
          fit: BoxFit.cover,
        ),
        // shape: BoxShape.circle,
      ),

      // BoxDecoration(image: NetworkImage()),
      // color: Colors.black,
      child: Consumer(builder: (context, ref, child) {
        final movieData = ref.watch(movieProvider);
        if (movieData.isLoad) {
          return Center(child: CircularProgressIndicator());
        } else if (movieData.errMessage.isEmpty) {
          return NotificationListener(
            onNotification: (onNotification) {
              if (onNotification is ScrollEndNotification) {
                final before = onNotification.metrics.extentBefore;
                final max = onNotification.metrics.maxScrollExtent;
                print(before);
                if (before == max) {
                  if (snapshot == ConnectivityResult.wifi ||
                      snapshot == ConnectivityResult.mobile) {
                    ref.read(movieProvider.notifier).loadMore();
                  }

                  // print('helo');
                }
              }
              return true;
            },
            child: GridView.builder(
                // clipBehavior: Clip.antiAlias,
                itemCount: movieData.movies.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 300,
                    mainAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black87,
                    ),

                    padding: EdgeInsets.all(8),
                    // padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    // margin: EdgeInsets.only(bottom: 15),
                    // width: double.infinity,
                    // height: 600,
                    child:
                        //  Text(movieData.movies[index].overview)
                        InkWell(
                      onTap: () {
                        Get.to(DetailPage(movieData.movies[index]));
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 200,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  // placeholder: ((context, url) => Center(
                                  //       child: CircularProgressIndicator(),
                                  //     )),
                                  errorWidget: (context, url, error) =>
                                      Image.network(
                                          'https://th.bing.com/th/id/OIP.Y3e-Gg5_ia3wRVJy86PvswHaHa?pid=ImgDet&rs=1'),
                                  imageUrl: movieData.movies[index].poster_path,
                                  fit: BoxFit.fitWidth,
                                ),
                              )),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movieData.movies[index].title,
                                        // maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 214, 214, 214)),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            movieData.movies[index]
                                                    .release_date +
                                                ' |',
                                            style: TextStyle(
                                                // color: Colors.black54,
                                                fontSize: 10,
                                                color: kDescTextColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            movieData
                                                .movies[index].vote_average,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.teal),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  // Text(
                                  //   movieData.movies[index].overview,
                                  //   maxLines: 4,
                                  //   style: TextStyle(color: kDescTextColor),
                                  // ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
        } else {
          if (movieData.errMessage == 'Search Not Found !!') {
            return Expanded(
              child: Container(
                // width: double.infinity,

                color: Colors.black,
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Try other keywords',
                      style: TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          ref.refresh(movieProvider.notifier);
                        },
                        child: Text('Refresh'))
                  ],
                ),
              ),
            );
          } else {
            if (movieData.errMessage == 'No Internet.') {
              if (snapshot != ConnectivityResult.none) {
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  ref.read(movieProvider.notifier).getMovieData();
                });
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot == ConnectivityResult.none
                        ? 'No Internet'
                        : 'Online',
                    style: TextStyle(color: Colors.white),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        ref.read(movieProvider.notifier).getMovieData();
                      },
                      child: Text('Refresh'))
                ],
              );
            }
            return Center(
              child: Expanded(
                child: Container(
                  // width: double.infinity,

                  color: Colors.black,
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      movieData.errMessage,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          }
        }
      }),
    );
  }
}
