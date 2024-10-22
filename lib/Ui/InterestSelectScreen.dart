import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/Ui/news_screen.dart';
import 'package:news_app/Utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Utils/global.dart';

class InterestSelectScreen extends StatefulWidget {
  @override
  _InterestSelectScreenState createState() => _InterestSelectScreenState();
}

class _InterestSelectScreenState extends State<InterestSelectScreen> {
  List<String> _interests = [];

  List<String> _selectedInterests = [];

  @override
  Widget build(BuildContext context) {

    if(_interests.isEmpty){
      fetchCategories();
    }

    return Scaffold(
      backgroundColor: Helper.whiteColor,
      appBar: AppBar(
        title: Text('Welcome',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Helper.blackColor),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pick your favorite topic to set up your feeds.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _buildChoiceChips(),
              ),
              SizedBox(height: 20),


              Center(child:
              InkWell(
                onTap: (){
                  if (_selectedInterests.length >= 2) {
                    Get.off(()=>NewsScreen());
                  } else {
                    Global.showToast("Please select at least 2 interest");
                  }
                },
                child: Container(
                  height: 55,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Helper.blackColor,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(child: Text("Continue",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white),)),

                ),
              ),),
              SizedBox(height: 25,)
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChoiceChips() {
    return _interests.map((interest) {
      return ChoiceChip(
        label: Text(capitalizeFirstLetter(interest),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: _selectedInterests.contains(interest) ? Colors.white:Colors.black),),
        selected: _selectedInterests.contains(interest),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedInterests.add(interest);
            } else {
              _selectedInterests.remove(interest);
            }
          });
        },
        showCheckmark: false,
        selectedColor: Helper.blackColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Rounded edges
          side: BorderSide(
            color: _selectedInterests.contains(interest) ? Helper.blackColor : Colors.black, width: _selectedInterests.contains(interest) ? 2 : 1
          ),
        ),
      );
    }).toList();
  }

  Future<void> fetchCategories() async {
    QuerySnapshot categorySnapshot = await FirebaseFirestore.instance.collection('categories').get();
    _interests.addAll(categorySnapshot.docs.map((doc) => doc['name'].toString()).toList());
    setState(() {
    });
  }



  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
