import 'dart:convert';
import 'dart:developer';

import 'package:ex_money/screens/auth/blocs/account_setting/account_setting_bloc.dart';
import 'package:ex_money/screens/auth/blocs/notification_turn/notification_turn_bloc.dart';
import 'package:ex_money/screens/auth/blocs/password_change/password_change_bloc.dart';
import 'package:ex_money/screens/auth/blocs/sign_out/sign_out_bloc.dart';
import 'package:ex_money/screens/main/views/setting/password_change.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/base_text_field_submit.dart';
import 'package:ex_money/widgets/dialog_confirm.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  TextEditingController nameController = TextEditingController();
  bool notificationOn = false;
  bool signOutLoading = false;
  late UserResponse userInfo = UserResponse.empty();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    final info = await getUserInfo();
    setState(() {
      userInfo = info.user;
      nameController.text = userInfo.name;
      notificationOn = userInfo.notificationOn;
    });
  }

  Future<SignInResponse> getUserInfo() async {
    final prefs= await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
    );
    final partOfPrefKey = CachedPrefKey.signInRespPref;
    try {
      final Object? info = prefs.get(partOfPrefKey);
      List<dynamic> fromDisk = jsonDecode(info.toString());
      SignInResponse dataFromDisk = SignInResponse.fromMap(fromDisk);
      return dataFromDisk;
    } catch (e) {
      Navigator.pushNamed(context, NavigatePath.authSelectionPath);
      rethrow;
    }
  }

  Future<void> fetchSearch(String displayName) async {
    log("Display name save -> $displayName");
    context.read<AccountSettingBloc>().add(
        AccountSettingEv(name: displayName.trim())
    );
  }

  void onBackScreen(BuildContext ctx) {
    Navigator.pop(ctx);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AccountSettingBloc, AccountSettingState>(
          listener: (context, state) {
            if (state is AccountSettingSuccess) {
              setState(() {
                userInfo = state.data;
                nameController.text = userInfo.name;
              });
            } else if (state is AccountSettingFailure) {
              showDialogResponse(context, false, "Cập nhật thông tin tài khoản", state.message);
            }
          },
        ),
        BlocListener<NotificationTurnBloc, NotificationTurnState>(
          listener: (context, state) {
            if (state is NotificationTurnFailure) {
              showDialogResponse(context, false, "Bật / tắt thông báo", "Có lỗi xảy ra");
            }
          },
        ),
        BlocListener<SignOutBloc, SignOutState>(
          listener: (context, state) {
            if (state is SignOutLoading || state is SignOutInitial) {
              setState(() {
                signOutLoading = true;
              });
            } else if (state is SignOutFailure) {
              setState(() {
                signOutLoading = false;
              });
              showDialogResponse(context, false, "Đăng xuất tài khoản", "Có lỗi xảy ra");
            } else {
              setState(() {
                signOutLoading = false;
              });
              Navigator.pushNamedAndRemoveUntil(
                context,
                NavigatePath.authSelectionPath, (route) => false,
              );
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (!didPop) {
            onBackScreen(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
                "Thiết lập tài khoản",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),
            ),
            centerTitle: true,
            leading: ModalRoute.of(context)!.canPop
                ? IconButton(onPressed: () => onBackScreen(context),
                icon: const Icon(Icons.arrow_back_ios_new))
                : null,
          ),

          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
            child: ListView(
              children: [
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userInfo.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20
                          ),
                        ),
                        Text(userInfo.email)
                      ],
                    ),
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/images/profile/avt.png'),
                    )
                  ],
                ),

                // const Padding(
                //   padding: EdgeInsets.symmetric(vertical: 20.0),
                //   child: Divider(color: cLineText, thickness: 1),
                // ),
                const SizedBox(height: 30,),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(width: 6,),
                    Text("Thông tin cá nhân")
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tên hiển thị", style: TextStyle(color: cTextDisable, fontSize: 12),),
                    const SizedBox(height: 6,),
                    BaseTextFieldSubmit(
                      controller: nameController,
                      inputType: TextInputType.text,
                      icon: null,
                      hintText: "",
                      submitBtn: false,
                      fetchMethod: fetchSearch,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute<SignInModel>(
                          builder: (BuildContext ctx) => BlocProvider(
                            create: (ctx) => PasswordChangeBloc(UserRepositoryImpl()),
                            child: const PasswordChange(),
                          ),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.settings_outlined),
                      SizedBox(width: 6,),
                      Text("Đổi mật khẩu")
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Nhận thông báo"),
                    CupertinoSwitch(
                      value: notificationOn,
                      activeTrackColor: cPrimary,
                      onChanged: (value) {
                        setState(() {
                          notificationOn = value;
                        });
                        context.read<NotificationTurnBloc>().add(
                            NotificationTurnEv(on: value)
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 60,),

                GestureDetector(
                  onTap: () async {
                    bool confirmed = await showDialogConfirm(context, "Đăng xuất", "Bạn có chắc chắn muốn đăng xuất?", null, "Đăng xuất");
                    if (confirmed) {
                      context.read<SignOutBloc>().add(SignOutEv());
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red[400],),
                      const SizedBox(width: 6,),
                      Text("Đăng xuất", style: TextStyle(color: Colors.red[400]),)
                    ],
                  ),
                ),

                const SizedBox(height: 50,),

                const Text(
                    "Đây là đồ án tốt nghiệp do sinh viên Nguyễn Văn Cường - 2055010026 - Khoa Công nghệ thông tin - Trường Đại học Kiến Trúc Hà Nội thực hiện \n\nContact: cuong.fithau@gmail.com",
                  style: TextStyle(color: cTextDisable, fontSize: 12),
                ),
                const SizedBox(height: 20,),
                const Text("")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
