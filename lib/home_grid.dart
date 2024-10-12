// import 'package:flutter/material.dart';
//
// import 'grade_grouped.dart';
//
// // Region model with a name and image
// class Region {
//   final String name;
//   final String imageUrl;
//   final Widget page;
//
//   Region({required this.name, required this.imageUrl,required this.page});
// }
//
// class RegionGridPage extends StatelessWidget {
//   // List of regions
//   final List<Region> regions = [
//     Region(name: 'Addis Ababa', imageUrl: 'assets/addis.png',page:AddisAbaba()),
//     Region(name: 'Oromia', imageUrl: 'assets/oromia.png',page:AddisAbaba()),
//     Region(name: 'Amhara', imageUrl: 'assets/amhara.png',page:AddisAbaba()),
//     Region(name: 'Afar', imageUrl: 'assets/afar.png',page:AddisAbaba()),
//     Region(name: 'Somali', imageUrl: 'assets/somali.png',page:AddisAbaba()),
//     // Add more regions as needed
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Region Offices'),
//       ),
//       body: GridView.builder(
//         padding: const EdgeInsets.all(10),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // Number of grid columns
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//         ),
//         itemCount: regions.length,
//         itemBuilder: (context, index) {
//           final region = regions[index];
//           return GestureDetector(
//             onTap: () {
//               // Navigate to region-specific page when tapped
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => region.page,
//                 ),
//               );
//             },
//             child: GridTile(
//               footer: GridTileBar(
//                 backgroundColor: Colors.black54,
//                 title: Text(region.name),
//               ),
//               child: Image.asset(
//                 region.imageUrl,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // Region-specific office page
// class RegionOfficePage extends StatelessWidget {
//   final Region region;
//
//   RegionOfficePage({required this.region});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${region.name} Office'),
//       ),
//       body: Center(
//         child: Text(
//           'Welcome to the ${region.name} office!',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
//
//
