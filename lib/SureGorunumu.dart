import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kuran/AyetGorunumu.dart';
import 'package:kuran/SayfaGorunumu.dart';
import 'constants.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class SureGorunumu extends StatefulWidget {
  int SureNo;
  String SureAdi;
  SureGorunumu({Key? key, required this.SureNo, required this.SureAdi}) : super(key: key);

  @override
  State<SureGorunumu> createState() => _SureGorunumuState();
}

class _SureGorunumuState extends State<SureGorunumu> {
  String oncekiSureAdi = "";
  String sonrakiSureAdi = "";
  var seciliMeal = "105";
  var beyazBorderIndex = -1;

  var goster = {
    "meal": true,
    "arapça": true,
    "arapça_latin": true,
  };

  dynamic data;

  dynamic authors = [];
  void loadAuthors() async {
    var client = http.Client();
    var res = await client.get(Uri.parse("httpS://api.acikkuran.com/authors"));
    var list = jsonDecode(res.body)["data"];
    for(int i = 0;i<list.length;i++){
      authors.add({"id": list[i]["id"],"name": list[i]["name"]});
    }
    setState(() {});
  }

  void loadData() async {
    var client = http.Client();
    var response = await client.get(Uri.parse("https://api.acikkuran.com/surah/${widget.SureNo}?author=$seciliMeal"));
    data = jsonDecode(response.body)["data"];
    setState(() {});
  }

  void loadSureDetaylari() async {
    var result = await rootBundle.loadString("assets/surahs.json");
    var surahs = jsonDecode(result)["data"];
    for(int i = 0;i<surahs.length;i++){
      if(surahs[i]["id"] == widget.SureNo){
        sonrakiSureAdi = surahs[i+1]["name"] ?? "";
        oncekiSureAdi = surahs[i-1]["name"] ?? "";
        setState(() {});
        break;
      }
    }
  }

