import 'dart:typed_data';
import 'package:drift/drift.dart';

class Float32ListConverter extends TypeConverter<Float32List, Uint8List> {
  const Float32ListConverter();

  @override
  Float32List fromSql(Uint8List fromDb) {
    if (fromDb.offsetInBytes % 4 == 0) {
      return fromDb.buffer.asFloat32List(
        fromDb.offsetInBytes,
        fromDb.lengthInBytes ~/ 4,
      );
    }

    final bytes = Uint8List.fromList(fromDb);
    return bytes.buffer.asFloat32List();
  }

  @override
  Uint8List toSql(Float32List value) {
    return value.buffer.asUint8List(value.offsetInBytes, value.lengthInBytes);
  }
}
