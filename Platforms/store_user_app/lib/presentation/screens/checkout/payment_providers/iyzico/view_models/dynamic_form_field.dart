class DynamicFormField {
  final String name;
  final String type;
  final String label;
  final bool required;
  final Map<String, dynamic> validations;
  final Map<String, String> validationMessages;
  final dynamic initialValue;
  final List<dynamic>? options; // For dropdown, radio, etc.

  DynamicFormField({
    required this.name,
    required this.type,
    required this.label,
    required this.required,
    required this.validations,
    required this.validationMessages,
    this.initialValue,
    this.options,
  });

  factory DynamicFormField.fromJson(String name, Map<String, dynamic> json) {
    return DynamicFormField(
      name: name,
      type: json['Type'] as String,
      label: json['Label'] as String,
      required: json['Required'] as bool,
      validations: json['Validations'] as Map<String, dynamic>,
      validationMessages: Map<String, String>.from(json['ValidationMessages']),
      initialValue: json['InitialValue'],
      options: json['Options'] as List<dynamic>?,
    );
  }
}
