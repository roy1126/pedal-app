class Car {
  final int carId;
  final int licenseNumber;
  final String insuranceValidity;
  final List<Document> documents;

  Car({
    required this.carId,
    required this.licenseNumber,
    required this.insuranceValidity,
    required this.documents,
  });

  // Factory constructor for creating a Car object from JSON
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carId: json['carId'],
      licenseNumber: json['licenseNumber'],
      insuranceValidity: json['insuranceValidity'],
      documents: (json['documents'] as List)
          .map((doc) => Document.fromJson(doc))
          .toList(),
    );
  }

  // Convert Car object to JSON
  Map<String, dynamic> toJson() {
    return {
      'carId': carId,
      'licenseNumber': licenseNumber,
      'insuranceValidity': insuranceValidity,
      'documents': documents.map((doc) => doc.toJson()).toList(),
    };
  }
}

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
