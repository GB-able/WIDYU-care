import 'package:flutter/material.dart';

class ParentInput {
  final TextEditingController nameCtrl;
  final TextEditingController birthDateCtrl;
  final TextEditingController phoneNumberCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController detailAddressCtrl;
  final TextEditingController inviteCodeCtrl;
  final GlobalKey<FormState> formKey;

  ParentInput({
    required this.nameCtrl,
    required this.birthDateCtrl,
    required this.phoneNumberCtrl,
    required this.addressCtrl,
    required this.detailAddressCtrl,
    required this.inviteCodeCtrl,
    required this.formKey,
  });
}

enum InputMode { edit, open, close }

class RegisterParentViewModel with ChangeNotifier {
  final List<ParentInput> accounts = [
    ParentInput(
      nameCtrl: TextEditingController(),
      birthDateCtrl: TextEditingController(),
      phoneNumberCtrl: TextEditingController(),
      addressCtrl: TextEditingController(),
      detailAddressCtrl: TextEditingController(),
      inviteCodeCtrl: TextEditingController(),
      formKey: GlobalKey<FormState>(),
    ),
  ];
  final List<InputMode> modes = [InputMode.edit];

  void addAccount() {
    accounts.add(
      ParentInput(
        nameCtrl: TextEditingController(),
        birthDateCtrl: TextEditingController(),
        phoneNumberCtrl: TextEditingController(),
        addressCtrl: TextEditingController(),
        detailAddressCtrl: TextEditingController(),
        inviteCodeCtrl: TextEditingController(),
        formKey: GlobalKey<FormState>(),
      ),
    );
    modes.add(InputMode.edit);
    notifyListeners();
  }

  void removeAccount(int idx) {
    accounts[idx].nameCtrl.dispose();
    accounts[idx].birthDateCtrl.dispose();
    accounts[idx].phoneNumberCtrl.dispose();
    accounts[idx].addressCtrl.dispose();
    accounts[idx].detailAddressCtrl.dispose();
    accounts[idx].inviteCodeCtrl.dispose();
    accounts.removeAt(idx);
    modes.removeAt(idx);
    notifyListeners();
  }

  void setMode(int idx, InputMode mode) {
    if (modes[idx] == InputMode.edit && mode == InputMode.open) {
      if (accounts[idx].formKey.currentState?.validate() ?? false) {
        modes[idx] = mode;
      } else {
        return;
      }
    }
    modes[idx] = mode;
    notifyListeners();
  }

  Future<bool> register() async {
    return true;
  } // [TODO] 부모님 생성 로직 넣기
}
