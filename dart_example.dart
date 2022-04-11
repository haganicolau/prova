import 'dart:convert';
import 'dart:math';

import 'package:BirdId/repository/pin_repository.dart';
import 'package:BirdId/utils/string_util.dart';
import 'package:bird_cryptography/bird_cryptography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Seed {
  String? issuer = "Bird ID adkaspodka"; //issuer + serial
  String? userId = "1234567890"; //cpf/cnpj
  String? secret = "secret/12345";
  String? decriptySecret = "decriptedSecret";
  String? key = "12345678910"; //timestamp
  String? name;
  String? photoPath = 'assets/images/user.png';
  String? otp = "123 456";

  bool isFavorite = false;

  bool isMain = false;

  Seed({
    this.issuer,
    this.userId,
    this.secret,
    this.key,
    this.decriptySecret,
  });

  Seed.fromJson(Map<String, dynamic> json)
      : issuer = json['issuer'],
        secret = json['secret'],
        key = json['key'],
        userId = json['userId'] ?? json['user'],
        name = json['name'] ?? '',
        photoPath = json['photoPath'] ?? 'assets/images/user.png',
        otp = json['otp'] ?? '123 456',
        isFavorite = json['isFavorite'] ?? false,
        isMain = json['isMain'] ?? false;

  static Seed fromJsonString(String jsonSeed) {
    Map seedMap = jsonDecode(jsonSeed);
    Seed seed = Seed.fromJson(seedMap as Map<String, dynamic>);
    return seed;
  }

  Map<String, dynamic> toJson() => {
        'issuer': issuer,
        'userId': userId,
        'name': name,
        'photoPath': photoPath,
        'secret': secret,
        'key': key,
        'otp': otp,
        'isFavorite': isFavorite,
        'isMain': isMain,
      };

  static String toJsonString(Seed seed) {
    return jsonEncode(seed);
  }

  String toUniqueString() {
    return userId! + issuer!;
  }

  changeToRandomOtp() {
    var upperLimit = 1000;
    Random random1 = Random();
    Random random2 = Random();
    otp = random1.nextInt(upperLimit).toString().padLeft(3, '0') +
        ' ' +
        random2.nextInt(upperLimit).toString().padLeft(3, '0');
  }

  generateOtp() {
    var otp = BirdCryptography().generateOtp(secret!);
    this.otp = formatOtp(otp);
    return this.otp;
  }

  formatOtp(String otp) {
    var aux = otp.substring(0, 3) + " " + otp.substring(3, 6);
    return aux;
  }

  Future<Seed> createSeedWithSecretDecrypted() async {
    String? pin = await PinRepository().loadPin();
    String decryptedSeedSecret =
        await BirdCryptography().decryptSeedSecret(secret!, pin!);
    Seed seedDecryptedSeed = clone();
    seedDecryptedSeed.secret = decryptedSeedSecret;

    return seedDecryptedSeed;
  }

  static Future<Seed> createSeedFromQRCode(String uri) async {
    var uriParsed = Uri.parse(uri);

    var issuer = uriParsed.queryParameters["issuer"];
    var secret = uriParsed.queryParameters["secret"];

    if (issuer == null || secret == null) {
      throw "QR Code inválido!";
    }

    var aux = uriParsed.path.lastIndexOf('/') + 1;
    var userId = uriParsed.path.substring(aux);

    var key = (DateTime.now().millisecondsSinceEpoch / 1000).toString();

    String? pin = await PinRepository().loadPin();
    var derivedSecret =
        await BirdCryptography().encryptSeedSecret(secret, pin!);

    Seed seed = Seed(
        issuer: issuer,
        userId: userId,
        secret: derivedSecret,
        key: key,
        decriptySecret: secret);

    return seed;
  }

  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: StringUtil.removeSpaces(otp!)));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("OTP Copiado")));
  }

  clone() {
    var seedJson = toJson();
    return Seed.fromJson(seedJson);
  }
}
