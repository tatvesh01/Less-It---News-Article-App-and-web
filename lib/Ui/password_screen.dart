import 'package:flutter/material.dart';
import 'package:news_app/Ui/add_news_screen.dart';
import 'package:news_app/Ui/category_manager.dart';
import '../Utils/helper.dart';
import '../Utils/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class PasswordScreen extends StatefulWidget {
  PasswordScreen({Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {

  final formKey = GlobalKey<FormState>();
  final passController = TextEditingController();
  bool isLoader = false;

  @override
  Widget build(BuildContext context) {

    Global.deviceSize(context);

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              height: Global.sHeight,
              width: Global.sWidth,
              color: Helper.bgColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Form(
                    key: formKey,
                    child: Container(
                      width: Global.sWidth/4,
                      child: TextFormField(
                        controller: passController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password',
                          labelStyle: TextStyle(color: Helper.blackColor),
                          hintStyle: TextStyle(color: Helper.greyColor),
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                          filled: true,
                          fillColor: Helper.greyColor.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Helper.greyColor, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Helper.greyColor, width: 1.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                    ),
                    ),

                    SizedBox(height: 30),
                    Container(
                      width: Global.sWidth/4,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Helper.lightBlackColor,
                        ),
                        onPressed: ()async{
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoader = true;
                            });
                            CollectionReference credential = FirebaseFirestore.instance.collection('credential');
                            await credential.where('password').limit(1).get().then((value) async{

                              Map<String,dynamic> aaaa = value.docs[0].data() as Map<String,dynamic>;
                              if(aaaa["password"] == passController.text){
                                Global.showToast("Login success");
                                Get.to(()=>AddNewsScreen());
                                setState(() {
                                  passController.text = "";
                                  isLoader = false;
                                });
                              }else{
                                setState(() {
                                  isLoader = false;
                                });
                                Global.showToast("Wrong password");
                              }

                            });
                        }
                        },
                        child: Text('Login',style: TextStyle(color: Helper.whiteColor,fontSize: 16),),
                      ),
                    ),


                ],
              ),
            ),

            isLoader ? Center(child: Container(height: 100,width:100,
                decoration: BoxDecoration(
                    color: Helper.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Helper.blackColor,width: 2)
                )
                ,child: Center(child: CircularProgressIndicator()))) : SizedBox()

          ],
        ),
      ),
    );
  }
}
