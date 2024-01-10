import 'package:bars/utilities/exports.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TimestampAdapter extends TypeAdapter<Timestamp> {
  @override
  final typeId = 5; // choose a unique ID for this TypeAdapter

  @override
  Timestamp read(BinaryReader reader) {
    final microSeconds = reader.readInt();
    return Timestamp.fromMicrosecondsSinceEpoch(microSeconds);
  }

  @override
  void write(BinaryWriter writer, Timestamp obj) {
    writer.writeInt(obj.microsecondsSinceEpoch);
  }
}
