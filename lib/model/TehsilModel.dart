class TehsilModel {
  String text;
  String value;
  TehsilModel({this.text, this.value});
  TehsilModel.fromJSON(Map<String, dynamic> json)
      : text = json['text'],
        value = json['value'].toString();

  Map<String, dynamic> toJSON() => {
        'text': text,
        'value': value,
      };
}
