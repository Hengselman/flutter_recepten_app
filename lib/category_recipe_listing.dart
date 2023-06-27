import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'recipe_info.dart';
import 'classes.dart';

class CategoryRecipeListingScreen extends StatefulWidget {
  final String categoryName;

  CategoryRecipeListingScreen({required this.categoryName});

  @override
  _CategoryRecipeListingScreenState createState() =>
      _CategoryRecipeListingScreenState();
}

class _CategoryRecipeListingScreenState
    extends State<CategoryRecipeListingScreen> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final recipesSnapshot = await databaseReference.child('recipes').once();

    final dynamic data = recipesSnapshot.snapshot.value;
    if (data is Map) {
      final List<Recipe> loadedRecipes = [];
      data.forEach((recipeId, recipeData) {
        final categories =
            (recipeData['categories'] as List<dynamic>).cast<String>();
        final List<String> ingredients =
            (recipeData['ingredients'] as List<dynamic>).cast<String>();
        final List<String> steps =
            (recipeData['steps'] as List<dynamic>).cast<String>();

        if (categories.contains(widget.categoryName)) {
          final recipe = Recipe(
            name: recipeData['name'],
            imageUrl: recipeData['imageUrl'],
            categories: categories,
            ingredients: ingredients,
            steps: steps,
          );
          loadedRecipes.add(recipe);
        }
      });

      setState(() {
        recipes = loadedRecipes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(
              recipes[index].imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text(recipes[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RecipeInfoScreen(recipe: recipes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
