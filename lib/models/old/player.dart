import 'package:isar/isar.dart';

part 'player.g.dart';

@collection
class Player {
  Id id = 1;
  int level = 0;
  int hp = 100;
  int xp = 0;
  int credits = 0;
  List<int> itemIDs = [];

  Player();
}

/* class Item {
  final int id;
  final String name;
  final int price;
  final int type;

  Item({required this.id, required this.name, required this.price, required this.type});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      type: json['description'],
    );
  }
} */