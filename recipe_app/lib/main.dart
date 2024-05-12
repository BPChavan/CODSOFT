import 'package:flutter/material.dart';

void main() {
  runApp(RecipeApp());
}

class Recipe {
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
  });
}

class RecipeApp extends StatelessWidget {
  final List<Recipe> recipes = [
    Recipe(
      title: 'Spaghetti Carbonara',
      description: 'Classic Italian pasta dish with eggs, bacon, and cheese',
      ingredients: [
        'Spaghetti',
        'Eggs',
        'Bacon',
        'Parmesan Cheese',
        'Salt',
        'Pepper'
      ],
      instructions: [
        'Cook spaghetti according to package instructions.',
        'In a bowl, whisk eggs, grated Parmesan cheese, salt, and pepper.',
        'In a pan, cook bacon until crispy, then remove excess grease.',
        'Add cooked spaghetti to the pan, mix well, then pour in the egg mixture, stirring quickly to coat the spaghetti evenly.',
        'Serve immediately with additional grated Parmesan cheese on top.'
      ],
    ),
    Recipe(
      title: 'Chicken Alfredo',
      description:
          'Creamy pasta dish with chicken, garlic, and Parmesan cheese',
      ingredients: [
        'Chicken Breast',
        'Fettuccine',
        'Heavy Cream',
        'Parmesan Cheese',
        'Garlic',
        'Butter'
      ],
      instructions: [
        'Cook fettuccine according to package instructions.',
        'Season chicken breasts with salt and pepper, then cook in a skillet until golden brown and fully cooked.',
        'In the same skillet, melt butter and sauté minced garlic until fragrant.',
        'Pour in heavy cream and let it simmer until slightly thickened.',
        'Add grated Parmesan cheese and cooked fettuccine to the skillet, tossing until the pasta is coated in the sauce.',
        'Slice the cooked chicken breasts and serve over the Alfredo pasta.'
      ],
    ),
  ];

  RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        hintColor: Colors.amber,
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Recipes'),
          centerTitle: true,
          elevation: 0,
        ),
        body: RecipeList(recipes: recipes),
      ),
    );
  }
}

class RecipeList extends StatefulWidget {
  final List<Recipe> recipes;

  const RecipeList({super.key, required this.recipes});

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  late List<Recipe> displayedRecipes;

  @override
  void initState() {
    super.initState();
    displayedRecipes = widget.recipes;
  }

  void filterRecipes(String query) {
    setState(() {
      displayedRecipes = widget.recipes
          .where((recipe) =>
              recipe.title.toLowerCase().contains(query.toLowerCase()) ||
              recipe.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onChanged: filterRecipes,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: displayedRecipes.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    displayedRecipes[index].title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(displayedRecipes[index].description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailScreen(recipe: displayedRecipes[index]),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.ingredients.map((ingredient) {
                return Text('• $ingredient');
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.instructions.asMap().entries.map((entry) {
                int index = entry.key + 1;
                String instruction = entry.value;
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: Text('$index.'),
                  title: Text(instruction),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
