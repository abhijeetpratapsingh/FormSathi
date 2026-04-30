enum ImageQualityOption {
  high('High', 85, null),
  medium('Medium', 65, null),
  low('Low', 45, null),
  under20kb('Under 20KB', 75, 20 * 1024),
  under50kb('Under 50KB', 75, 50 * 1024),
  under100kb('Under 100KB', 75, 100 * 1024),
  under300kb('Under 300KB', 75, 300 * 1024);

  const ImageQualityOption(this.label, this.quality, this.targetBytes);

  final String label;
  final int quality;
  final int? targetBytes;
}
