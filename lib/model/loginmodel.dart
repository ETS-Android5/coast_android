class LoginModel {
  int user_id;
  String user_name;
  int dept_id;
  int user_type_id;
  String designation;
  String email_id;
  String password;
  int status;
  int user_status;
  String login_type;
  String mobile_no;

  LoginModel({
    this.user_id,
    this.user_name,
    this.dept_id,
    this.user_type_id,
    this.designation,
    this.email_id,
    this.password,
    this.status,
    this.user_status,
    this.login_type,
    this.mobile_no,
  });
  LoginModel.fromJSON(Map<String, dynamic> json)
      : user_id = json['user_id'],
        user_name = json['user_name'].toString(),
        dept_id = json['dept_id'],
        user_type_id = json['user_type_id'],
        designation = json['designation'].toString(),
        email_id = json['email_id'].toString(),
        password = json['password'].toString(),
        status = json['status'],
        user_status = json['user_status'],
        login_type = json['login_type'].toString(),
        mobile_no = json['mobile_no'].toString();

  Map<String, dynamic> toJSON() => {
        'user_id': user_id,
        'user_name': user_name,
        'dept_id': dept_id,
        'user_type_id': user_type_id,
        'designation': designation,
        'email_id': email_id,
        'password': password,
        'status': status,
        'user_status': user_status,
        'login_type': login_type,
        'mobile_no': mobile_no,
      };
}
