import 'package:flutter/material.dart';
import 'package:temari/core/auth/data/network_access.dart';
import 'package:temari/core/utils/navigation.dart';
import 'package:temari/features/service_provider/spesific_service/service_list.dart';

class ServiceTypeList extends StatefulWidget {
  final String email;
  final dynamic serviceModel;
  const ServiceTypeList({super.key, required  this.email, required this.serviceModel});

  @override
  State<ServiceTypeList> createState() => _ServiceTypeListState();
}

class _ServiceTypeListState extends State<ServiceTypeList> {
  late Future<List<dynamic>> userServiceList;
  bool isServiceListLoaded=false;
  @override
  void initState() {
    super.initState();
    if(!isServiceListLoaded){
      userServiceList=fetchDataCTR(id:'11',val: widget.serviceModel['user_id'],key: 'user_id');
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(future: userServiceList, builder: (context,snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Center(child: Text('Error: Check Your Connection}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Column(
          children: [
            InkWell(
              onTap: (){
                setState(() {
                  userServiceList=fetchDataCTR(id:'11',val: widget.serviceModel['user_id'],key: 'user_id');
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Refresh'),
                  Icon(Icons.refresh),
                ],
              ),
            ),
            Center(child: Text('No service created yet please create one!'),),
          ],
        );
      }
      dynamic data =snapshot.data!;
      //print(data);
      return Column(
        children: [
          InkWell(
            onTap: (){
              setState(() {
                userServiceList=fetchDataCTR(id:'11',val: widget.serviceModel['user_id'],key: 'user_id');
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Refresh'),
                Icon(Icons.refresh),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context,index){
            return Card(
              elevation: 4,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${data[index]['service_name']}',style: TextStyle(fontWeight: FontWeight.bold),),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           // Text('${data[index]['service_id']}',style: TextStyle(fontWeight: FontWeight.normal),),
                            Text('${data[index]['description']}',style: TextStyle(fontWeight: FontWeight.normal),),
                            Text('${data[index]['service_type']}',style: TextStyle(fontWeight: FontWeight.normal),),
                            //Text('97 exams',style: TextStyle(fontWeight: FontWeight.normal),),
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: (){
                            //if exam
                            navigatePush(context: context, page: ServiceList(serviceModel: data[index]));
                          },
                          child: Icon(Icons.outbond,color: Colors.green,size: 50,))
                    ],
                  ),
                ],
              ),
            );
            }),
        ],
      );



    });


  }
}
