enum ResizePreset {
  passportSize('Passport Size', null, 413, 531),
  signatureSize('Signature Size', null, 600, 200),
  custom('Custom', null, null, null),
  under50kb('Under 50KB', 50 * 1024, null, null),
  under100kb('Under 100KB', 100 * 1024, null, null),
  under200kb('Under 200KB', 200 * 1024, null, null),
  under300kb('Under 300KB', 300 * 1024, null, null);

  const ResizePreset(this.label, this.targetBytes, this.width, this.height);

  final String label;
  final int? targetBytes;
  final int? width;
  final int? height;
}
