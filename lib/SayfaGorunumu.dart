import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:kuran/constants.dart';

import 'AyetGorunumu.dart';

class SayfaGorunumu extends StatefulWidget {
  int SureNo;
  String SureAdi;
  String Meal;
  SayfaGorunumu({Key? key, required this.SureNo, required this.SureAdi, required this.Meal}) : super(key: key);

  @override
  State<SayfaGorunumu> createState() => _SayfaGorunumuState();
}


class _SayfaGorunumuState extends State<SayfaGorunumu> {
  dynamic data;
  List<Widget> separatedList = [];
  var donulenAyetIndex = -1;

  void loadData() async {
    var client = http.Client();
    var result = await client.get(Uri.parse("https://api.acikkuran.com/surah/${widget.SureNo}?author=${widget.Meal}"));
    data = await jsonDecode(result.body)["data"];
    wrapData();
  }

  void wrapData(){
    separatedList = [];
    for(int i = 0;i<data["verses"].length;i++){
      var parts = data["verses"][i]["translation"]["text"].split(" ");
      separatedList.add(
          Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Container(
                  width: (i+1).toString().length == 1 ? 13 : (i+1).toString().length == 2 ? 19 : 23, height: 13,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all(width: .6, color: Color(textColor)), borderRadius: BorderRadius.circular(10), color: donulenAyetIndex == i ? Color(textColor) : Colors.transparent),
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Text("${i+1}", style: TextStyle(color: donulenAyetIndex == i ? Color(temaRenk) : Color(textColor), fontSize: 9), textAlign: TextAlign.center,),
                  ),),)
      );
      String str = data["verses"][i]["translation"]["text"];
      RegExp pattern = RegExp(r'\[([^\]]+)\]|[\wÇĞİÖŞÜçğıöşüîâêîôûÂÊÎÔÛ.\;,:\-"!]+');
      Iterable<Match> matches = pattern.allMatches(str);
      for (Match match in matches) {
        if (match.group(1) != null) {
          separatedList.add(Text("${match.group(1)!} ",style: TextStyle(color: Color(textColor), fontSize: 10)));
        } else {
          separatedList.add(GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                AyetGorunumu(SureNo: widget.SureNo,
                    AyetNo: data["verses"][i]["verse_number"],
                    SureAdi: widget.SureAdi,
                ),)).then((val){
                  donulenAyetIndex = i;
                  Future.delayed(const Duration(seconds: 5), () {
                      donulenAyetIndex = -1;
                      wrapData();
                  });
                  wrapData();
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
                            itemCount: data["verses"][i]["translation"]["footnotes"] ==
                                null
                                ? 0
                                : data["verses"][i]["translation"]["footnotes"]
                                .length,
                            itemBuilder: (BuildContext context, int ind) {
                              var footnotes = data["verses"][i]["translation"]["footnotes"] ?? [];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: ind != 0 ? const EdgeInsets.only(top: 15) : const EdgeInsets.all(0),
                                    child: Text("${footnotes[ind]["number"]}) ${footnotes[ind]["text"]}"),
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
            child: Text("${match.group(0)!} ",
                style: TextStyle(color: Color(textColor))),
          ));
        }
      }
      //for(int j = 0;j<parts.length;j++){
        //wrapContent.add(Text(j == parts.length-1 ? parts[j] : parts[j] + " ", style: const TextStyle(color: Colors.white)));
      //}
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(temaRenk),
      appBar: AppBar(title: Text(data != null ? data["name"] : widget.SureAdi, style: TextStyle(color: Color(textColor))), centerTitle: true, iconTheme: IconThemeData(color: Color(textColor)), backgroundColor: Colors.transparent, shadowColor: Colors.transparent,),
      body: data != null ?
          Sayfa()
          :
          Yukleniyor()
    );
  }
  Widget Sayfa(){
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
          child: Column(
            children: [
              //Text(widget.data.toString(), style: const TextStyle(color: Colors.white),),
              data == null ? Padding(
                padding: EdgeInsets.all(35.0),
                child: Column(
                  children: [
                    Text("Yükleniyor", style: TextStyle(color: Color(textColor), fontSize: 15)),
                    const SizedBox(height: 10,),
                    SpinKitRing(
                      lineWidth: 3,
                      size: 20,
                      color: Color(textColor),
                    ),
                  ],
                ),
              ) : const SizedBox(),
              Wrap(
                runSpacing: 3,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: separatedList.isEmpty ? [] : separatedList ,
              ),
            ],
          ),
        ),
      ),
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
