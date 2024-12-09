// Class to represent individual documents
class Document {
  String value;
  String file;

  // Constructor
  Document({
    required this.value,
    required this.file,
  });

  // Factory method to create a Document from JSON
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      value: json['value'] ?? '',
      file: json['file'] ?? '',
    );
  }

  // Method to convert a Document to JSON
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'file': file,
    };
  }
}

// Class to represent the overall data structure
class VehicleDocuments {
  String insuranceValidity;
  bool hasInspectionCertificate;
  // List<Document> documents;

  // Constructor
  VehicleDocuments({
    required this.insuranceValidity,
    required this.hasInspectionCertificate,
    // required this.documents,
  });

  // Factory method to create a VehicleDocuments instance from JSON
  factory VehicleDocuments.fromJson(Map<String, dynamic> json) {
    var documentsList = (json['documents'] as List)
        .map((doc) => Document.fromJson(doc))
        .toList();

    return VehicleDocuments(
      insuranceValidity: json['insuranceValidity'] ?? '',
      hasInspectionCertificate: json['hasInspectionCertificate'] ?? false,
      // documents: documentsList,
    );
  }

  // Method to convert a VehicleDocuments instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'insuranceValidity': insuranceValidity,
      'hasInspectionCertificate': hasInspectionCertificate,
      // 'documents': documents.map((doc) => doc.toJson()).toList(),
    };
  }
}
