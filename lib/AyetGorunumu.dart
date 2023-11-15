import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:kuran/SureGorunumu.dart';
import 'package:kuran/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AyetGorunumu extends StatefulWidget {
  int SureNo;
  int AyetNo;
  String SureAdi;
  AyetGorunumu({Key? key, required this.SureNo, required this.AyetNo, required this.SureAdi}) : super(key: key);

  @override
  State<AyetGorunumu> createState() => _AyetGorunumuState();
}

class _AyetGorunumuState extends State<AyetGorunumu> {
  late final sonrakiSureAdi;
  String oncekiSureAdi = "";
  late final verseCount;
  dynamic authors;
  List<dynamic> datas = [];
  var favoriAyetMi = false;

  void loadData() async {
    var client = http.Client();
    var response = await client.get(Uri.parse("https://api.acikkuran.com/authors"));
    authors = jsonDecode(response.body)["data"];
    for(int i = 0;i<authors.length;i++){
      var res = await client.get(Uri.parse("https://api.acikkuran.com/surah/${widget.SureNo}/verse/${widget.AyetNo}?author=${authors[i]["id"]}"));
      datas.add(jsonDecode(res.body)["data"]);
      setState(() {});
    }
  }

  void loadFavorimi() async {
    var client = http.Client();
    var result = await client.get(Uri.parse("https://emredemiir.xyz/kuran/favorimi.php?sure_no=${widget.SureNo}&ayet_no=${widget.AyetNo}"));
    if(jsonDecode(result.body) == 1){
      favoriAyetMi = true;
    }else{
      favoriAyetMi = false;
    }
    setState(() {});
  }

  void loadSureDetaylari() async {
    var result = await rootBundle.loadString("assets/surahs.json");
    var surahs = jsonDecode(result)["data"];
    for(int i = 0;i<surahs.length;i++){
      if(surahs[i]["id"] == widget.SureNo){
        verseCount = await surahs[i]["verse_count"];
        sonrakiSureAdi = await surahs[i+1]["name"] ?? "";
        oncekiSureAdi = await surahs[i-1]["name"] ?? "";
        setState(() {});
        break;
      }
    }
  }

