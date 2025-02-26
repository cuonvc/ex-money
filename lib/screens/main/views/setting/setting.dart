import 'dart:convert';
import 'dart:developer';

import 'package:ex_money/screens/auth/blocs/account_setting/account_setting_bloc.dart';
import 'package:ex_money/screens/auth/blocs/notification_turn/notification_turn_bloc.dart';
import 'package:ex_money/screens/auth/blocs/password_change/password_change_bloc.dart';
import 'package:ex_money/screens/auth/blocs/sign_out/sign_out_bloc.dart';
import 'package:ex_money/screens/main/views/setting/password_change.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/base_text_field_submit.dart';
import 'package:ex_money/widgets/button_view.dart';
import 'package:ex_money/widgets/dialog_confirm.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../widgets/base_text_field.dart';
import '../../blocs/get_home_overview/home_overview_bloc.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  TextEditingController nameController = TextEditingController();
  bool notificationOn = false;
  bool signOutLoading = false;
  bool saveInfoLoading = false;
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

  //bỏ đi vì auto save không thể để validate đc
  // Future<void> fetchSaveDispName(String displayName) async {
  //   context.read<AccountSettingBloc>().add(
  //       AccountSettingEv(name: displayName.trim())
  //   );
  // }

  void onBackScreen(BuildContext ctx) {
    Navigator.pop(ctx);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AccountSettingBloc, AccountSettingState>(
          listener: (context, state) async {
            if (state is AccountSettingLoading) {
              setState(() {
                saveInfoLoading = true;
              });
            } else if (state is AccountSettingSuccess) {
              setState(() {
                userInfo = state.data;
                nameController.text = userInfo.name;
                saveInfoLoading = false;
              });
              context.read<HomeOverviewBloc>().add(HomeOverViewEv(month: null, year: null, isReload: true));
            } else if (state is AccountSettingFailure) {
              if (state.statusCode == 403) {
                await showDialogToRedirectLogin(context, state.message);
              } else {
                showDialogResponse(context, false, "Có lỗi xảy ra", state.message);
              }
              setState(() {
                saveInfoLoading = false;
              });
            }
          },
        ),
        BlocListener<NotificationTurnBloc, NotificationTurnState>(
          listener: (context, state) async {
            if (state is NotificationTurnFailure) {
              if (state.statusCode == 403) {
                await showDialogToRedirectLogin(context, state.message);
              } else {
                showDialogResponse(context, false, "Có lỗi xảy ra", state.message);
              }
            }
          },
        ),
        BlocListener<SignOutBloc, SignOutState>(
          listener: (context, state) async {
            if (state is SignOutLoading || state is SignOutInitial) {
              setState(() {
                signOutLoading = true;
              });
            } else if (state is SignOutFailure) {
              setState(() {
                signOutLoading = false;
              });
              if (state.statusCode == 403) {
                await showDialogToRedirectLogin(context, state.message);
              } else {
                showDialogResponse(context, false, "Có lỗi xảy ra", state.message);
              }
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
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      backgroundImage: (userInfo.avatarUrl != null && userInfo.avatarUrl!.isNotEmpty) ? NetworkImage(userInfo.avatarUrl!) : const AssetImage('assets/images/profile/avt.png'),
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
                    BaseTextField(
                      controller: nameController,
                      inputType: TextInputType.text,
                      icon: null,
                      hintText: "",
                      passwordField: false,
                      isValidNumber: false,
                      numberValid: null,
                    ),
                    const SizedBox(height: 20,),
                    GestureDetector(
                      onTap: () {
                        context.read<AccountSettingBloc>().add(
                            AccountSettingEv(name: nameController.text.trim())
                        );
                      },
                      child: saveInfoLoading ? buttonLoading(false, null) : buttonView(false, "Lưu thông tin", null),
                    )
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
