class InsertFieldModel {
  String dist_name;
  String teh_name;
  String gp_name;
  String vill_name;
  String plot_no;
  String img;
  String lat;
  String lon;
  String remark;

  InsertFieldModel(
      {this.dist_name,
      this.teh_name,
      this.gp_name,
      this.vill_name,
      this.plot_no,
      this.img,
      this.lat,
      this.lon,
      this.remark});

  factory InsertFieldModel.fromJson(Map<String, dynamic> json) =>
      new InsertFieldModel(
          dist_name: json["dist_name"],
          teh_name: json["teh_name"],
          gp_name: json["gp_name"],
          vill_name: json["vill_name"],
          plot_no: json["plot_no"],
          img: json["img"],
          lat: json["lat"],
          lon: json["lon"],
          remark: json["remark"]);
  Map<String, dynamic> toJson() => {
        "dist_name": dist_name,
        "teh_name": teh_name,
        "gp_name": gp_name,
        "vill_name": vill_name,
        "plot_no": plot_no,
        "img": img,
        "lat": lat,
        "lon": lon,
        "remark": remark
      };
}
