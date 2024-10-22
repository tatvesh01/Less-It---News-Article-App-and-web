import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Utils/helper.dart';
import '../Controller/splash_screen_controller.dart';
import '../Utils/global.dart';

class PolicyScreen extends StatefulWidget {
  PolicyScreen({Key? key}) : super(key: key);

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}


class _PolicyScreenState extends State<PolicyScreen> {

  String name = "";
  String textData = "";

  @override
  void initState() {
    // TODO: implement initState
    
    var data = Get.arguments;
    name = data[0];
    textData = data[1];
    
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(name,style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w500)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        height: Global.sHeight,
        width: Global.sWidth,
        color: Helper.whiteColor,
        child: SingleChildScrollView(child: Text(textData,style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w500)))

      ),
    );
  }
}
