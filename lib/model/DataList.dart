import 'package:hive/hive.dart';

part 'DataList.g.dart';
@HiveType(typeId: 0)
class DataList {
  @HiveField(0)
  String? currentType;
  @HiveField(1)
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