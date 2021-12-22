class FeasibleDataModel {
  String r_dist;
  String r_tehsil;
  String r_gp;
  String r_village;
  String r_plotno;
  String r_kisama;
  double r_area;
  FeasibleDataModel({
    this.r_dist,
    this.r_tehsil,
    this.r_gp,
    this.r_village,
    this.r_plotno,
    this.r_kisama,
    this.r_area,
  });

  FeasibleDataModel.fromJSON(Map<String, dynamic> json)
      : r_dist = json['r_dist'],
        r_tehsil = json['r_tehsil'],
        r_gp = json['r_gp'],
        r_village = json['r_village'],
        r_plotno = json['r_plotno'],
        r_kisama = json['r_kisama'],
        r_area = json['r_area'];

  Map<String, dynamic> toJSON() => {
        'r_dist': r_dist,
        'r_tehsil': r_tehsil,
        'r_gp': r_gp,
        'r_village': r_village,
        'r_plotno': r_plotno,
        'r_kisama': r_kisama,
        'r_area': r_area,
      };
}
