// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';

// import 'backgr.dart';
// import 'home.dart';

// class ResultPage extends StatefulWidget {
//   const ResultPage({Key? key}) : super(key: key);

//   @override
//   State<ResultPage> createState() => _ResultPageState();
// }

// class _ResultPageState extends State<ResultPage> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Background(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Column(
//           children: [
//             SizedBox(height: size.height * 0.25),
//             Container(
//               height: size.height * 0.4,
//               width: size.width * 0.8,
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//               ),
//               child: Text('Output',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 42,
//                       fontWeight: FontWeight.bold)),
//             ),
//             Spacer(),
//             Center(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => HomePage()));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     elevation: 10,
//                     primary: Color(0xff166D68),
//                     padding: EdgeInsets.symmetric(
//                         horizontal: size.width * 0.25,
//                         vertical: size.height * 0.02),
//                   ),
//                   child: Text(
//                     'Done',
//                     style: TextStyle(
//                       color: Color(0xffffffff),
//                       fontWeight: FontWeight.w800,
//                       fontSize: 25,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
