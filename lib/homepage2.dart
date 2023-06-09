import 'package:flutter/material.dart';

class HomePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Functionality for the search button
                    // Show search bar or perform search operation
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    // Functionality for the favorites button
                    // Navigate to the favorites page
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.category),
                  onPressed: () {
                    // Functionality for the categories button
                    // Navigate to the categories page
                  },
                ),
              ),
            ],
          ),
          // Rest of your screen content
        ],
      ),
    );
  }
}
