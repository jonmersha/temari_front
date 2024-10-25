import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:temari/features/service_provider/provider_profile.dart';
import 'package:temari/features/service_provider/service_list.dart';
class ServiceProviderHome extends StatefulWidget {
  final String emails;
  final dynamic serviceModel;
  final String profileImage;
  const ServiceProviderHome({super.key, required this.emails,required this.serviceModel, required  this.profileImage});

  @override
  State<ServiceProviderHome> createState() => _ServiceProviderHomeState();
}

class _ServiceProviderHomeState extends State<ServiceProviderHome> {
  late Future<List<dynamic>> userProfile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProviderProfile(
            serviceModel:widget.serviceModel,
            profileImage: widget.profileImage.toString(),
            isOwner: true,),
          Expanded(
            child: ServiceTypeList(email:widget.emails, serviceModel: widget.serviceModel,),
          )
        ],
      ),
    );
  }
}
