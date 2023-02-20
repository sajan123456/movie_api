// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:movie_from_api/provider/movie_provider.dart';

// class SearchPage extends StatelessWidget {
//   const SearchPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(child: Scaffold(
//       body: Consumer(builder: (context, ref, child) {
//         final searchData = ref.watch(searchProvider).searchMovies;
//         return Container(
//           color: Colors.black,
//           padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
//           child: Column(children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(10)),
//               child: TextFormField(
//                 onFieldSubmitted: (value) {
//                   ref.read(searchProvider).getMovieData(query: value);
//                 },
//                 decoration: InputDecoration(
//                     hintText: 'search',
//                     hintStyle: TextStyle(color: Colors.white60)),
//               ),
//             ),
//             Expanded(
//                 child: GridView.builder(
//               itemCount: searchData.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 8,
//                   mainAxisSpacing: 8,
//                   childAspectRatio: 2 / 3),
//               itemBuilder: (context, index) {
//                 return Container(
//                   child: CachedNetworkImage(
//                     imageUrl: searchData[index].poster_path,
//                     // placeholder: ((context, url) => Center(
//                     //       child: CircularProgressIndicator(),
//                     //     )),
//                     errorWidget: (context, url, error) =>
//                         // Image.asset('assests/images/no image.png'),
//                         Image.network(
//                             'https://th.bing.com/th/id/OIP.-ybun1HrUnlMaGfLtqgIAAAAAA?pid=ImgDet&rs=1'),
//                     fit: BoxFit.cover,
//                   ),
//                 );
//               },
//             ))
//           ]),
//         );
//       }),
//     ));
//   }
// }
