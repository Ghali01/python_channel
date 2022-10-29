import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

int b2i(Uint8List bytes) {
  List<int> bin = [];
  for (int b in bytes) {
    int rb = 8;
    while (b != 0) {
      bin.add(b % 2);
      b = b ~/ 2;
      rb--;
    }
    bin.addAll(List.filled(rb, 0));
  }
  int sum = 0, pos = 0;
  for (var bit in bin) {
    sum += bit * pow(2, pos).toInt();
    pos++;
  }
  return sum;
}

Uint8List i2b(int value) {
  List<int> bin = [];
  while (value != 0) {
    bin.add(value % 2);
    value = value ~/ 2;
  }
  bin.addAll(List.filled(32 - bin.length, 0));

  Uint8List bytes = Uint8List.fromList(
    List.unmodifiable(
      List.generate(
        4,
        (index) {
          List<int> byte = bin.sublist(index * 8, (index + 1) * 8);
          int sum = 0, pos = 0;
          for (var bit in byte) {
            sum += bit * pow(2, pos).toInt();
            pos++;
          }
          return sum;
        },
      ),
    ),
  );
  return bytes;
}

void main() {
  test('test b 2 i', () {
    expect(2049, b2i(Uint8List.fromList([1, 8, 0, 0])));
    expect(i2b(2049), (Uint8List.fromList([1, 8, 0, 0])));
  });
}
