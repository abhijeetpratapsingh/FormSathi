enum DocumentCategory {
  passportPhoto('Passport Photo'),
  signature('Signature'),
  aadhaar('Aadhaar'),
  pan('PAN'),
  marksheet('Marksheet'),
  certificate('Certificate'),
  idProof('ID Proof'),
  other('Other');

  const DocumentCategory(this.label);

  final String label;
}
