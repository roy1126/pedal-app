class Document {
  final String value;
  final String file;

  Document({
    required this.value,
    required this.file,
  });

  // Factory constructor for creating a Document object from JSON
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      value: json['value'],
      file: json['file'],
    );
  }

  // Convert Document object to JSON
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'file': file,
    };
  }
}
