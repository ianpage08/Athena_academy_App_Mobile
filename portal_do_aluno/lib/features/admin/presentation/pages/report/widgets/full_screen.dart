import 'package:flutter/material.dart';

class FullscreenImagePage extends StatelessWidget {
  final String url;
  const FullscreenImagePage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: InteractiveViewer(child: Image.network(url))),
    );
  }
}