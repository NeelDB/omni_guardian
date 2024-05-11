import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omni_guardian/components/my_app_bar.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  List<Map<String, String>> images = [
    {
      'img': 'https://example.com/image1.jpg',
      'caption': 'Caption for Image 1',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Gallery'),
      body: images.isEmpty? const Center(
        child: Text(
          'No images yet',
          style: TextStyle(fontSize: 18.0),
        ),
      ) : SingleChildScrollView(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // You can add onTap functionality here, like showing full-size image
                    // or navigating to another page.
                  },
                  child: Image.network(
                    images[index][1]!,
                    fit: BoxFit.cover,
                  ),
                );
              },

        ),
      ),
    );
  }
}