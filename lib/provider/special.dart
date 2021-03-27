import 'package:flutter/foundation.dart';

class Specials extends ChangeNotifier {

bool isSignup = true;
int amount=1;
//bool productselected = false;
//bool scroll = false;
bool istextempty = true;


changeIsEmpty(v){
  istextempty=v;
  notifyListeners();
}
changeSignup(bool v){
  isSignup=v;
  notifyListeners();
}

}