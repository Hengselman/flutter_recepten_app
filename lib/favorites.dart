import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'recipe_info.dart';
import 'classes.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<Recipe> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      final databaseReference = FirebaseDatabase.instance.ref();
      final favoritesSnapshot =
          await databaseReference.child('favorites').child(user.uid).once();

      final dynamic data = favoritesSnapshot.snapshot.value;
      if (data is Map) {
        final List<String> favoriteIds = [];
        for (final entry in data.entries) {
          if (entry.value == true) {
            favoriteIds.add(entry.key);
          }
        }

        final List<Recipe> loadedRecipes = [];

        for (final favoriteId in favoriteIds) {
          final recipeSnapshot =
              await databaseReference.child('recipes').child(favoriteId).once();

          final dynamic recipeData = recipeSnapshot.snapshot.value;
          if (recipeData != null) {
            final Recipe recipe = Recipe(
              Id: recipeData['Id'] ?? '',
              name: recipeData['name'] ?? '',
              imageUrl: recipeData['imageUrl'] ?? '',
              categories: List<String>.from(recipeData['categories'] ?? []),
              ingredients: List<String>.from(recipeData['ingredients'] ?? []),
              steps: List<String>.from(recipeData['steps'] ?? []),
            );
            loadedRecipes.add(recipe);
          }
        }

        setState(() {
          favoriteRecipes = loadedRecipes;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    final smallDevice = deviceWidth < 400;
    final titelFontSize = smallDevice ? 12.0 : 18.0;
    final titleTextStyle = TextStyle(fontSize: titelFontSize);

    if (deviceWidth < 400) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: AppBar(
            title: Text('Favorites'),
            titleTextStyle: TextStyle(fontSize: 18),
          ),
        ),
        body: ListView.builder(
          itemCount: favoriteRecipes.length,
          itemBuilder: (context, index) {
            final recipe = favoriteRecipes[index];

            return ListTile(
              leading: Image.network(
                recipe.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(recipe.name, style: titleTextStyle),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeInfoScreen(recipe: recipe),
                  ),
                );
              },
            );
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
        ),
        body: ListView.builder(
          itemCount: favoriteRecipes.length,
          itemBuilder: (context, index) {
            final recipe = favoriteRecipes[index];

            return ListTile(
              leading: Image.network(
                recipe.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(recipe.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeInfoScreen(recipe: recipe),
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }
}
