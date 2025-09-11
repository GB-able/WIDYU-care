import 'package:care/services/api.dart';

class SmsService {
  final API api = API();
  final String url = "/auth/sms";

  Future<void> sendSms(String name, String phoneNumber) async {
    final res = await api.req(
      "$url/send",
      method: HttpMethod.post,
      body: {
        "name": name,
        "phoneNumber": phoneNumber,
      },
    );
    if (res.statusCode != 200) {
      throw Exception('Send sms failed');
    }
  }

  Future<bool> isVerified(String phoneNumber, String code) async {
    try {
      final res = await api.req(
        "$url/verify",
        method: HttpMethod.post,
        body: {"phoneNumber": phoneNumber, "code": code},
      );
      if (res.statusCode == 200) {
        final data = res.data['data'];
        await api.setTempToken(data['temporaryToken']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('[PRINT] Verify sms failed: $e');
      return false;
    }
  }
}
