import 'package:care/models/api_response.dart';
import 'package:care/models/dtos/walk_monthly_dto.dart';
import 'package:care/services/api.dart';
import 'package:care/utils/extensions.dart';

class WalkService {
  final API api = API();
  final String url = "/goals/walks";

  Future<ApiResponse<WalkMonthlyDto>> getWalkMonthly(
      int year, int month, int memberId) async {
    final res = await api.req(
      "$url/monthly",
      method: HttpMethod.get,
      query: {"year": year, "month": month, "memberId": memberId},
    );

    return res.toApiResponse(WalkMonthlyDto.fromJson);
  }

  Future<void> updateWalkGoal(int memberId, int goal) async {
    final res = await api.req(
      "$url/goal",
      method: HttpMethod.post,
      query: {"memberId": memberId},
      body: {"steps": goal},
    );

    if (res.statusCode == 200) {
      return;
    } else {
      throw Exception('Update walk goal failed');
    }
  }
}
