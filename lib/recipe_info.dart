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
    );
  }
}
