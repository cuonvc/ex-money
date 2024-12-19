import 'package:ex_money/screens/main/blocs/create_wallet/create_wallet_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/base_description_field.dart';
import 'package:ex_money/widgets/base_text_field.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({super.key});

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  final TextEditingController walletNameController = TextEditingController();
  final TextEditingController walletDescriptionController = TextEditingController();

  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateWalletBloc, CreateWalletState>(
      listener: (context, state) {
        if (state is CreateWalletLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is CreateWalletSuccess) {
          Navigator.pop(context, state.wallet);
          showDialogResponse(context, true, "Tạo ví", "Đã tạo thành công");
        } else if (state is CreateWalletFailure) {
          Navigator.pop(context, null);
          showDialogResponse(context, false, "Tạo ví", state.message);
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
          ),
          width: double.infinity,
          // height: heightRoot,
          child: ListView(
            controller: controller,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tạo ví",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Tên ví"),
                    ),
                    BaseTextField(controller: walletNameController, inputType: TextInputType.text, icon: null,
                        hintText: "Tên ví của bạn", passwordField: false
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Mô tả"),
                    ),
                    BaseDescriptionField(controller: walletDescriptionController,
                      hintText: "Mô tả về ví của bạn", minLine: null, maxLine: null,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen, vertical: 30),
                child: isLoading ? buttonLoading(true, Colors.white)
                    : GestureDetector(
                    onTap: () {
                      context.read<CreateWalletBloc>().add(
                          CreateWalletEv(walletNameController.text, walletDescriptionController.text)
                      );
                    },
                    child: buttonView(true, "Tạo ví", Colors.white)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
