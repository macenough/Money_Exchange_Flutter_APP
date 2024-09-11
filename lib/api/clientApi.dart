import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:money_exchange_app/model/MoneyExchangeModel.dart';

class ClientApi {
  Client _client = Client();

  Future<MoneyExchangeModel?> getSingleObjectData() async {
    final responseData = await _client.get(
        Uri.parse("http://api.exchangeratesapi.io/v1/latest?access_key=YOUR-KEY&format=1"));
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      print(data);

      return MoneyExchangeModel.fromJson(data);
    }
  }

}
