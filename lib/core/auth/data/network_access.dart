import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:temari/core/constants.dart';

Future<List<dynamic>> getUsers(userEmail) async {
  final response =
  await http.put(Uri.parse('$base/get/data/4/AND'),headers: headers,body: jsonEncode({"email":userEmail})); // Replace with your API URL
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List result=jsonDecode(response.body)['Data'];
    return result;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<dynamic>> getProvider(userEmail) async {
  final response =
  await http.put(Uri.parse('$base/get/data/10/AND'),headers: headers,body: jsonEncode({"email":userEmail})); // Replace with your API URL
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List result=jsonDecode(response.body)['Data'];
    return result;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<dynamic>> fetchDataCTR({ id,val,key}) async {
  final response =
  await http.put(Uri.parse('$base/get/data/$id/AND'),headers: headers,body: jsonEncode({'$key':val})); // Replace with your API URL
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List result=jsonDecode(response.body)['Data'];
    return result;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<dynamic>> register(url,data) async {
  try{
    final response =
    await http.post(Uri.parse('$base/post/data/$url'),headers: headers,body: jsonEncode([data]));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List result=jsonDecode(response.body)['Data'];
      return [{
        "status":"success",
        "message":response.statusCode,
        "body":""
      }];
    } else {
      final List result=jsonDecode(response.body)['Data'];
      //return result;
      //throw Exception(response.body);
      return [{
        "status":"error else",
        "message":response.statusCode,
        "body":""
      }];
    }
  }catch(e){

    return [{
      "status":"error Exception",
      "message":e.toString(),
      "body":""
    }];


  }

}


Future<List<dynamic>> updateTable(url,data) async {
  final response =
  await http.put(Uri.parse('${updatePath}/$url'),headers: headers,body: jsonEncode(data)); // Replace with your API URL
  if (response.statusCode == 200) {
    final  Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> dataList=[data["Data"]];
    return dataList;
  } else {
    throw Exception('Failed to load data');
  }
}


Future<List<dynamic>> fetchData(apiEnd) async {
  final url = Uri.parse('$getData/$apiEnd');
  try {
    final response = await http.get(url,headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> books = data['Data'];
      return books;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}




