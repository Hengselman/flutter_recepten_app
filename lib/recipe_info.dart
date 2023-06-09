import 'package:flutter/material.dart';
import 'classes.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RecipeInfoScreen extends StatefulWidget {
  final Recipe recipe;

  RecipeInfoScreen({required this.recipe});

  @override
  _RecipeInfoScreenState createState() => _RecipeInfoScreenState();
}

class _RecipeInfoScreenState extends State<RecipeInfoScreen> {
  bool isFavorite = false;
  late String userUid;
  final DatabaseReference favoritesRef =
      FirebaseDatabase.instance.ref().child('favorites');

  // Get the current step index
  int currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    // Check if the recipe is already in the user's favorites
    // You can use your database logic here to determine the initial state
    getUserUid();
    checkFavorite();
  }

  void getUserUid() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userUid = user.uid;
    }
  }

  void checkFavorite() {
    favoritesRef.child(userUid).child(widget.recipe.Id).onValue.listen(
      (event) {
        DataSnapshot snapshot = event.snapshot;

        setState(() {
          isFavorite = snapshot.value != null;
        });
      },
      onError: (error) {
        print('Error checking if recipe is in favorites: $error');
      },
    );
  }

  void toggleFavorite() {
    if (!mounted) return; // Check if the widget is still mounted

    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      // Add the recipe ID to the user's favorites
      favoritesRef.child(userUid).child(widget.recipe.Id).set(true).then((_) {
        print('Recipe added to favorites');
      }).catchError((error) {
        print('Error adding recipe to favorites: $error');
      });
    } else {
      // Remove the recipe ID from the user's favorites
      favoritesRef.child(userUid).child(widget.recipe.Id).remove().then((_) {
        print('Recipe removed from favorites');
      }).catchError((error) {
        print('Error removing recipe from favorites: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    if (deviceWidth < 400) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: AppBar(
            title: Text(widget.recipe.name),
            titleTextStyle: TextStyle(fontSize: 18),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(4.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 50,
                  child: Image.network(
                    widget.recipe.imageUrl,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  widget.recipe.name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ingredients',
                            style: TextStyle(
                                fontSize: 8,
                                decoration: TextDecoration.underline),
                          ),
                          SizedBox(height: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                widget.recipe.ingredients?.map((ingredient) {
                                      return Text(
                                        ingredient,
                                        style: TextStyle(fontSize: 8),
                                      );
                                    }).toList() ??
                                    [],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: toggleFavorite,
              mini: true,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              backgroundColor: Colors.pink,
              heroTag: null, // Remove the hero tag
            ),
            SizedBox(height: 2),
            FloatingActionButton(
              mini: true,
              onPressed: () {
                // Navigate to the first step page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeStepScreen(
                      recipe: widget.recipe,
                      currentStepIndex:
                          currentStepIndex, // Pass the current step index
                    ),
                  ),
                ).then((value) {
                  // Update the current step index when returning from the steps screen
                  setState(() {
                    currentStepIndex = value ?? 0;
                  });
                });
              },
              child: Icon(Icons.arrow_right),
              backgroundColor: Colors.blue,
              elevation: 0.0,
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.recipe.name),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: Image.network(
                  widget.recipe.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.recipe.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ingredients',
                          style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              widget.recipe.ingredients?.map((ingredient) {
                                    return Text(
                                      ingredient,
                                      style: TextStyle(fontSize: 18),
                                    );
                                  }).toList() ??
                                  [],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1, // Adjust the flex value for the Free block
                    child: Container(
                      color: Colors.grey, // Placeholder color for free block
                      child: Center(
                        child: Text(
                          'Free Block', // Replace with actual content
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: Container(
                  color: Colors.grey, // Placeholder color for free block
                  child: Center(
                    child: Text(
                      'Free Block', // Replace with actual content
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: toggleFavorite,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              backgroundColor: Colors.pink,
              heroTag: null, // Remove the hero tag
            ),
            SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                // Navigate to the first step page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeStepScreen(
                      recipe: widget.recipe,
                      currentStepIndex:
                          currentStepIndex, // Pass the current step index
                    ),
                  ),
                ).then((value) {
                  // Update the current step index when returning from the steps screen
                  setState(() {
                    currentStepIndex = value ?? 0;
                  });
                });
              },
              child: Icon(Icons.arrow_right),
              backgroundColor: Colors.blue,
              elevation: 0.0,
            ),
          ],
        ),
      );
    }
  }
}

