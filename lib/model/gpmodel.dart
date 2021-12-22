class GPModel {
  String text;
  String value;
  GPModel({this.text, this.value});
  GPModel.fromJSON(Map<String, dynamic> json)
      : text = json['text'],
        value = json['value'].toString();

  Map<String, dynamic> toJSON() => {
        'text': text,
        'value': value,
      };
}