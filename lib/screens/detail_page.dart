import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_from_api/movie.dart';
import 'package:movie_from_api/provider/movie_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailPage extends StatelessWidget {
  // const MyWidget({Key? key}) : super(key: key);
  final Movie movie;
  DetailPage(this.movie);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: ListView(
          children: [
            Consumer(
              builder: ((context, ref, child) {
                final keyData = ref.watch(keyProvider(movie.id));
                return Container(
                  height: 250,
                  child: keyData.when(
                      data: ((data) {
                        return YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: data,
                            flags: YoutubePlayerFlags(
                              autoPlay: false,
                            ),
                          ),
                          showVideoProgressIndicator: true,
                        );
                      }),
                      error: ((error, stackTrace) =>
                          Center(child: Text('$error'))),
                      loading: () => Container()),
                );
              }),
            ),
            Container(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview : ',
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    movie.overview,
                    style: TextStyle(
                        color: Colors.grey[300], fontSize: 12, wordSpacing: 1),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
