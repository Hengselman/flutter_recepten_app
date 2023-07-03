import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

import 'classes.dart';

class AddRecipeScreen extends StatefulWidget {
  final List<Category>? categories;

  AddRecipeScreen({required this.categories});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _recipeName;
  List<String> _selectedCategories = [];
  List<Category> _allCategories = [];
  List<String> _steps = [];
  List<String> _ingredients = [];
  String _currentIngredient = '';
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _allCategories = widget.categories ?? [];
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'vegan':
        return Colors.green;
      case 'lunch-meal':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Future<void> _selectImage() async {
    // Implement image selection logic
    // Use image_picker package or any other method to select an image file
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(String recipeId) async {
    if (_selectedImage != null) {
      Reference storageRef =
          FirebaseStorage.instance.ref().child('recipe_images/$recipeId.jpg');
      UploadTask uploadTask = storageRef.putFile(_selectedImage!);
      TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});

      String imageUrl = await storageSnapshot.ref.getDownloadURL();
      return imageUrl;
    }
    return '';
  }

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save the recipe to the database
      final recipeRef = FirebaseDatabase.instance.ref().child('recipes').push();
      final recipeId = recipeRef.key;

      // Upload the image to Firebase Storage
      String imageUrl = await _uploadImage(recipeId!);

      // Create the recipe data object
      final recipeData = {
        'Id': recipeId,
        'name': _recipeName,
        'imageUrl': imageUrl,
        'categories': _selectedCategories,
        'steps': _steps,
        'ingredients': _ingredients,
        // Add more fields as needed
      };

      // Save the recipe data to the database
      await recipeRef.set(recipeData);

      // Navigate back to the previous screen
      Navigator.pop(context);
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
            title: const Text('Add Recipe'),
            titleTextStyle: TextStyle(fontSize: 18),
          ),
        ),
        body: const Center(
          child: Text(
            'Sorry, you can only add recipes via phone.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Add Recipe'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name of recipe'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter name of recipe.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _recipeName = value;
                    },
                  ),
                  Text(
                    'Categories',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _allCategories.map((category) {
                      final bool isSelected =
                          _selectedCategories.contains(category.name);
                      final Color categoryColor =
                          _getCategoryColor(category.name);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedCategories.remove(category.name);
                            } else {
                              _selectedCategories.add(category.name);
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? categoryColor : Colors.grey[300],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: _selectedCategories.map((category) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategories.remove(category);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: _selectImage,
                    child: Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image, size: 48.0, color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectImage,
                    child: Text('Upload image'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Ingredient'),
                          onChanged: (value) {
                            setState(() {
                              _currentIngredient = value;
                            });
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentIngredient.isNotEmpty) {
                            setState(() {
                              _ingredients.add(_currentIngredient);
                              _currentIngredient = '';
                            });
                          }
                        },
                        child: Text('Add ingredient'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text('Ingredients:'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = _ingredients[index];
                      return ListTile(
                        title: Text(ingredient),
                      );
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text('Steps:'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _steps.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_steps[index]),
                      );
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String newStep = '';
                          return AlertDialog(
                            title: Text('Add instruction'),
                            content: TextFormField(
                              onChanged: (value) {
                                newStep = value;
                              },
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  if (newStep.isNotEmpty) {
                                    setState(() {
                                      _steps.add(newStep);
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text('Add'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Add instruction'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _saveRecipe,
                    child: Text('Save recipe!'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
