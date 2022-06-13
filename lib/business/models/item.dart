const kId = 'id';
const kName = 'name';
const kCart = 'purchased';

class Item {
  final String id;
  final String name;
  final bool purchased;

  Item({required this.id, required this.name, required this.purchased});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json[kId]! as String,
        name: json[kName]! as String,
        purchased: json[kCart]! as bool,
      );

  Map<String, dynamic> toJson() => {kId: id, kName: name, kCart: purchased};
}
