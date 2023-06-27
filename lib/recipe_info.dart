import 'package:flutter/material.dart';
import 'classes.dart';

class RecipeInfoScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeInfoScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              recipe.name,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Image.network(
              recipe.imageUrl,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            // Add additional widgets to display other recipe details
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the first step page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeStepScreen(recipe: recipe),
            ),
          );
        },
        child: Icon(Icons.arrow_right),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class RecipeStepScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeStepScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Get the current step index
    int currentStepIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Step ${currentStepIndex + 1}: ${recipe.steps?[currentStepIndex] ?? ''}',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (currentStepIndex > 0)
            FloatingActionButton(
              onPressed: () {
                // Navigate to the previous step
              },
              child: Icon(Icons.arrow_back),
            ),
          SizedBox(width: 16),
          if (currentStepIndex < (recipe.steps?.length ?? 0) - 1)
            FloatingActionButton(
              onPressed: () {
                // Navigate to the next step
              },
              child: Icon(Icons.arrow_forward),
            ),
          SizedBox(width: 16),
          if (currentStepIndex == (recipe.steps?.length ?? 0) - 1)
            FloatingActionButton(
              onPressed: () {
                // Return to the recipe info screen
              },
              backgroundColor: Colors.green,
              child: Icon(Icons.check, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
