class Category {
  final String id;
  final String name;

  Category(this.id, this.name);
}

class Categories {
  static List<Category> all() {
    final List<Category> categories = [
      Category('recent', 'Recently Used'),
      Category('custom', 'User-Defined'),
      Category('happy', 'Happy'),
      Category('cry', 'Cry'),
      Category('cute', 'Cute'),
      Category('angry', 'Angry'),
      Category('shocked', 'Shocked'),
      Category('apologizing', 'Apologizing'),
      Category('confused', 'Confused'),
      Category('hungry', 'Hungry'),
      Category('love', 'Love'),
      Category('sad', 'Sad'),
      Category('scared', 'Scared'),
    ];
    return categories;
  }
}
