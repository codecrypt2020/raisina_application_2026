import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:attendee_app/constants.dart';
import 'package:aescryptojs/aescryptojs.dart';

encryptPayload(jsonData) {
  try {
    if (Constants.env == "Development" || Constants.env == "Production") {
      var ciphertext =
          (encryptAESCryptoJS((jsonEncode(jsonData)), "Misafeadmin2021@secret"))
              .toString();
      Map<String, dynamic> cipher = {"data": "${ciphertext}"};
      print("this is the cipher ${cipher}");
      return cipher;
    } else {
      return jsonData;
    }
  } catch (e) {
    print("this is the errorb jfound in encrypt ${e}");
    return jsonData;
  }
}

//this funciton only used for the login api decryption
decryptResponse(encResponse) {
  print(
      "this is the encpresponse ${encResponse} - type ${encResponse.runtimeType}");
  try {
    if (Constants.env == "Development" || Constants.env == "Production") {
      var encResponse_decoded = jsonDecode(encResponse);
      var decrypted_data = decryptAESCryptoJS(
          encResponse_decoded["res"], "Misafeadmin2021@secret");
      print("this is the decrypted data decrpted data login ${decrypted_data}");
      // var decryptedData = JSON.parse(bytes.toString(this.CryptoJS.enc.Utf8));
      var json_data = jsonDecode(decrypted_data);
      return json_data;
    } else {
      return jsonDecode(encResponse);
    }
  } catch (e) {
    print("this sis the exception ddhv ${e}");
    return json.decode(encResponse);
  }
}




