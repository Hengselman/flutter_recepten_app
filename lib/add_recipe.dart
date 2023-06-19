import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipeRef = FirebaseDatabase.instance.ref().child('recipes');

  String _category = '';
  String _name = '';
  Duration _duration = Duration();
  List<String> _steps = [];

  void _addRecipe() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      DatabaseReference newRecipeRef = _recipeRef.push();
      newRecipeRef.set({
        'category': _category,
        'name': _name,
        'duration': _duration.inMinutes,
        'steps': _steps,
      });

      // Reset the form
      _formKey.currentState!.reset();
      _steps.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
                onSaved: (value) => _category = value!,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a duration';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _duration = Duration(minutes: int.parse(value!)),
              ),
              SizedBox(height: 16.0),
              Text('Steps'),
              SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _steps.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_steps[index]),
                    );
                  },
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => _buildAddStepDialog(),
                  );
                },
                child: Text('Add Step'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addRecipe,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddStepDialog() {
    String newStep = '';

    return AlertDialog(
      title: Text('Add Step'),
      content: TextFormField(
        decoration: InputDecoration(labelText: 'Step'),
        onChanged: (value) => newStep = value,
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
  }
}
