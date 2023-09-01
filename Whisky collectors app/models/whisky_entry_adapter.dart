import 'package:hive/hive.dart';
import 'whisky_entry.dart';

class WhiskyEntryAdapter extends TypeAdapter<WhiskyEntry> {
  @override
  final int typeId = 0;

  @override
  WhiskyEntry read(BinaryReader reader) {
    return WhiskyEntry(
      nazwaBottlingu: reader.readString(),
      destylarnia: reader.readString(),
      rokDestylacji: reader.readInt(),
      rokButelkowania: reader.readInt(),
      rodzajBeczek: reader.readString(),
      zawartoscAlkoholu: reader.readString(),
      niefiltrowana: reader.readBool(),
      bezBarwienia: reader.readBool(),
      kolor: reader.readString(),
      aromat: reader.readString(),
      smak: reader.readString(),
      finisz: reader.readString(),
      ocena: reader.readInt(),
      key: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, WhiskyEntry obj) {
    writer.writeString(obj.nazwaBottlingu);
    writer.writeString(obj.destylarnia ?? ''); 
    writer.writeInt(obj.rokDestylacji ?? 0);
    writer.writeInt(obj.rokButelkowania ?? 0);
    writer.writeString(obj.rodzajBeczek ?? '');
    writer.writeString(obj.zawartoscAlkoholu ?? '');
    writer.writeBool(obj.niefiltrowana);
    writer.writeBool(obj.bezBarwienia);
    writer.writeString(obj.kolor ?? '');
    writer.writeString(obj.aromat ?? '');
    writer.writeString(obj.smak ?? '');
    writer.writeString(obj.finisz ?? '');
    writer.writeInt(obj.ocena);
    writer.writeInt(obj.key);
  }
}
