import 'package:flutter/material.dart';
import 'package:temari/core/auth/data/network_access.dart';
import 'package:temari/core/utils/navigation.dart';
import 'package:temari/features/service_provider/create_service.dart';
import 'package:temari/features/service_provider/provider_home.dart';

class ServiceProviderCustomer extends StatefulWidget {
  final String email;
  final dynamic usermodel;
  final String profileImage;

  const ServiceProviderCustomer({super.key, required this.email,required this.usermodel, required  this.profileImage});

  @override
  State<ServiceProviderCustomer> createState() => _ServiceProviderCustomerState();
}

class _ServiceProviderCustomerState extends State<ServiceProviderCustomer> {
  //get service list of  the customer
  late Future<List<dynamic>> serviceList;
  bool isServiceLoaded = false;


  @override
  void initState() {
    super.initState();
    serviceList = getProvider('${widget.email}');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: serviceList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            //print(snapshot);
            return const Center(child: Text('Error: Check Your Connection}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty){
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){
                  //print(widget.usermodel);
                 navigateReplace(context: context, page: CreateServiceProfile(userModel:widget.usermodel));
                }, child: Row(
                  children: [
                    Text('Looking to sell your services? \n Click here to get started!  '),
                    Icon(Icons.arrow_forward_ios),
                    Icon(Icons.arrow_forward_ios),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ))
              ],
            );
          }

          dynamic data=snapshot.data!;
          return Container(
            margin: EdgeInsets.all(8),
            child: ElevatedButton(
                onPressed:(){
              navigateReplace(context: context, page: ServiceProviderHome(emails: widget.email, serviceModel: data[0],profileImage:widget.profileImage,));
            },style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.withOpacity(.9),
              foregroundColor: Colors.white,
              shadowColor: Colors.grey,
              // Shadow color
              elevation: 5,
              // Elevation of the button
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10), // Rounded corners
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 30, vertical: 15), // Padding
            ),child: Container(
              child: Column(

              children: [
                SizedBox(height: 20,),
                Text('${data[0]['bio']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),overflow: TextOverflow.ellipsis,),
                SizedBox(height: 10,),
                Icon(Icons.arrow_forward_ios)
              ],
            ),)),
          );
        });
  }
}