  @override
  void initState(){
    super.initState();
    loadData();
    loadAuthors();
    loadSureDetaylari();
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
          color: Color(textColor), // Hamburger ikonunun rengi
        ),
        title: Row(
          children: [
            Expanded(child: Text(data == null ? widget.SureAdi : data["name"].toString(), style: TextStyle(fontSize: 22, color: Color(textColor)), textAlign: TextAlign.center,)),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SayfaGorunumu(SureNo: widget.SureNo, SureAdi: widget.SureAdi, Meal: seciliMeal),));
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 25, right: 4),
                child: Icon(Icons.library_books_sharp),
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details){
          if (details.primaryVelocity! > 0) {
            // Sağa doğru sürüklendi. // Önceki
            if(widget.SureNo != 1){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SureGorunumu(SureNo: widget.SureNo - 1, SureAdi: oncekiSureAdi),));
            }
          }
          else if (details.primaryVelocity! < 0) {
            // Sola doğru sürüklendi. // Sonraki
            if(widget.SureNo != 114){
              //showDialog(context: context, builder: (context) => AlertDialog(title: Text(sonrakiSureAdi.toString())),);
              Navigator.push(context, MaterialPageRoute(builder: (context) => SureGorunumu(SureNo: widget.SureNo + 1, SureAdi: sonrakiSureAdi),));
            }
          }
        },
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child:
            data != null ?
            Ayetler()
            :
            Yukleniyor()
          ),
        ),
      ),
    );
  }
  Widget Ayetler(){
    return ListView.builder(
      itemCount: data == null ? 1 : data["verse_count"] + 1,
      itemBuilder: (context, ind){
        if(ind == 0){
          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    showModalBottomSheet(
                      context: context,
                      builder: (context){
                        return Container(
                          color: Color(ucuncuRenk),
                          child: ScrollConfiguration(
                            behavior: const ScrollBehavior().copyWith(overscroll: false),
                            child: ListView.builder(
                              itemCount: authors.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: (){
                                    seciliMeal = authors[index]["id"].toString();
                                    seciliMealIsim = authors[index]["name"].toString();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(border: Border(top: BorderSide(width: .2, color: Color(textColor)))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15, left: 20, bottom: 15),
                                      child: Row(
                                        children: [
                                          //Container(width: 35,child: Text(authors[index]["id"].toString(),),),
                                          Text(authors[index]["name"].toString(), style: TextStyle(color: Color(textColor))),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ).then(
                          (value) {
                        loadData();
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(Icons.loop, color: Color(textColor), size: 15),
                        const SizedBox(width: 5),
                        Text(seciliMealIsim, style: TextStyle(color: Color(textColor)),),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  showDialog(context: context, builder: (context) => AlertDialog(
                    content: SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: (){
                              var trueCount = 0;
                              for(int i = 0;i<goster.keys.length;i++){
                                if(goster[goster.keys.toList()[i]] == true){
                                  trueCount += 1;
                                }
                              }
                              if(trueCount == 1 && goster["meal"] == true){
                                Navigator.pop(context);
                              }else{
                                goster["meal"] = !goster["meal"]!;
                                Navigator.pop(context);
                                setState(() {});
                              }
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                children: [
                                  const Expanded(child: Text("Türkçe Meal")),
                                  Icon(goster["meal"] == true ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              var trueCount = 0;
                              for(int i = 0;i<goster.keys.length;i++){
                                if(goster[goster.keys.toList()[i]] == true){
                                  trueCount += 1;
                                }
                              }
                              if(trueCount == 1 && goster["arapça"] == true){
                                Navigator.pop(context);
                              }else{
                                goster["arapça"] = !goster["arapça"]!;
                                Navigator.pop(context);
                                setState(() {});
                              }
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                children: [
                                  const Expanded(child: Text("Arapça")),
                                  Icon(goster["arapça"] == true ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              var trueCount = 0;
                              for(int i = 0;i<goster.keys.length;i++){
                                if(goster[goster.keys.toList()[i]] == true){
                                  trueCount += 1;
                                }
                              }
                              if(trueCount == 1 && goster["arapça_latin"] == true){
                                Navigator.pop(context);
                              }else{
                                goster["arapça_latin"] = !goster["arapça_latin"]!;
                                Navigator.pop(context);
                                setState(() {});
                              }
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                children: [
                                  const Expanded(child: Text("Arapça Latin Alfabesi")),
                                  Icon(goster["arapça_latin"] == true ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(Icons.settings, color: Color(textColor), size: 20),
                ),
              ),
            ],
          );
        }
        else {
          var index = ind - 1;
          var verses = data["verses"];
          String str = verses[index]["translation"]["text"];
          List<Widget> separatedList = [];
          RegExp pattern = RegExp(r'\[([^\]]+)\]|[\wÇĞİÖŞÜçğıöşüîâêîôûÂÊÎÔÛ.\;,:\-"!]+');
          Iterable<Match> matches = pattern.allMatches(str);
          for (Match match in matches) {
            if (match.group(1) != null) {
              separatedList.add(Text("${match.group(1)!} ",
                  style: TextStyle(color: Color(textColor), fontSize: 10)));
            } else {
              separatedList.add(Text("${match.group(0)!} ",
                  style: TextStyle(color: Color(textColor))));
            }
          }
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (
                  context) =>
                  AyetGorunumu(SureNo: widget.SureNo,
                      AyetNo: verses[index]["verse_number"], SureAdi: data["name"]),)).then((value) {
                        beyazBorderIndex = index;
                        Future.delayed(const Duration(seconds: 5), () {
                          setState(() {
                            beyazBorderIndex = -1;
                          });
                        });
                        setState(() {});
              });
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      //title: Text(data["verses"][index]["translation"]["footnotes"].toString()),
                      backgroundColor: const Color(0xdfffffff),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior().copyWith(
                              overscroll: false),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data["verses"][index]["translation"]["footnotes"] ==
                                null
                                ? 0
                                : data["verses"][index]["translation"]["footnotes"]
                                .length,
                            itemBuilder: (BuildContext context, int i) {
                              var footnotes = data["verses"][index]["translation"]["footnotes"] ??
                                  [];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start,
                                children: [
                                  Padding(
                                    padding: i != 0
                                        ? const EdgeInsets.only(top: 15)
                                        : const EdgeInsets.all(0),
                                    child: Text("${footnotes[i]["number"]}) ${footnotes[i]["text"]}"),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Color(textColor), width: .2))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                                beyazBorderIndex == index ? "${verses[index]["verse_number"]} -" : verses[index]["verse_number"].toString(),
                                style: TextStyle(color: Color(textColor))),
                          ),
                        ),
                        //Icon(Icons.bookmark_border, color: Colors.white, size: 12),
                        //Icon(Icons.arrow_forward, color: Colors.white, size: 12),
                      ],
                    ),
                    const SizedBox(height: 2),
                    //Text(meal, style: TextStyle(color: Colors.white)),
                    goster["meal"] == true ? Wrap(children: separatedList,) : const SizedBox(),
                    goster["arapça"] == true ? Text(data["verses"][index]["verse"].toString(), style: TextStyle(color: Color(textColor), fontSize: 18), textAlign: TextAlign.end,) : const SizedBox(),
                    goster["arapça_latin"] == true ? Text(data["verses"][index]["transcription"].toString(), style: TextStyle(color: Color(textColor)), textAlign: TextAlign.center,) : const SizedBox(),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
  Widget Yukleniyor(){
    return Center(
      child: Container(
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
      ),
    );
  }
}