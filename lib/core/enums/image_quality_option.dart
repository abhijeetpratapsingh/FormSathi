enum ImageQualityOption {
  high('High', 85),
  medium('Medium', 65),
  low('Low', 45);

  const ImageQualityOption(this.label, this.quality);

  final String label;
  final int quality;
}
