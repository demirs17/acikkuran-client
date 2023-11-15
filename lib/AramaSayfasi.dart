import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kuran/TemaDegistir.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AyetGorunumu.dart';
import 'FavoriAyetlerSayfasi.dart';
import 'SureGorunumu.dart';
import 'constants.dart';

bool findOnlyLettersAndSpaces(String text) {
  RegExp regex = RegExp(r'^[a-zA-ZğĞüÜşŞıİöÖçÇ\s]+$');
  return regex.hasMatch(text);
}
bool findLettersSpacesAndNumbers(String text) {
  RegExp regex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\s)(?=.*\d).+$');
  return regex.hasMatch(text);
}
bool findOnlyNumbers(String text) {
  RegExp regex = RegExp(r'^\d+$');
  return regex.hasMatch(text);
}
bool findNumberSpaceNumber(String text) {
  RegExp regex = RegExp(r'^\d+\s\d+$');
  return regex.hasMatch(text);
}
bool findNumberColonNumber(String text) {
  RegExp regex = RegExp(r'^\d+:\d+$');
  return regex.hasMatch(text);
}
bool findNumberWithSpace(String text) {
  RegExp regex = RegExp(r'^\d+\s$');
  return regex.hasMatch(text);
}

class AramaSayfasi extends StatefulWidget {
  const AramaSayfasi({Key? key}) : super(key: key);

  @override
  State<AramaSayfasi> createState() => _AramaSState();
}

class _AramaSState extends State<AramaSayfasi> {
  var araController = TextEditingController();
  List<Map<String, String>> eslesenler = [];

