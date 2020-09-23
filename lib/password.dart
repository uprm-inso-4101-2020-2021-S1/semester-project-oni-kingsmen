class Password {
  String password;
  String account;
  String email;
  String main;

  Password(String password, String account, String email, String main){
    this.account = account;
    this.password = password;
    this.email = email;
    this.main = main;
  }

  Password.basic(String password, String account){
  this.password = password;
  this.account = account;
  }
}