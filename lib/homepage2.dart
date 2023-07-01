// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_recepten_app/add_recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'classes.dart';

import 'show_categories.dart';
import 'recipe_info.dart';
import 'favorites.dart';

class MyHomePage extends StatefulWidget {
  final List<Recipe> recipes;

  MyHomePage({required this.recipes});

  @override
  HomePageState createState() => HomePageState();
}

enum SearchState {
  hidden,
  visible,
}

class HomePageState extends State<MyHomePage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Recipe? randomRecipe;
  List<Recipe> filteredRecipes = [];

  Future<List<Category>> _loadCategories() async {
    final categoriesSnapshot =
        await _databaseReference.child('categories').once();
    final dynamic data = categoriesSnapshot.snapshot.value;

    if (data is List) {
      final List<Category> loadedCategories = data.map((categoryData) {
        return Category(
          name: categoryData['name'],
          imageUrl: categoryData['imageUrl'],
        );
      }).toList();

      return loadedCategories;
    }

    return [];
  }

  static Future<List<Recipe>> fetchRecipes() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final recipesSnapshot = await databaseReference.child('recipes').once();

    final dynamic data = recipesSnapshot.snapshot.value;
    if (data is Map) {
      final List<Recipe> loadedRecipes = [];
      data.forEach((recipeId, recipeData) {
        final recipe = Recipe(
          name: recipeData['name'],
          imageUrl: recipeData['imageUrl'],
          categories: List<String>.from(recipeData['categories'] ?? []),
          ingredients: List<String>.from(recipeData['ingredients'] ?? []),
          steps: List<String>.from(recipeData['steps'] ?? []),
        );
        loadedRecipes.add(recipe);
      });
      return loadedRecipes;
    }

    return [];
  }

  double iconSize = 20.0;
  SearchState searchState = SearchState.hidden;

  // Generate a random recipe from the list of recipes
  Recipe _generateRandomRecipe(List<Recipe> recipes) {
    final random = Random();
    return recipes[random.nextInt(recipes.length)];
  }

  void filterRecipes(String query) {
    setState(() {
      filteredRecipes = widget.recipes
          .where((recipe) =>
              recipe.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();

    // Initialize the randomRecipe object with a default value
    randomRecipe = widget.recipes.isNotEmpty
        ? _generateRandomRecipe(widget.recipes)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    if (deviceWidth < 400) {
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
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FavoritesScreen(),
                                    ),
                                  );
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
                                          ShowCategoriesScreen(),
                                    ),
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
                                      builder: (context) =>
                                          FutureBuilder<List<Category>>(
                                        future: _loadCategories(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            final categories = snapshot.data;
                                            return AddRecipeScreen(
                                                categories: categories);
                                          }
                                        },
                                      ),
                                    ),
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
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter your search',
                              hintStyle: TextStyle(fontSize: 12),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              filterRecipes(value);
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      // Popular recipe section
                      Text(
                        'Popular recipe:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (filteredRecipes.isEmpty)
                        GestureDetector(
                          onTap: () async {
                            if (randomRecipe != null) {
                              // Navigate to the recipe info screen of the random recipe
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeInfoScreen(recipe: randomRecipe!),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Image.network(
                                  randomRecipe?.imageUrl ?? '',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  randomRecipe?.name ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (filteredRecipes.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe = filteredRecipes[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecipeInfoScreen(recipe: recipe),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  title: Text(recipe.name),
                                  leading: Image.network(recipe.imageUrl),
                                ),
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }).catchError((error) {
                        print('Error signing out: $error');
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FavoritesScreen(),
                                  ),
                                );
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
                                        ShowCategoriesScreen(),
                                  ),
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
                                    builder: (context) =>
                                        FutureBuilder<List<Category>>(
                                      future: _loadCategories(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          final categories = snapshot.data;
                                          return AddRecipeScreen(
                                              categories: categories);
                                        }
                                      },
                                    ),
                                  ),
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
                          onChanged: (value) {
                            filterRecipes(value);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Popular recipe section
                    Text(
                      'Popular recipe:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (filteredRecipes.isEmpty)
                      GestureDetector(
                        onTap: () async {
                          if (randomRecipe != null) {
                            // Navigate to the recipe info screen of the random recipe
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeInfoScreen(recipe: randomRecipe!),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Image.network(
                                randomRecipe?.imageUrl ?? '',
                                width: 250,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 8),
                              Text(
                                randomRecipe?.name ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (filteredRecipes.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = filteredRecipes[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RecipeInfoScreen(recipe: recipe),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(recipe.name),
                                leading: Image.network(recipe.imageUrl),
                              ),
                            );
                          },
                        ),
                      ),
                    SizedBox(height: 20),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }).catchError((error) {
                        print('Error signing out: $error');
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
