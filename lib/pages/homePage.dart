import 'package:flutter/material.dart';
import 'package:money_exchange_app/api/clientApi.dart';
import 'package:money_exchange_app/model/MoneyExchangeModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ClientApi _clientApi = ClientApi();

  List<MoneyExchangeModel> myList = [];
  List<DataList> mdataList = [];
  late Future<MoneyExchangeModel?> _future;

  @override
  void initState() {
    _future = _clientApi.getSingleObjectData();
    super.initState();
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
                  _future = _clientApi.getSingleObjectData();
                });
              })
        ],
      ),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: FutureBuilder<MoneyExchangeModel?>(
                  future: _future,
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("there is no connection");

                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return Center(child: new CircularProgressIndicator());

                      case ConnectionState.done:
                        if (snapshot.data != null) {
                          mdataList.clear();
                          var mList = snapshot.data.rates.toJson();

                          for (var prop in mList.entries) {
                            mdataList.add(DataList(prop.key, prop.value.toString()));
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: mdataList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
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
                                            mdataList[index].rate.toString(),
                                            style: TextStyle(fontSize: 15.0),
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
            )),
      ),
    ));
  }
}

class DataList {
  String? currentType;
  String? rate;

  DataList(this.currentType, this.rate);
}
