enum DocumentSide {
  none('None'),
  front('Front'),
  back('Back'),
  page('Page');

  const DocumentSide(this.label);

  final String label;

  static DocumentSide fromName(String? name) {
    return DocumentSide.values.firstWhere(
      (item) => item.name == name,
      orElse: () => DocumentSide.none,
    );
  }
}