  @override
  void initState(){
    super.initState();
    loadData();
    loadFavorimi();
    loadSureDetaylari();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragEnd: (details){
        if (details.primaryVelocity! > 0) {
          // Sağa doğru sürüklendi. // Önceki
          if(widget.AyetNo == 1){
            showDialog(context: context, builder: (context) => AlertDialog(title: const Text("Önceki sureye geçilsin mi?"), actions: [
              TextButton(onPressed: () {
                if(widget.SureNo != 1){
                  //showDialog(context: context, builder: (context) => AlertDialog(title: Text(oncekiSureAdi.toString() ?? "")),);
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SureGorunumu(SureNo: widget.SureNo-1, SureAdi: oncekiSureAdi.toString()),));
                }else{
                  Navigator.pop(context);
                }
              },
              child: const Text("Evet")),
              TextButton(onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hayır")),
            ],),);
          }
          else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AyetGorunumu(SureNo: widget.SureNo, AyetNo: widget.AyetNo-1, SureAdi: widget.SureAdi),));
          }
        }
        else if (details.primaryVelocity! < 0) {
          // Sola doğru sürüklendi. // Sonraki
          if(verseCount != null){
            if(widget.AyetNo == verseCount){
              showDialog(context: context, builder: (context) => AlertDialog(
                title: const Text("Sonraki sureye geçilsin mi?"),
                actions: [
                  TextButton(child: const Text("Evet"), onPressed: () {
                    if(widget.SureNo != 114) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            SureGorunumu(SureNo: widget.SureNo + 1,
                                SureAdi: sonrakiSureAdi),));
                    }else{
                      Navigator.pop(context);
                    }
                  },),
                  TextButton(child: const Text("Hayır"), onPressed: () {
                    Navigator.pop(context);
                  },),
                ],
              ));
            }
            else{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AyetGorunumu(SureNo: widget.SureNo, AyetNo: widget.AyetNo+1, SureAdi: widget.SureAdi),));
            }
          }
          else{
            showDialog(context: context, builder: (context) => const AlertDialog(title: Text("Sure Bilgileri Getirilemedi")),);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Color(temaRenk),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Color(textColor),
          ),
          title: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SureGorunumu(SureNo: widget.SureNo, SureAdi: widget.SureAdi.replaceFirst(" ${widget.AyetNo}", ""),),));
                  },
                  child: Text(datas.isEmpty ? "${widget.SureAdi} ${widget.AyetNo}" : "${datas[0]["surah"]["name"]} ${datas[0]["verse_number"]}", style: TextStyle(fontSize: 22, color: Color(textColor)), textAlign: TextAlign.center,),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  var client = http.Client();
                  var result = await client.get(Uri.parse("https://emredemiir.xyz/kuran/set_favori.php?sure_no=${widget.SureNo}&ayet_no=${widget.AyetNo}"));
                  if(jsonDecode(result.body) == 1){
                    loadFavorimi();
                  }

                  var prefs = await SharedPreferences.getInstance();
                  var favoriler = prefs.getString("favoriler").toString();
                  List<dynamic> list = jsonDecode(favoriler);
                  var varmis = false;
                  for(var i = 0;i<list.length;i++){
                    if(list[i]["sure_no"].toString() == widget.SureNo.toString() && list[i]["ayet_no"].toString() == widget.AyetNo.toString()){
                      list.removeAt(i);
                      varmis = true;
                      break;
                    }
                  }
                  if(varmis == false){
                    list.add({"id": 111, "sure_no": widget.SureNo, "ayet_no": widget.AyetNo, "aciklama": null});
                  }
                  prefs.setString("favoriler", jsonEncode(list));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 13.0, right: 8),
                  child: Icon(favoriAyetMi ? Icons.star : Icons.star_border, color: Color(textColor)),
                ),
              ),
            ],
          ),
        ),
        body: datas.isEmpty ?
        Yukleniyor()
            :
        Ceviriler(),
      ),
    );
  }
  Widget Yukleniyor(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Yükleniyor", style: TextStyle(color: Color(textColor), fontSize: 15)),
          const SizedBox(height: 10,),
          SpinKitRing(
            lineWidth: 3,
            size: 25,
            color: Color(textColor),
          ),
        ],
      ),
    );
  }
  Widget Ceviriler(){
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: ListView.builder(
        itemCount: datas.length,
        itemBuilder: (context, ind){
          if(ind == 0){
            return Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 15, top: 5, left: 10),
              child: Text(datas.isNotEmpty ? datas[0]["verse"].toString() : "", style: TextStyle(color: Color(textColor), fontSize: 20), textAlign: TextAlign.end,),
            );
          }else if(ind == 1){
            return Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, bottom: 20, right: 10),
              child: Text(datas.isNotEmpty ? datas[0]["transcription"].toString() : "", style: TextStyle(color: Color(textColor))),
            );
          }else{
            var index = ind;

            String str = datas[index]["translation"]["text"];

            List<Widget> separatedList = [];
            RegExp pattern = RegExp(r'\[([^\]]+)\]|[\wÇĞİÖŞÜçğıöşüîâêîôûÂÊÎÔÛ.;,:\-"!]+');
            Iterable<Match> matches = pattern.allMatches(str);

            for (Match match in matches) {
              if (match.group(1) != null) {
                separatedList.add(Text("${match.group(1)!} ", style: TextStyle(color: Color(textColor), fontSize: 10)));
              } else {
                separatedList.add(Text("${match.group(0)!} ", style: TextStyle(color: Color(textColor))));
              }
            }


            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onLongPress: (){
                showDialog(context: context, builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xdfffffff),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: datas[index]["translation"]["footnotes"] == null ? 0 : datas[index]["translation"]["footnotes"].length,
                        itemBuilder: (context, i){
                          var footnotes = datas[index]["translation"]["footnotes"];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: i != 0 ? const EdgeInsets.only(top: 15) : const EdgeInsets.all(0),
                                child: Text("${footnotes[i]["number"]}) ${footnotes[i]["text"]}"),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(datas[index]["translation"]["author"]["name"], textAlign: TextAlign.center, style: TextStyle(color: Color(textColor), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Wrap(
                      children: separatedList,
                    )
                    //Text(datas[index]["translation"]["text"], style: const TextStyle(color: Colors.white)),
                    //Wrap(children: [Text("lorem", style: TextStyle(color: Colors.white)),Text("lorem", style: TextStyle(color: Colors.white)),Text("lorem", style: TextStyle(color: Colors.white)),Text("lorem", style: TextStyle(color: Colors.white)),Text("lorem", style: TextStyle(color: Colors.white)),Text("lorem", style: TextStyle(color: Colors.white)),Text("lorem", style: TextStyle(color: Colors.white)),),]),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
