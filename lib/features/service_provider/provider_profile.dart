import 'package:flutter/material.dart';
import 'package:temari/core/constants.dart';
import 'package:temari/core/utils/navigation.dart';
import 'package:temari/features/service_provider/service_profile_creation.dart';

class ProviderProfile extends StatefulWidget {
  // final String email;
  final bool isOwner;

  final String profileImage;
  final dynamic serviceModel;

  const ProviderProfile(
      {super.key,
      required this.isOwner,
      required this.profileImage,
      required this.serviceModel});

  @override
  State<ProviderProfile> createState() => _ProviderProfileState();
}

class _ProviderProfileState extends State<ProviderProfile> {
  //Fetching provider information form data base
  late Future<List<dynamic>> profileInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.serviceModel);
    //print('image Url${widget.profileImage}');
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
       // border: Border.all(color: Colors.black, width: 1),
        image: DecorationImage(
          image: NetworkImage('$base/${widget.serviceModel['logo']}'),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        color: Colors.deepPurple.shade500,
      ),
      height: 300,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(),
                color: Colors.green,
                image:
                    DecorationImage(image: NetworkImage(widget.profileImage))),
          ),
          Expanded(child: Container()),
          Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Container(
                      color: Colors.green.withOpacity(0.5),
                      child: Text(
                        textAlign: TextAlign.center,
                        '${widget.serviceModel['bio']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      )),
                   Container(
                     padding: EdgeInsets.symmetric(horizontal: 20),
                     color: Colors.green.withOpacity(.5),
                     child: Row(
                       children: [
                         Icon(Icons.phone,color: Colors.red,),
                         Text(' ${widget.serviceModel['phone_number']}',style: TextStyle(
                           color: Colors.white,
                           fontSize: 14,
                         )),
                         Expanded(child: Container(),),
                         Icon(Icons.email,color: Colors.red,),
                         Text(' ${widget.serviceModel['email']}',style: TextStyle(
                           color: Colors.white,
                           fontSize: 14,
                         )),
                       ],
                     ),
                   ),

                  if (widget.isOwner)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(1),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 20,
                            )),
                       // if (!widget.isOwner)
                          Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(1),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Icon(
                                Icons.sms,
                                color: Colors.white,
                                size: 20,
                              )),
                       // if (!widget.isOwner)
                          Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(1),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Icon(
                                Icons.email,
                                color: Colors.white,
                                size: 20,
                              )),
                      ],
                    )
                ],
              )),
            ],
          ),

          if (widget.isOwner)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                   // print('${widget.serviceModel['user_id']}');
                    navigateReplace(
                        context: context,
                        page: ServiceRegistrationPage(
                            usrId: '${widget.serviceModel['user_id']}'));



                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.withOpacity(.4),
                    foregroundColor: Colors.white,
                    // Text (foreground) color
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
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('add new service'),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          // ServiceList()
        ],
      ),
    );
  }
}
