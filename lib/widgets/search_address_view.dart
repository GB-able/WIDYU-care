import 'package:care/widgets/custom_app_bar.dart';
import 'package:daum_postcode_search/widget.dart';
import 'package:flutter/material.dart';

class SearchAddressView extends StatefulWidget {
  const SearchAddressView({super.key});

  @override
  State<SearchAddressView> createState() => _SearchAddressViewState();
}

class _SearchAddressViewState extends State<SearchAddressView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "주소 검색"),
      body: Column(
        children: [
          Expanded(
            child: DaumPostcodeSearch(),
          ),
        ],
      ),
    );
  }
}
