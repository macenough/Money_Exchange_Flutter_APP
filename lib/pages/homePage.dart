import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:money_exchange_app/api/clientApi.dart';
import 'package:money_exchange_app/model/MoneyExchangeModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ClientApi _clientApi = ClientApi();

  List<DataList> mdataList = [];
  List<DataList> sharedList = [];
  late Future<MoneyExchangeModel?> _future;
  late SharedPreferences prefs;
  bool isInternetOn = true;

  @override
  initState() {
    getSharedData();

    _future = _clientApi.getSingleObjectData();

    super.initState();
  }

  Future<void> getSharedData() async {
    prefs = await SharedPreferences.getInstance();
    final String? savedEntriesJson = prefs.getString('entries');
    final List<dynamic> entriesDeserialized = json.decode(savedEntriesJson!);
    List<DataList> deserializedEntries =
        entriesDeserialized.map((json) => DataList.fromJson(json)).toList();

    setState(() {
      sharedList = deserializedEntries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Money Exchange"),
        actions: <Widget>[
          MaterialButton(
              child: Icon(
                Icons.refresh,
                color: Colors.white,
                textDirection: TextDirection.ltr,
              ),
              onPressed: () {
                setState(() {
                  GetConnect();
                });

              })
        ],
      ),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: sharedList.isEmpty
                ? SizedBox(
                    width: double.infinity,
                    child: FutureBuilder<MoneyExchangeModel?>(
                        future: _future,
                        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Text("there is no connection");
                            case ConnectionState.active:
                            case ConnectionState.waiting:
                              return Center(
                                  child: new CircularProgressIndicator());

                            case ConnectionState.done:
                              if (snapshot.data != null) {
                                mdataList.clear();
                                var mList = snapshot.data.rates.toJson();

                                print(mList);
                                for (var prop in mList.entries) {
                                  mdataList.add(DataList(
                                      prop.key, prop.value.toString()));
                                  print(mdataList.toString());
                                }

                                /*  var s = json.encode(mdataList);
                          sharedPref.save("mList", s);*/

                                List<DataList> entries = mdataList;
                                String entriesJson = json.encode(entries
                                    .map((entry) => entry.toJson())
                                    .toList());
                                prefs.setString('entries', entriesJson);

                                /*   sharedPref.save("myList", mdataList);


                          print(loadSharedPrefs());*/
                                //loadSharedPrefs();
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: mdataList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          elevation: 15,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  mdataList[index]
                                                      .currentType
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.purple,
                                                  ),
                                                ),
                                                Text(
                                                  mdataList[index]
                                                      .rate
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }
                              return Text(
                                  "No data was loaded from SharedPreferences");
                          }
                        }),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: sharedList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 15,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  sharedList[index].currentType.toString(),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.purple,
                                  ),
                                ),
                                Text(
                                  sharedList[index].rate.toString(),
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
      ),
    ));
  }

  void GetConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Check Your Internet Connection"),
        ));
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {

        prefs.clear();
        _future = _clientApi.getSingleObjectData();
    } else if (connectivityResult == ConnectivityResult.wifi) {
        prefs.clear();
        _future = _clientApi.getSingleObjectData();
    }
  }
}

class DataList {
  String? currentType;
  String? rate;

  DataList(this.currentType, this.rate);

  DataList.fromJson(Map<String, dynamic> json) {
    currentType = json['currentType'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentType'] = this.currentType;
    data['rate'] = this.rate;
    return data;
  }
}
