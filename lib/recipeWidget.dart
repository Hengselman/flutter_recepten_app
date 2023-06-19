import 'package:flutter/material.dart';

class Recipe {
  final String category;
  final String name;
  final int duration;
  final List<String> steps;

  Recipe(
      {required this.category,
      required this.name,
      required this.duration,
      required this.steps});
}

class RecipeWidget extends StatelessWidget {
  final Recipe recipe;

  RecipeWidget({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(recipe.category),
        Text(recipe.name),
        Text(recipe.duration.toString()),
        Column(
          children: recipe.steps.map((step) => Text(step)).toList(),
        ),
      ],
    );
  }
}
