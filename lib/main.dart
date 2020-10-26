import 'dart:convert';

import 'package:http/http.dart' as http;

class Mobile {
  String id;
  String diskName;

  Mobile({this.id, this.diskName});
}

class Deal {
  String title;
  Mobile mobileicon;

  Deal({this.title, this.mobileicon});
}

Future<List<Deal>> getList() async {
  var url =
      'https://www.tunetalk.com/my/api/tunetalk/nowtrending/en/json/off/0/lim/50/';
  var response = await http.get(url);

  var _deals = List<Deal>();
  if (response.statusCode == 200) {
    print('yes');

    var listdeals = json.decode(response.body)['deals'];
    listdeals.forEach((json) {
      _deals.add(Deal(
          title: json['title'],
          mobileicon: Mobile(
              id: int.parse(json['mobileicon']['id']),
              diskName: json['mobileicon']['disk_name'])));
    });
    // print(json));
    print(_deals);

    return _deals;
  } else {
    return _deals;
  }
}

void main() {
  getList();
}
