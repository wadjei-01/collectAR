class Categories {
  final Map<int, String> _categoryKey = {
    1: "Accent Furniture",
    2: "Bedroom",
    3: 'Desks',
    4: 'Home Office Furniture',
    5: "Kids Furniture",
    6: "Outdoor Furniture",
    7: "Seating",
    8: "Wardrobes",
    9: "Tables",
  };

  String? getCatName(int number) {
    return _categoryKey[number];
  }
}
