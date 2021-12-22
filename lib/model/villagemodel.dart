class VillageModel {
  String text;
  String value;
  VillageModel({this.text, this.value});
  VillageModel.fromJSON(Map<String, dynamic> json)
      : text = json['text'],
        value = json['value'].toString();

  Map<String, dynamic> toJSON() => {
        'text': text,
        'value': value,
      };
}