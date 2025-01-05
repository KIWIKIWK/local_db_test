import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1, adapterName: "fwefws")
class Person extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  List<Person> friends;

  @HiveField(3)
  String job;

  Person(this.name, this.age, this.friends, this.job);
}