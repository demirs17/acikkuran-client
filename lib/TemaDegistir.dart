import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class TemaDegistir extends StatefulWidget {
  const TemaDegistir({super.key});

  @override
  State<TemaDegistir> createState() => _TemaDegistirState();
}

class _TemaDegistirState extends State<TemaDegistir> {
  var controller = TextEditingController();
  var textColorController = TextEditingController();
  var ucuncuRenkController = TextEditingController();
  var suankiRenk = "bos";
  var suankiTextColor = "boş";
  var suankiUcuncuRenk = "boş";

  void loadSuankiRenkler() async {
    var prefs = await SharedPreferences.getInstance();
    suankiRenk = prefs.getString('tema_renk').toString();
    suankiTextColor = prefs.getString("text_color").toString();
    suankiUcuncuRenk = prefs.getString("ucuncu_renk").toString();
    setState(() {});
  }
  @override
  void initState() {
    loadSuankiRenkler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(temaRenk),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(textColor),
        ),
        title: Text("Tema Değiştir", style: TextStyle(color: Color(textColor))),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Theme(
                  data: ThemeData(
                      inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(
                          //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(0), topRight: Radius.circular(0), topLeft: Radius.circular(5)),
                        ),
                      ),
                      textSelectionTheme: TextSelectionThemeData(cursorColor: Color(textColor))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(width: .2, color: Color(textColor))),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, left: 10),
                        child: TextFormField(
                          style: TextStyle(color: Color(textColor)),
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
                          controller: controller,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    var val = controller.text;
                    if(val.length == 10 && val[0] == "0" && val[1] == "x"){
                      var a = await SharedPreferences.getInstance();
                      await a.setString('tema_renk', controller.text);
                      temaRenk = int.tryParse(controller.text) ?? 0xff000000;
                      Navigator.pop(context);
                      setState(() {});
                    }
                    else{
                      showDialog(context: context, builder: (context) => const AlertDialog(title: Text("Renk 0xffrrggbb formatında olmalı")));
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8, left: 10, right: 10),
                        child: Text("Kaydet", style: TextStyle(color: Colors.black)),
                      ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Text(suankiRenk, style: TextStyle(color: Color(textColor))),
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Color(temaRenk),
                        border: Border.all(width: .5, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Theme(
                  data: ThemeData(
                      inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(
                          //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(0), topRight: Radius.circular(0), topLeft: Radius.circular(5)),
                        ),
                      ),
                      textSelectionTheme: TextSelectionThemeData(cursorColor: Color(textColor))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(width: .2, color: Color(textColor))),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, left: 10),
                        child: TextFormField(
                          style: TextStyle(color: Color(textColor)),
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
                          controller: textColorController,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    var val = textColorController.text;
                    if(val.length == 10 && val[0] == "0" && val[1] == "x"){
                      var a = await SharedPreferences.getInstance();
                      await a.setString('text_color', val);
                      textColor = int.tryParse(val) ?? 0xffffffff;
                      Navigator.pop(context);
                      setState(() {});
                    }
                    else{
                      showDialog(context: context, builder: (context) => const AlertDialog(title: Text("Renk 0xffrrggbb formatında olmalı")));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8, left: 10, right: 10),
                      child: Text("Kaydet", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Text(suankiTextColor, style: TextStyle(color: Color(textColor))),
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Color(textColor),
                        border: Border.all(width: .5, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Theme(
                  data: ThemeData(
                      inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(
                          //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(0), topRight: Radius.circular(0), topLeft: Radius.circular(5)),
                        ),
                      ),
                      textSelectionTheme: TextSelectionThemeData(cursorColor: Color(textColor))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(width: .2, color: Color(textColor))),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, left: 10),
                        child: TextFormField(
                          style: TextStyle(color: Color(textColor)),
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
                          controller: ucuncuRenkController,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    var val = ucuncuRenkController.text;
                    if(val.length == 10 && val[0] == "0" && val[1] == "x"){
                      var a = await SharedPreferences.getInstance();
                      await a.setString('ucuncu_renk', val);
                      ucuncuRenk = int.tryParse(val) ?? 0xff0000ff;
                      Navigator.pop(context);
                      setState(() {});
                    }
                    else{
                      showDialog(context: context, builder: (context) => const AlertDialog(title: Text("Renk 0xffrrggbb formatında olmalı")));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8, left: 10, right: 10),
                      child: Text("Kaydet", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Text(suankiUcuncuRenk, style: TextStyle(color: Color(textColor))),
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Color(ucuncuRenk),
                        border: Border.all(width: .5, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                //Text("ikinci üçüncü renk static", style: TextStyle(color: Color(textColor)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
