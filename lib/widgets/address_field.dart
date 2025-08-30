import 'package:care/models/constants/route_name.dart';
import 'package:care/utils/validators.dart';
import 'package:care/widgets/custom_text_field.dart';
import 'package:daum_postcode_search/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AddressField extends StatelessWidget {
  const AddressField(
      {super.key, required this.addressCtrl, required this.detailAddressCtrl});

  final TextEditingController addressCtrl;
  final TextEditingController detailAddressCtrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      children: [
        GestureDetector(
          onTap: () async {
            final result =
                await context.push(RouteName.searchAddress) as DataModel?;
            if (result == null) return;
            addressCtrl.text = result.roadAddress;
          },
          child: AbsorbPointer(
            child: CustomTextField(
              controller: addressCtrl,
              hintText: "도로명 주소 찾기",
              validator: (value) =>
                  Validators.emptyValidator(value, data: "주소를"),
              title: "집주소",
              suffix: SvgPicture.asset("assets/icons/ic_20_search.svg"),
            ),
          ),
        ),
        CustomTextField(
          controller: detailAddressCtrl,
          hintText: "상세주소 입력하기",
          validator: (value) => null,
        ),
      ],
    );
  }
}
