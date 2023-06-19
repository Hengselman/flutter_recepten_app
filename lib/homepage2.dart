// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_recepten_app/add_recipe.dart';

class MyHomePage extends StatefulWidget {
  @override
  HomePage2 createState() => HomePage2();
}

enum SearchState {
  hidden,
  visible,
}

class HomePage2 extends State<MyHomePage> {
  double iconSize = 20.0;
  SearchState searchState = SearchState.hidden;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (searchState == SearchState.visible) {
          setState(() {
            searchState = SearchState.hidden;
          });
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            AnimatedCrossFade(
              duration: Duration(milliseconds: 300),
              crossFadeState: searchState == SearchState.hidden
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          iconSize = 0.0;
                          searchState =
                              SearchState.visible; // Shrink the icon size
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          iconSize = 20.0; // Restore the original icon size
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: iconSize,
                        height: iconSize,
                        child: Transform.scale(
                          scale: iconSize / 20.0,
                          child: Icon(Icons.search),
                        ),
                      ),
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddRecipeScreen()),
                        );
                      },
                      child: Container(
                        child: Center(
                          child: Icon(
                            Icons.add_circle_rounded,
                            size: iconSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              secondChild: Container(
                height: 48.0,
                color: Colors.grey[
                    200], // Customize the background color of the search bar
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your search',
                    border: InputBorder.none,
                  ),
                  // Handle the search functionality here
                  // You can use onChanged, onSubmitted, or a search button
                ),
              ),
            ),
            // Rest of your screen content
          ],
        ),
      ),
    );
  }
}
