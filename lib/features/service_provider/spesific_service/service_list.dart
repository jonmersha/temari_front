import 'package:flutter/material.dart';
import 'package:temari/core/auth/data/network_access.dart';
import 'package:temari/core/utils/navigation.dart';
import 'package:temari/features/service_provider/create_service.dart';
import 'package:temari/features/service_provider/exam_draft/new_quastions.dart';

class ServiceList extends StatefulWidget {
  final dynamic serviceModel;

  const ServiceList({super.key, required this.serviceModel});

  @override
  State<ServiceList> createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  late Future<List<dynamic>> userServiceList;
  bool isServiceListLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!isServiceListLoaded) {
      // print(widget.serviceModel);
      userServiceList = fetchDataCTR(
          id: '23',
          val: '${widget.serviceModel['service_id']}',
          key: 'service_id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: userServiceList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('loading the services'),
                ),
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Error Connecting to server'),
                ),
                body:
                    const Center(child: Text('Error: Check Your Connection}')));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('No Services found'),
                ),
                body: Column(
                  children: [
                  Text('${widget.serviceModel['service_name']}'),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            //service

                          }, child: Text('Create Your Service')),
                    ),
                  ],
                ));
          }
          dynamic data = snapshot.data!;

          //print(data);
          return Scaffold(appBar: AppBar(), body:
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context,index){
                    return Card(
                      elevation: 4,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${data[index]['exam_name']}',style: TextStyle(fontWeight: FontWeight.bold),),
                            //Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   // Text('${data[index]['description']}',style: TextStyle(fontWeight: FontWeight.normal),),
                                    Text('${data[index]['exam_subject']}',style: TextStyle(fontWeight: FontWeight.normal),),
                                    Text('Number Of Questions : ${data[index]['question_count']}',style: TextStyle(fontWeight: FontWeight.normal),),
                                  ],
                                ),
                                InkWell(
                                    onTap: (){
                                      //print('Show list of exams');
                                      //open the Exam with this subject
                                    },
                                    child: Icon(Icons.outbond,color: Colors.green,size: 50,))
                              ],
                            ),
                            ElevatedButton(
                              onPressed: (){

                                navigateReplace(context: context, page: QuestionRegistrationForm(examModel: data[index],));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Add Questions '),
                                  Icon(Icons.add),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
              );
        });
  }
}
