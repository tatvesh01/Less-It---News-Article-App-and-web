import 'package:get/get.dart';
import '../Utils/global.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:url_launcher/url_launcher.dart';

class FullNewsScreenController extends GetxController{

  late String title,desc,date;
  int currentIndex = 0;
  RxBool refreshPage = false.obs;
  List<dynamic> image = [];
  String animName = "";
  QuillEditorController descController = QuillEditorController();

  @override
  void onInit() {

    var data = Get.arguments;

    var news = data[0];
    image = data[1];
    animName = "anim_"+data[2];

    title = news["title"];
    desc = news["description"];
    date = Global.formatDate(news["timestamp"]);


    refreshPage(true);
    refreshPage(false);

    super.onInit();
  }

  void openUrl(String urls) async{
    final Uri url = Uri.parse(urls);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

}