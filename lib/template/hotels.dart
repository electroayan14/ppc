class Hotels {
  const Hotels({
    required this.name,
    this.location = '',
    this.price = '',
    this.id = 0,
    required this.imgPath,
  });
  final String name, location;
  final String price;
  final int id;
  final String imgPath;
}
