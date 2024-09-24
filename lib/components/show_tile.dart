import 'package:flutter/material.dart';

class NetflixRotatingCards extends StatefulWidget {
  @override
  _NetflixRotatingCardsState createState() => _NetflixRotatingCardsState();
}

class _NetflixRotatingCardsState extends State<NetflixRotatingCards> {
  PageController _pageController = PageController(viewportFraction: 0.6);
  double currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Netflix-Style Card Carousel"),
      ),
      body: Center(
        child: PageView.builder(
          controller: _pageController,
          itemCount: 10, // Adjust as needed
          itemBuilder: (context, index) {
            return _buildRotatingCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildRotatingCard(int index) {
    // Calculate how far each card is from the center
    double scale = (1 - ((currentPage - index).abs() * 0.3)).clamp(0.0, 1.0);
    double angle = (currentPage - index).clamp(-1.0, 1.0);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Perspective
        ..rotateY(angle * 0.5), // Rotate slightly
      child: Opacity(
        opacity: scale.clamp(0.5, 1.0), // Fade effect for side cards
        child: Transform.scale(
          scale: scale, // Scale based on distance from center
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 200,
              height: 300,
              child: Center(
                child: Text(
                  'Card $index',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
