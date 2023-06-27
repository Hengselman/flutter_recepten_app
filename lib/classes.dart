class Category {
  final String name;
  final String imageUrl;

  Category({required this.name, this.imageUrl = ''});
}

class Recipe {
  final String name;
  final String imageUrl;
  final List<String>? categories;
  final List<String>? ingredients;
  final List<String>? steps;

  Recipe({
    required this.name,
    this.imageUrl = '',
    this.categories = const [],
    this.ingredients = const [],
    this.steps = const [],
  });
}