class RecipeStepScreen extends StatefulWidget {
  final Recipe recipe;
  final int currentStepIndex;

  RecipeStepScreen({required this.recipe, required this.currentStepIndex});

  @override
  _RecipeStepScreenState createState() => _RecipeStepScreenState();
}

class _RecipeStepScreenState extends State<RecipeStepScreen> {
  late int currentStepIndex;

  @override
  void initState() {
    super.initState();
    currentStepIndex = widget.currentStepIndex;
  }

  void navigateToNextStep() {
    setState(() {
      currentStepIndex++;
    });
  }

  void navigateToPreviousStep() {
    setState(() {
      currentStepIndex--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final List<String>? steps = widget.recipe.steps;

    if (deviceWidth < 400) {
      if (currentStepIndex < 0 || currentStepIndex >= (steps?.length ?? 0)) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(35),
            child: AppBar(
              title: Text(widget.recipe.name),
              titleTextStyle: TextStyle(fontSize: 18),
            ),
          ),
          body: Center(
            child: Text('Invalid step index.'),
          ),
        );
      }

      String currentStep = steps?[currentStepIndex] ?? '';

      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: AppBar(
            title: Text(widget.recipe.name),
            titleTextStyle: TextStyle(fontSize: 18),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Step ${currentStepIndex + 1}: $currentStep',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        floatingActionButton: Stack(
          alignment: Alignment.topRight,
          children: [
            if (currentStepIndex > 0)
              Positioned(
                right: 80.0,
                child: FloatingActionButton(
                  onPressed: navigateToPreviousStep,
                  mini: true,
                  child: Icon(Icons.arrow_back),
                  elevation: 0.0,
                ),
              ),
            if (currentStepIndex < (steps?.length ?? 0) - 1)
              FloatingActionButton(
                onPressed: navigateToNextStep,
                mini: true,
                child: Icon(Icons.arrow_forward),
                elevation: 0.0,
              ),
            if (currentStepIndex == (steps?.length ?? 0) - 1)
              FloatingActionButton(
                onPressed: () {
                  // Return to the recipe info screen
                  Navigator.pop(context);
                },
                backgroundColor: Colors.green,
                mini: true,
                child: Icon(Icons.check, color: Colors.white),
                elevation: 0.0,
              ),
          ],
        ),
      );
    } else {
      if (currentStepIndex < 0 || currentStepIndex >= (steps?.length ?? 0)) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.recipe.name),
          ),
          body: Center(
            child: Text('Invalid step index.'),
          ),
        );
      }

      String currentStep = steps?[currentStepIndex] ?? '';

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.recipe.name),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Step ${currentStepIndex + 1}: $currentStep',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
        floatingActionButton: Stack(
          alignment: Alignment.topRight,
          children: [
            if (currentStepIndex > 0)
              Positioned(
                right: 80.0,
                child: FloatingActionButton(
                  onPressed: navigateToPreviousStep,
                  child: Icon(Icons.arrow_back),
                  elevation: 0.0,
                ),
              ),
            if (currentStepIndex < (steps?.length ?? 0) - 1)
              FloatingActionButton(
                onPressed: navigateToNextStep,
                child: Icon(Icons.arrow_forward),
                elevation: 0.0,
              ),
            if (currentStepIndex == (steps?.length ?? 0) - 1)
              FloatingActionButton(
                onPressed: () {
                  // Return to the recipe info screen
                  Navigator.pop(context);
                },
                backgroundColor: Colors.green,
                child: Icon(Icons.check, color: Colors.white),
                elevation: 0.0,
              ),
          ],
        ),
      );
    }
  }
}
