import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class WhiskyEntry extends HiveObject {
  @HiveField(0)
  final String? key;
  @HiveField(1)
  final String nazwaBottlingu;
  @HiveField(2)
  final String? destylarnia;
  @HiveField(3)
  final int? rokDestylacji;
  @HiveField(4)
  final int? rokButelkowania;
  @HiveField(5)
  final String? rodzajBeczek;
  @HiveField(6)
  final String? zawartoscAlkoholu;
  @HiveField(7)
  final bool? niefiltrowana;
  @HiveField(8)
  final bool? bezBarwienia;
  @HiveField(9)
  final String? kolor;
  @HiveField(10)
  final String? aromat;
  @HiveField(11)
  final String? smak;
  @HiveField(12)
  final String? finisz;
  @HiveField(13)
  final int? ocena;

  WhiskyEntry({
    required this.key,
    required this.nazwaBottlingu,
    this.destylarnia,
    this.rokDestylacji,
    this.rokButelkowania,
    this.rodzajBeczek,
    this.zawartoscAlkoholu,
    this.niefiltrowana,
    this.bezBarwienia,
    this.kolor,
    this.aromat,
    this.smak,
    this.finisz,
    this.ocena,
  });
}
