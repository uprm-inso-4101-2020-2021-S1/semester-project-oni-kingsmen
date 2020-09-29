import 'dart:math';

final String alphabet = "qwertyuiopsdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
final String numbers = "1234567890";
final String symbols = " !\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~";


String generatePassword(int size, int numberCount, int symbolCount){
  var rng = new Random();
  int charCount = size - numberCount - symbolCount;

  int currChars = 0;
  int currNums = 0;
  int currSyms = 0;

  String password = "";

  //determine next element
  while (currChars < charCount && (currNums < numberCount || currSyms < symbolCount)
          || (currNums < numberCount && currSyms < symbolCount)){

    switch(rng.nextInt(3)){
      case 0:
        if(currChars < charCount){
          password += alphabet[rng.nextInt(alphabet.length)];
          currChars++;
        }
        break;
      case 1:
        if(currNums < numberCount){
          password += numbers[rng.nextInt(numbers.length)];
          currNums++;
        }
        break;
      default:
        if(currSyms < symbolCount){
          password += symbols[rng.nextInt(symbols.length)];
          currSyms++;
        }
        break;
    }
  }

  while(currChars < charCount){
    password += alphabet[rng.nextInt(alphabet.length)];
    currChars++;
  }
  while(currNums < numberCount){
    password += numbers[rng.nextInt(numbers.length)];
    currNums++;
  }
  while(currSyms < symbolCount){
    password += symbols[rng.nextInt(symbols.length)];
    currSyms++;
  }

  print(password);
  return password;
}