import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 2)
class Item extends HiveObject{
  @HiveField(0)
  String title;

  @HiveField(1)
  String value;

  Item(this.title,this.value);

  String getItem(){
    return "$title + $value";
  }
}