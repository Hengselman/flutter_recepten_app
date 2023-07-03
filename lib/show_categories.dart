import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'classes.dart';
import 'category_recipe_listing.dart';

class ShowCategoriesScreen extends StatefulWidget {
  @override
  _ShowCategoriesScreenState createState() => _ShowCategoriesScreenState();
}

class _ShowCategoriesScreenState extends State<ShowCategoriesScreen> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final categoriesSnapshot =
        await databaseReference.child('categories').once();

    final dynamic data = categoriesSnapshot.snapshot.value;
    if (data is List) {
      final List<Category> loadedCategories = [];
      data.forEach((categoryData) {
        final category = Category(
          name: categoryData['name'],
          imageUrl: categoryData['imageUrl'],
        );
        loadedCategories.add(category);
      });

      setState(() {
        categories = loadedCategories;
      });
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
            title: Text('Categories'),
            titleTextStyle: TextStyle(fontSize: 18),
          ),
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryRecipeListingScreen(
                      categoryName: categories[index].name,
                    ),
                  ),
                );
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      categories[index].imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 4),
                    Text(
                      categories[index].name,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryRecipeListingScreen(
                      categoryName: categories[index].name,
                    ),
                  ),
                );
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      categories[index].imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 8),
                    Text(
                      categories[index].name,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
