enum ProcessedFileType {
  resized('Resized Image'),
  compressed('Compressed Image'),
  pdf('PDF');

  const ProcessedFileType(this.label);

  final String label;
}
