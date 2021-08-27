import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_exchange_app/api/clientApi.dart';
import 'package:money_exchange_app/model/DataList.dart';
import 'package:money_exchange_app/model/MoneyExchangeModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ClientApi _clientApi = ClientApi();
  List<DataList> mdataList = [];
  List<DataList> hiveList = [];
  late Future<MoneyExchangeModel?> _future;
  bool isInternetOn = true;
  Box listBox = Hive.box('datalist');

  @override
  void initState() {
    getHiveData();
    _future = _clientApi.getSingleObjectData();
    super.initState();
  }

  Future<void> getHiveData() async {
    final List<dynamic> entriesDeserialized = json.decode(listBox.get('hello'));
    List<DataList> deserializedEntries =
        entriesDeserialized.map((json) => DataList.fromJson(json)).toList();
    setState(() {
      //convert string to perticular list of model
      hiveList = deserializedEntries;
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
            child: hiveList.isEmpty
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

                                for (var prop in mList.entries) {
                                  mdataList.add(DataList(
                                      prop.key, prop.value.toString()));
                                }
                                List<DataList> entries = mdataList;
                                String entriesJson = json.encode(entries
                                    .map((entry) => entry.toJson())
                                    .toList());
                                addDataList(entriesJson);

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
                    itemCount: hiveList.length,
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
                                  hiveList[index].currentType.toString(),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.purple,
                                  ),
                                ),
                                Text(
                                  hiveList[index].rate.toString(),
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

  @override
  void dispose() {
    /* listBox.compact();
    Hive.close();*/
    super.dispose();
  }

  void addDataList(String dataList) {
    // final list = Hive.box<List<DataList>>('datalist');
    listBox.put("hello", dataList);

    print("list" + dataList.toString());
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
      // table teuncate
      listBox.clear();
      setState(() {
        _future = _clientApi.getSingleObjectData();
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      listBox.clear();
      setState(() {
        _future = _clientApi.getSingleObjectData();
      });
    }
  }
}
