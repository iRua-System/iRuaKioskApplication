import 'package:intl/intl.dart';

class MoneyFormat{

  static String formatMoney(String money){
    final formatter = new NumberFormat("#,###");
    int temp = num.tryParse(money)!.toInt();
    
    String alo =  formatter.format(temp).toString();
    return alo;
  }
}