  void loadSurahsJson() async {
    var result = await rootBundle.loadString("assets/surahs.json");
    var surahs = jsonDecode(result)["data"];
    eslesenler.clear();
    for(int i = 0;i<surahs.length;i++){
      eslesenler.add({"name": surahs[i]["name"].toString(), "sure_no": (i+1).toString(), "ayet_no": "0"});
    }
    setState(() {});
  }
  void loadPreferences() async {
    var client = http.Client();
    var result = await client.get(Uri.parse("http://emredemiir.xyz/kuran/select.php"));
    var preferences = jsonDecode(result.body);
    for(int i = 0;i<preferences.length;i++){
      if(preferences[i]["anahtar"] == "kaldigim_sure_sirasi"){
        kaldigimSure = preferences[i]["deger"];
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadSurahsJson();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(temaRenk),
      drawer: Drawer(
        backgroundColor: Color(ucuncuRenk),
        child: Column(
          children: [
            DrawerHeader(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Kuran", style: TextStyle(color: Color(textColor), fontSize: 30, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoriAyetlerSayfasi(),));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 20, color: Color(textColor)),
                        const SizedBox(width: 10),
                        Text("Kaydedilmiş Ayetler", style: TextStyle(color: Color(textColor), fontSize: 17)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TemaDegistir(),)).then((val){
                      SystemChrome.setSystemUIOverlayStyle(
                        SystemUiOverlayStyle(
                          systemNavigationBarColor: Color(temaRenk), // Navigasyon çubuğunun rengini belirle
                        ),
                      );
                      setState(() {});
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Icon(Icons.color_lens_outlined, size: 20, color: Color(textColor)),
                        const SizedBox(width: 10),
                        Text("Temayı Değiştir", style: TextStyle(color: Color(textColor), fontSize: 17)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(textColor), // Hamburger ikonunun rengi
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text("Kuran", style: TextStyle(color: Color(textColor), fontStyle: FontStyle.italic)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: .1, color: Color(textColor)),
                    borderRadius: const BorderRadius.all(Radius.circular(3))
                  ),
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Theme(
                          data: ThemeData(
                              inputDecorationTheme: const InputDecorationTheme(
                                border: OutlineInputBorder(
                                  //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(0), topRight: Radius.circular(0), topLeft: Radius.circular(5)),
                                ),
                              ),
                              textSelectionTheme: TextSelectionThemeData(cursorColor: Color(textColor))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2, left: 10),
                            child: TextFormField(
                              onChanged: (str) async {
                                final String jsonStr = await rootBundle.loadString("assets/surahs.json");
                                var surahs = jsonDecode(jsonStr)["data"];
                                eslesenler.clear();
                                if(str == ""){
                                  var result = await rootBundle.loadString("assets/surahs.json");
                                  var surahs = jsonDecode(result)["data"];
                                  for(int i = 0;i<surahs.length;i++){
                                    eslesenler.add({"name": surahs[i]["name"].toString(), "sure_no": (i+1).toString(), "ayet_no": "0"});
                                  }
                                }else {
                                  if (findOnlyLettersAndSpaces(str)) {
                                    //showDialog(context: context, builder: (context) => AlertDialog(title: Text("harf")),);
                                    for (var i = 0; i < surahs.length; i++) {
                                      if (surahs[i]["name"].toString()
                                          .toLowerCase()
                                          .contains(str.toLowerCase())) {
                                        eslesenler.add({
                                          "name": surahs[i]["name"].toString(),
                                          "sure_no": (i + 1).toString(),
                                          "ayet_no": "0"
                                        });
                                      }
                                      if (str[str.length - 1] == " " &&
                                          surahs[i]["name"]
                                              .toString()
                                              .toLowerCase() ==
                                              str.trim().toLowerCase()) {
                                        for (int j = 0; j <
                                            surahs[i]["verse_count"]; j++) {
                                          eslesenler.add({
                                            "name": surahs[i]["name"] + " " +
                                                (j + 1).toString(),
                                            "sure_no": (i + 1).toString(),
                                            "ayet_no": (j + 1).toString()
                                          });
                                        }
                                      }
                                    }
                                  }
                                  else if (findLettersSpacesAndNumbers(str)) {
                                    //showDialog(context: context, builder: (context) => AlertDialog(title: Text("harf sayı")),);
                                    var parts = str.split(" ");
                                    var sure = parts[0];
                                    var ayetNo = int.parse(parts[1]);
                                    for (int i = 0; i < surahs.length; i++) {
                                      if (sure.toLowerCase() == surahs[i]["name"]
                                          .toString()
                                          .toLowerCase()) {
                                        for (int j = 0; j <=
                                            surahs[i]["verse_count"]; j++) {
                                          if (j.toString().contains(
                                              ayetNo.toString())) {
                                            eslesenler.add({
                                              "name": surahs[i]["name"] + " " +
                                                  j.toString(),
                                              "sure_no": (i + 1).toString(),
                                              "ayet_no": j.toString()
                                            });
                                          }
                                        }
                                      }
                                    }
                                  }
                                  else if (findOnlyNumbers(str) || findNumberWithSpace(str)) {
                                    //showDialog(context: context, builder: (context) => AlertDialog(title: Text("sayı")),);
                                    if (str.contains(" ")) {
                                      if (int.parse(str) < 115 &&
                                          int.parse(str) > 0) {
                                        for (int i = 0; i < surahs[int.parse(str) -
                                            1]["verse_count"]; i++) {
                                          eslesenler.add({
                                            "name": surahs[int.parse(str) -
                                                1]["name"] + " " + (i + 1).toString(),
                                            "sure_no": int.parse(str).toString(),
                                            "ayet_no": (i + 1).toString()
                                          });
                                        }
                                      }
                                    } else {
                                      if (int.parse(str) < 115 &&
                                          int.parse(str) > 0) {
                                        eslesenler.add({
                                          "name": surahs[int.parse(str) - 1]["name"],
                                          "sure_no": int.parse(str).toString(),
                                          "ayet_no": "0"
                                        });
                                      }
                                    }
                                  }
                                  else if (findNumberSpaceNumber(str)) {
                                    //showDialog(context: context, builder: (context) => AlertDialog(title: Text("sayı sayı")),);
                                    var parts = str.split(" ");
                                    var sureNo = int.parse(parts[0]);
                                    var ayetNo = int.parse(parts[1]);
                                    if (sureNo < 115 && sureNo > 0 &&
                                        ayetNo <= surahs[sureNo - 1]["verse_count"] &&
                                        ayetNo > 0) {
                                      for (int i = 0; i <=
                                          surahs[sureNo - 1]["verse_count"]; i++) {
                                        if (i.toString().contains(
                                            ayetNo.toString())) {
                                          eslesenler.add({
                                            "name": surahs[sureNo - 1]["name"] + " " +
                                                i.toString(),
                                            "sure_no": sureNo.toString(),
                                            "ayet_no": i.toString()
                                          });
                                        }
                                      }
                                    }
                                  }
                                  else if (findNumberColonNumber(str)) {
                                    //showDialog(context: context, builder: (context) => AlertDialog(title: Text("sayı:sayı")),);
                                    var parts = str.split(":");
                                    var sureNo = int.parse(parts[0]);
                                    var ayetNo = int.parse(parts[1]);
                                    if (sureNo < 115 && sureNo > 0 &&
                                        ayetNo <= surahs[sureNo - 1]["verse_count"] &&
                                        ayetNo > 0) {
                                      eslesenler.add({
                                        "name": surahs[sureNo - 1]["name"] + " " +
                                            ayetNo.toString(),
                                        "sure_no": sureNo.toString(),
                                        "ayet_no": ayetNo.toString()
                                      });
                                    }
                                  }
                                }
                                setState(() {});
                              },
                              controller: araController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Ara",
                                hintStyle: TextStyle(color: Color(textColor)),
                              ),
                              style: TextStyle(color: Color(textColor)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, right: 15, bottom: 15, left: 15),
                        child: GestureDetector(
                          onTap: () async {
                            araController.text = "";loadSurahsJson();
                          },
                          child: Icon(Icons.close, color: araController.text.isNotEmpty ? Color(textColor) : Colors.transparent, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView.builder(
                      itemCount: eslesenler.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            border: Border(bottom: BorderSide(width: 0, color: Colors.transparent)),
                            //borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      if(eslesenler[index]["ayet_no"].toString() == "0") {
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              SureGorunumu(SureNo: int.parse(eslesenler[index]["sure_no"].toString()), SureAdi: eslesenler[index]["name"].toString()),));
                                      }else{
                                        //showDialog(context: context, builder: (context) => AlertDialog(title: Text("Ayet Görünümü Yok")),);
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              AyetGorunumu(SureNo: int.parse(eslesenler[index]["sure_no"].toString()), AyetNo: int.parse(eslesenler[index]["ayet_no"].toString()), SureAdi: eslesenler[index]["name"].toString().replaceFirst(" ${eslesenler[index]["ayet_no"]}", ""),),));
                                      }
                                    },
                                    onLongPress: () async {
                                      var client = http.Client();
                                      await client.get(Uri.parse("https://emredemiir.xyz/kuran/set.php?anahtar=kaldigim_sure_sirasi&deger=${eslesenler[index]["sure_no"]}"));
                                      var result = await client.get(Uri.parse("http://emredemiir.xyz/kuran/select.php"));
                                      var preferences = jsonDecode(result.body);
                                      for(int i = 0;i<preferences.length;i++){
                                        if(preferences[i]["anahtar"] == "kaldigim_sure_sirasi"){
                                          kaldigimSure = preferences[i]["deger"];
                                        }
                                      }
                                      setState(() {});
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 35,child: Text(eslesenler[index]["sure_no"].toString(), style: TextStyle(color: Color(textColor), fontWeight: FontWeight.bold))),
                                          Text(eslesenler[index]["name"].toString(), style: TextStyle(color: Color(textColor), fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                int.parse(eslesenler[index]["sure_no"].toString()) == kaldigimSure ? Icon(Icons.bookmark, color: Color(textColor), size: 12) : const SizedBox(),
                                GestureDetector(
                                  onTap: () async {
                                    araController.text = "${eslesenler[index]["name"]} ";
                                    araController.selection = TextSelection.fromPosition(TextPosition(offset: araController.text.length));
                                    final String jsonStr = await rootBundle.loadString("assets/surahs.json");
                                    var surahs = jsonDecode(jsonStr)["data"];
                                    eslesenler.clear();
                                    var str = araController.text;
                                    if (findOnlyLettersAndSpaces(str)) {
                                      //showDialog(context: context, builder: (context) => AlertDialog(title: Text("harf")),);
                                      for (var i = 0; i < surahs.length; i++) {
                                        if (surahs[i]["name"].toString()
                                            .toLowerCase()
                                            .contains(str.toLowerCase())) {
                                          eslesenler.add({
                                            "name": surahs[i]["name"].toString(),
                                            "sure_no": (i + 1).toString(),
                                            "ayet_no": "0"
                                          });
                                        }
                                        if (str[str.length - 1] == " " &&
                                            surahs[i]["name"]
                                                .toString()
                                                .toLowerCase() ==
                                                str.trim().toLowerCase()) {
                                          for (int j = 0; j <
                                              surahs[i]["verse_count"]; j++) {
                                            eslesenler.add({
                                              "name": surahs[i]["name"] + " " +
                                                  (j + 1).toString(),
                                              "sure_no": (i + 1).toString(),
                                              "ayet_no": (j + 1).toString()
                                            });
                                          }
                                        }
                                      }
                                    }
                                    else if (findLettersSpacesAndNumbers(str)) {
                                      //showDialog(context: context, builder: (context) => AlertDialog(title: Text("harf sayı")),);
                                      var parts = str.split(" ");
                                      var sure = parts[0];
                                      var ayetNo = int.parse(parts[1]);
                                      for (int i = 0; i < surahs.length; i++) {
                                        if (sure.toLowerCase() == surahs[i]["name"]
                                            .toString()
                                            .toLowerCase()) {
                                          for (int j = 0; j <=
                                              surahs[i]["verse_count"]; j++) {
                                            if (j.toString().contains(
                                                ayetNo.toString())) {
                                              eslesenler.add({
                                                "name": surahs[i]["name"] + " " +
                                                    j.toString(),
                                                "sure_no": (i + 1).toString(),
                                                "ayet_no": j.toString()
                                              });
                                            }
                                          }
                                        }
                                      }
                                    }
                                    else if (findOnlyNumbers(str) || findNumberWithSpace(str)) {
                                      //showDialog(context: context, builder: (context) => AlertDialog(title: Text("sayı")),);
                                      if (str.contains(" ")) {
                                        if (int.parse(str) < 115 &&
                                            int.parse(str) > 0) {
                                          for (int i = 0; i < surahs[int.parse(str) -
                                              1]["verse_count"]; i++) {
                                            eslesenler.add({
                                              "name": surahs[int.parse(str) -
                                                  1]["name"] + " " + (i + 1).toString(),
                                              "sure_no": int.parse(str).toString(),
                                              "ayet_no": (i + 1).toString()
                                            });
                                          }
                                        }
                                      } else {
                                        if (int.parse(str) < 115 &&
                                            int.parse(str) > 0) {
                                          eslesenler.add({
                                            "name": surahs[int.parse(str) - 1]["name"],
                                            "sure_no": int.parse(str).toString(),
                                            "ayet_no": "0"
                                          });
                                        }
                                      }
                                    }
                                    else if (findNumberSpaceNumber(str)) {
                                      //showDialog(context: context, builder: (context) => AlertDialog(title: Text("sayı sayı")),);
                                      var parts = str.split(" ");
                                      var sureNo = int.parse(parts[0]);
                                      var ayetNo = int.parse(parts[1]);
                                      if (sureNo < 115 && sureNo > 0 &&
                                          ayetNo <= surahs[sureNo - 1]["verse_count"] &&
                                          ayetNo > 0) {
                                        for (int i = 0; i <=
                                            surahs[sureNo - 1]["verse_count"]; i++) {
                                          if (i.toString().contains(
                                              ayetNo.toString())) {
                                            eslesenler.add({
                                              "name": surahs[sureNo - 1]["name"] + " " +
                                                  i.toString(),
                                              "sure_no": sureNo.toString(),
                                              "ayet_no": i.toString()
                                            });
                                          }
                                        }
                                      }
                                    }
                                    else if (findNumberColonNumber(str)) {
                                      //showDialog(context: context, builder: (context) => AlertDialog(title: Text("sayı:sayı")),);
                                      var parts = str.split(":");
                                      var sureNo = int.parse(parts[0]);
                                      var ayetNo = int.parse(parts[1]);
                                      if (sureNo < 115 && sureNo > 0 &&
                                          ayetNo <= surahs[sureNo - 1]["verse_count"] &&
                                          ayetNo > 0) {
                                        eslesenler.add({
                                          "name": surahs[sureNo - 1]["name"] + " " +
                                              ayetNo.toString(),
                                          "sure_no": sureNo.toString(),
                                          "ayet_no": ayetNo.toString()
                                        });
                                      }
                                    }
                                    setState(() {

                                    });
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(Icons.edit, color: Color(textColor), size: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
