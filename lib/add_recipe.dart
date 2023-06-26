import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _recipeName;
  List<String> _selectedCategories = [];
  List<String> _allCategories = [
    'Vegan',
    'Lunch-meal',
    'Category 3',
    'Category 4'
  ]; // Replace with your actual category list
  List<String> _steps = [];
  File? _imageFile;
  File? _selectedImage;

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

  Future<void> _uploadImage(String recipeId) async {
    if (_imageFile != null) {
      final storageRef =
          FirebaseStorage.instance.ref().child('recipe_images/$recipeId.jpg');
      await storageRef.putFile(_imageFile!);
    }
  }

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save the recipe to the database
      final recipeRef = FirebaseDatabase.instance.ref().child('recipes').push();
      final recipeId = recipeRef.key;

      // Upload the image to Firebase Storage
      await _uploadImage(recipeId!);

      // Create the recipe data object
      final recipeData = {
        'name': _recipeName,
        'categories': _selectedCategories,
        'steps': _steps,
        // Add more fields as needed
      };

      // Save the recipe data to the database
      await recipeRef.set(recipeData);

      // Navigate back to the previous screen
      Navigator.pop(context);
    }
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

  @override
  Widget build(BuildContext context) {
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
                  decoration: InputDecoration(labelText: 'Naam van gerecht'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vul de naam van het gerecht in.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _recipeName = value;
                  },
                ),
                Text(
                  'Categories',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8.0,
                  children: _allCategories.map((category) {
                    final bool isSelected =
                        _selectedCategories.contains(category);
                    final Color categoryColor = _getCategoryColor(category);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedCategories.remove(category);
                          } else {
                            _selectedCategories.add(category);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: isSelected ? categoryColor : Colors.grey[300],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
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
                  child: Text('Upload foto'),
                ),
                SizedBox(height: 16.0),
                _imageFile != null
                    ? Image.file(_imageFile!)
                    : Placeholder(), // Show selected image or placeholder
                SizedBox(height: 16.0),
                Text('Stappen:'),
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
                          title: Text('Voeg extra stap toe'),
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
                              child: Text('Toevoegen'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Voeg stap toe'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _saveRecipe,
                  child: Text('Sla recept op!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
