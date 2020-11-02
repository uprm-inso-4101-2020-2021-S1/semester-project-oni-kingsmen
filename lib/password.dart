class Password {
  int id;
  String password;
  String account;
  String email;
  String main;
  String notes;

  Password(int id, String password, String account, String email, String main, String notes){
    this.id = id;
    this.account = account;
    this.password = password;
    this.email = email;
    this.main = main;
    this.notes = notes;
  }
}

class Question {
  int id;
  String question;
  String answer;
  bool caseSensitive;

  Question(int id, String question, String answer, bool caseSensitive){
    this.id = id;
    this.question = question;
    this.answer = answer;
    this.caseSensitive = caseSensitive;
  }
}