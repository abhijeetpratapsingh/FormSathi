enum ResizePreset {
  passportSize('Passport Size', null),
  signatureSize('Signature Size', null),
  under50kb('Under 50KB', 50 * 1024),
  under100kb('Under 100KB', 100 * 1024),
  under200kb('Under 200KB', 200 * 1024);

  const ResizePreset(this.label, this.targetBytes);

  final String label;
  final int? targetBytes;
}
