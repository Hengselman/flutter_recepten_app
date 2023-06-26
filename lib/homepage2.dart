// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_recepten_app/add_recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'show_categories.dart';

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
    bool isPhone = MediaQuery.of(context).size.shortestSide < 600;

    return GestureDetector(
      onTap: () {
        if (searchState == SearchState.visible) {
          setState(() {
            searchState = SearchState.hidden;
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
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
                                searchState = SearchState.visible;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                iconSize = 20.0;
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShowCategoriesScreen()),
                              );
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
                      color: Colors.grey[200],
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your search',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  // Add box for random or popular recipe here
                  // Show picture of food and make it clickable.

                  SizedBox(height: 20),
                ],
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
