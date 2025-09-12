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

  Future<bool> sendSmsForPw(
      String name, String email, String phoneNumber) async {
    final res = await api.req(
      "$url/send-if-member-exist",
      method: HttpMethod.post,
      body: {"name": name, "email": email, "phoneNumber": phoneNumber},
    );
    if (res.statusCode == 200) {
      return true;
    } else if (res.data['code'] == "MEMBER_4041") {
      return false;
    } else {
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
