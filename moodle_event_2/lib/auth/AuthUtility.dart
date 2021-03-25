import 'dart:typed_data';

import 'package:crypto/crypto.dart';

///
/// 2段階認証に関するユーティリティ
///

String keyToBinaryString(String key) {
  StringBuffer stringBuffer = StringBuffer();
  for (int ascii in key.codeUnits) {
    if (ascii == "=".codeUnitAt(0)) continue;
    int modifiedInteger = ascii < 65 ? (ascii - 50 + 26) : ascii - 65;
    String bitString = modifiedInteger.toRadixString(2).padLeft(5, "0");
    stringBuffer.write(bitString);
  }
  return stringBuffer.toString();
}

Int8List binaryStringToByteArray(String binaryString) {
  List<int> buffer = [];
  binaryString = binaryString.padRight(80, "0");
  for (int i = 0; i < binaryString.length; i += 8) {
    String aString = binaryString.substring(i, i + 8);
    int aInteger;
    if (aString[0] == "1") {
      aString = "0" + aString.substring(1);
      aInteger = -128 + int.parse(aString, radix: 2);
    } else {
      aInteger = int.tryParse(aString, radix: 2);
    }
    if (aInteger > 127) {
      aInteger -= 128 + (aInteger - 128);
    }
    buffer.add(aInteger);
  }
  return Int8List.fromList(buffer);
}

Int8List byteArrayToHash(Int8List byteArray, int timeIndex) {
  Int8List buffer = Int8List(8)
    ..buffer.asByteData().setInt32(4, timeIndex, Endian.big);
  Hmac hmacSha1 = Hmac(sha1, byteArray);
  Digest digest = hmacSha1.convert(buffer);
  return Int8List.fromList(digest.bytes);
}

String hashToAuthPass(Int8List hashArray) {
  int offset = hashArray[19] & 0xf;
  int truncatedHash = hashArray[offset] & 0x7f;
  for (int i = 1; i < 4; i++) {
    truncatedHash <<= 8;
    truncatedHash |= hashArray[offset + i] & 0xff;
  }
  int authPassNumber = truncatedHash % 1000000;
  return authPassNumber.toString().padLeft(6, "0");
}

///
/// 秘密鍵から2段階認証用パスワードを生成する
///
String getAuthPass(secretKey) {
  int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  int timeIndex = ((now - 0) ~/ 30);
  String binaryString = keyToBinaryString(secretKey);
  Int8List byteArray = binaryStringToByteArray(binaryString);
  Int8List hashArray = byteArrayToHash(byteArray, timeIndex);
  return hashToAuthPass(hashArray);
}

void main() async {
  print(getAuthPass("VVLLWZAHWL54FNZH"));
}
