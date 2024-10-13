import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:temari/core/constants.dart';


Future<List<dynamic>> getUsers(userEmail) async {
  final response =
  await http.put(Uri.parse('${base}/get/data/19/AND'),headers: headers,body: jsonEncode({"email":userEmail})); // Replace with your API URL

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List result=jsonDecode(response.body)['Data'];
    return result;
    //return result.map(((e)=>UserModel.fromJson(e))).toList();
  } else {
    throw Exception('Failed to load data');
  }
}
Future<List<dynamic>> getMerchant(value) async {
  final response =
  await http.put(Uri.parse('${base}/get/data/2/AND'),headers: headers,body: jsonEncode({"user_id":value})); // Replace with your API URL

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List result=jsonDecode(response.body)['Data'];
    return result;
  } else {
    throw Exception('Failed to load data');
  }
}
Future<List<dynamic>> getMerchantProduct(value) async {
  final response =
  await http.put(Uri.parse('${base}/get/data/20/AND'),headers: headers,body: jsonEncode({"merchant_id":value})); // Replace with your API URL

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List result=jsonDecode(response.body)['Data'];
    return result;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<dynamic>> register(url,data) async {
  print(data);
  final response =
  await http.post(Uri.parse('${base}/$url'),headers: headers,body: jsonEncode([data])); // Replace with your API URL

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List result=jsonDecode(response.body)['Data'];
    return result;
    ////return result.map(((e)=>UserModel.fromJson(e))).toList();
  } else {
    throw Exception('Failed to load data');
  }
}



// Future<List<dynamic>> updateTable(url,data) async {
//   print(data);
//   final response =
//   await http.put(Uri.parse('${updatePath}/$url'),headers: header,body: jsonEncode(data)); // Replace with your API URL
//
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> data = jsonDecode(response.body);
//     final List result=jsonDecode(response.body)['Data'];
//     return result;
//     ////return result.map(((e)=>UserModel.fromJson(e))).toList();
//   } else {
//     throw Exception('Failed to load data');
//   }
// }



// Future<List<dynamic>> getData(endpoints) async {
//   final response =
//   await http.get(Uri.parse('$baseUrl/$endpoints'),headers: header); // Replace with your API URL
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> data = jsonDecode(response.body);
//     final List result=jsonDecode(response.body)['Data'];
//     return result;
//   } else {
//     throw Exception('Failed to load data');
//   }
// }



