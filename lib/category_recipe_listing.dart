import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Recipe {
  final String name;
  final String imageUrl;

  Recipe({required this.name, this.imageUrl = ''});
}

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
        final List<dynamic> categories = recipeData['categories'] ?? [];

        if (categories.contains(widget.categoryName)) {
          final recipe = Recipe(
            name: recipeData['name'],
            imageUrl: recipeData['imageUrl'],
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
          );
        },
      ),
    );
  }
}
