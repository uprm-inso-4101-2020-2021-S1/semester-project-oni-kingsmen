class Password {
  String password;
  String account;
  String email;
  String main;
  String notes;

  Password(String password, String account, String email, String main, String notes){
    this.account = account;
    this.password = password;
    this.email = email;
    this.main = main;
    this.notes = notes;
  }

  Password.basic(String password, String account, String notes){
  this.password = password;
  this.account = account;
  this.notes = notes;
  }
}