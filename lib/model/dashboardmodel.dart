class DashboardModel {
  double tehsil;
  double vill;
  String aqpndcount;
  String feslndcount;
  String govtlndcount;
  String reglandcount;
  String districtName;
  List<AquapondinfoChart> aquapondinfoChart;
  List<GovtlandinfoChart> govtlandinfoChart;
  List<GovtfeaslandinfoChart> govtfeaslandinfoChart;
  List<AquapondRegfarmInfo> aquapondRegfarmInfo;

  DashboardModel(
      {this.tehsil,
      this.vill,
      this.aqpndcount,
      this.feslndcount,
      this.govtlndcount,
      this.reglandcount,
      this.districtName,
      this.aquapondinfoChart,
      this.govtlandinfoChart,
      this.govtfeaslandinfoChart,
      this.aquapondRegfarmInfo});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    tehsil = json['tehsil'];
    vill = json['vill'];
    aqpndcount = json['aqpndcount'];
    feslndcount = json['feslndcount'];
    govtlndcount = json['govtlndcount'];
    reglandcount = json['reglandcount'];
    districtName = json['district_name'];
    if (json['aquapondinfo_chart'] != null) {
      aquapondinfoChart = new List<AquapondinfoChart>();
      json['aquapondinfo_chart'].forEach((v) {
        aquapondinfoChart.add(new AquapondinfoChart.fromJson(v));
      });
    }
    if (json['govtlandinfo_chart'] != null) {
      govtlandinfoChart = new List<GovtlandinfoChart>();
      json['govtlandinfo_chart'].forEach((v) {
        govtlandinfoChart.add(new GovtlandinfoChart.fromJson(v));
      });
    }
    if (json['govtfeaslandinfo_chart'] != null) {
      govtfeaslandinfoChart = new List<GovtfeaslandinfoChart>();
      json['govtfeaslandinfo_chart'].forEach((v) {
        govtfeaslandinfoChart.add(new GovtfeaslandinfoChart.fromJson(v));
      });
    }
    if (json['aquapond_regfarm_info'] != null) {
      aquapondRegfarmInfo = new List<AquapondRegfarmInfo>();
      json['aquapond_regfarm_info'].forEach((v) {
        aquapondRegfarmInfo.add(new AquapondRegfarmInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tehsil'] = this.tehsil;
    data['vill'] = this.vill;
    data['aqpndcount'] = this.aqpndcount;
    data['feslndcount'] = this.feslndcount;
    data['govtlndcount'] = this.govtlndcount;
    data['reglandcount'] = this.reglandcount;
    data['district_name'] = this.districtName;
    if (this.aquapondinfoChart != null) {
      data['aquapondinfo_chart'] =
          this.aquapondinfoChart.map((v) => v.toJson()).toList();
    }
    if (this.govtlandinfoChart != null) {
      data['govtlandinfo_chart'] =
          this.govtlandinfoChart.map((v) => v.toJson()).toList();
    }
    if (this.govtfeaslandinfoChart != null) {
      data['govtfeaslandinfo_chart'] =
          this.govtfeaslandinfoChart.map((v) => v.toJson()).toList();
    }
    if (this.aquapondRegfarmInfo != null) {
      data['aquapond_regfarm_info'] =
          this.aquapondRegfarmInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AquapondinfoChart {
  String rDistnmAqp;
  int rTotPond;
  double rSumareaAqp;

  AquapondinfoChart({this.rDistnmAqp, this.rTotPond, this.rSumareaAqp});

  AquapondinfoChart.fromJson(Map<String, dynamic> json) {
    rDistnmAqp = json['r_distnm_aqp'];
    rTotPond = json['r_tot_pond'];
    rSumareaAqp = json['r_sumarea_aqp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['r_distnm_aqp'] = this.rDistnmAqp;
    data['r_tot_pond'] = this.rTotPond;
    data['r_sumarea_aqp'] = this.rSumareaAqp;
    return data;
  }
}

class GovtlandinfoChart {
  String rDistnm;
  double rSumarea;
  double rSubfesland;

  GovtlandinfoChart({this.rDistnm, this.rSumarea, this.rSubfesland});

  GovtlandinfoChart.fromJson(Map<String, dynamic> json) {
    rDistnm = json['r_distnm'];
    rSumarea = json['r_sumarea'];
    rSubfesland = json['r_subfesland'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['r_distnm'] = this.rDistnm;
    data['r_sumarea'] = this.rSumarea;
    data['r_subfesland'] = this.rSubfesland;
    return data;
  }
}

class GovtfeaslandinfoChart {
  String rDistnm;
  double rSumarea;
  int totcount;

  GovtfeaslandinfoChart({this.rDistnm, this.rSumarea, this.totcount});

  GovtfeaslandinfoChart.fromJson(Map<String, dynamic> json) {
    rDistnm = json['r_distnm'];
    rSumarea = json['r_sumarea'];
    totcount = json['totcount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['r_distnm'] = this.rDistnm;
    data['r_sumarea'] = this.rSumarea;
    data['totcount'] = this.totcount;
    return data;
  }
}

class AquapondRegfarmInfo {
  String rDistnm;
  double rSumareaaqua;
  double rSumarearegfarm;

  AquapondRegfarmInfo({this.rDistnm, this.rSumareaaqua, this.rSumarearegfarm});

  AquapondRegfarmInfo.fromJson(Map<String, dynamic> json) {
    rDistnm = json['r_distnm'];
    rSumareaaqua = json['r_sumareaaqua'];
    rSumarearegfarm = json['r_sumarearegfarm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['r_distnm'] = this.rDistnm;
    data['r_sumareaaqua'] = this.rSumareaaqua;
    data['r_sumarearegfarm'] = this.rSumarearegfarm;
    return data;
  }
}
