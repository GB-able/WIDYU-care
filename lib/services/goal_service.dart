import 'package:care/models/api_response.dart';
import 'package:care/models/dtos/family_member_dto.dart';
import 'package:care/services/api.dart';
import 'package:care/utils/extensions.dart';

class GoalService {
  final API api = API();
  final String url = "/goals/home";

  Future<ApiResponse<FamilyMembersDto>> getFamilies() async {
    final res = await api.req(
      "$url/families",
      method: HttpMethod.get,
    );

    return res.toApiResponse(FamilyMembersDto.fromJson);
  }

  // Future<GoalHomeDto> getGoalHome(int memberId) async {
  //   final res = await api.req(
  //     "$url/guardian",
  //     method: HttpMethod.get,
  //     query: {"memberId": memberId},
  //   );

  //   return res.toApiResponse<GoalHomeDto>(GoalHomeDto.fromJson);
  // }
}
