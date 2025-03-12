class PicCard {
  final String imagePath;
  final String name;

  const PicCard({
    required this.imagePath,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PicCard &&
          runtimeType == other.runtimeType &&
          imagePath == other.imagePath &&
          name == other.name;

  @override
  int get hashCode => imagePath.hashCode ^ name.hashCode;
}