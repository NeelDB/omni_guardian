import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omni_guardian/components/my_app_bar.dart';
import 'package:omni_guardian/storage/storage.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  List<Map<String, dynamic>> images = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Map<String, dynamic> lastAlert = await Storage.getAlert();
    images.add(lastAlert);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Gallery'),
      body: images.isEmpty? const Center(
        child: Text(
          'No images yet',
          style: TextStyle(fontSize: 18.0),
        ),
      ) : GridView.builder(
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
                    images[0]['imgBytes'],
                    fit: BoxFit.cover,
                  ),
                );
              },

        ),
    );
  }
}