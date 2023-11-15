import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:kuran/AyetGorunumu.dart';

import 'constants.dart';

class FavoriAyetlerSayfasi extends StatefulWidget {
  const FavoriAyetlerSayfasi({Key? key}) : super(key: key);

  @override
  State<FavoriAyetlerSayfasi> createState() => _FavoriAyetlerSayfasiState();
}

class _FavoriAyetlerSayfasiState extends State<FavoriAyetlerSayfasi> {
  var etiketler = [];
  var isLoading = false;
  dynamic datas = [];

  void loadFavorites() async {
    isLoading = true;
    setState(() {});
    var client = http.Client();
    var result = await client.get(Uri.parse("http://emredemiir.xyz/kuran/get_favorites.php"));
    var objs = jsonDecode(result.body);
    for(int i = 0;i<objs.length;i++){
      var result2 = await client.get(Uri.parse("https://api.acikkuran.com/surah/${objs[i]['sure_no']}/verse/${objs[i]['ayet_no']}?author=105"));
      var meal = jsonDecode(result2.body)["data"]["translation"]["text"];
      for(int i = 0;i<meal.length;i++) {
        //print(meal[i]);
        if (meal[i] == "[" && meal[i + 2] == "]") {
          meal = meal.substring(0, i) + meal.substring(i + 1);
          meal = meal.substring(0, i) + meal.substring(i + 1);
          meal = meal.substring(0, i) + meal.substring(i + 1);
        }
      }
      objs[i]["meal"] = jsonDecode(result2.body)["data"];
      objs[i]["meal"]["translation"]["text"] = meal;
      if(!etiketler.contains(objs[i]["aciklama"].toString())){
        etiketler.add(objs[i]["aciklama"].toString());
      }
      datas.add(objs[i]);
      setState(() {

      });
    }
    setState(() {});
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(temaRenk),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Row(
          children: [
            Expanded(child: Text("Kaydedilenler", style: TextStyle(color: Color(textColor)), textAlign: TextAlign.center,)),
            GestureDetector(
              onTap: (){
                showDialog(context: context, builder: (c) => AlertDialog(content: Text("Filtrele", textAlign: TextAlign.center, ),));
              },
              child: Padding(
                padding: EdgeInsets.only(left: 14.0, right: 7),
                child: Icon(Icons.filter_list),
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(textColor),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: Column(
          children: [
            isLoading ?
            Padding(padding: EdgeInsets.all(5), child: Column(
              children: [
                Text("Yükleniyor", style: TextStyle(color: Color(textColor))),
                const SizedBox(height: 5,),
                SpinKitRing(
                  lineWidth: 3,
                  size: 20,
                  color: Color(textColor),
                ),
              ],
            ))
            :
            const SizedBox(),
            Expanded(
              child: ListView.builder(
                itemCount: datas.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AyetGorunumu(SureNo: datas[index]["sure_no"], AyetNo: datas[index]["ayet_no"], SureAdi: datas[index]["meal"]["surah"]["name"]),));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 13.0, right: 12, top: 9, bottom: 9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text("${datas[index]["meal"]["surah"]["name"]} ${datas[index]["meal"]["verse_number"]}", style: TextStyle(color: Color(textColor), fontWeight: FontWeight.bold))),
                                Container(
                                  width: 15,
                                  height: 15,
                                  child: Text(datas[index]["aciklama"].toString() != "null" ? datas[index]["aciklama"].toString() : "-", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(textColor))),
                                  decoration: BoxDecoration(border: Border.all(width: 1, color: Color(textColor)), borderRadius: BorderRadius.circular(10)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(datas[index]["meal"]["translation"]["text"].toString(), style: TextStyle(color: Color(textColor))),
                            //Text(datas.toString(), style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ),
                    );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
