import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kuran/AramaSayfasi.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var prefs = await SharedPreferences.getInstance();
  temaRenk = int.tryParse(prefs.getString('tema_renk').toString()) ?? 0xff000000;
  textColor = int.tryParse(prefs.getString("text_color").toString()) ?? 0xffffffff;
  ucuncuRenk = int.tryParse(prefs.getString("ucuncu_renk").toString()) ?? 0xff0000ff;

  // yüklenirken resim göster

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kuran",
      home: AramaSayfasi(),
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Color(temaRenk), // Navigasyon çubuğunun rengini belirle
    ),
  );
}
