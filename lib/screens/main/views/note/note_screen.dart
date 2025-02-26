import 'dart:developer';

import 'package:ex_money/screens/main/blocs/delete_note/delete_note_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_note_list/get_note_list_bloc.dart';
import 'package:ex_money/screens/main/blocs/save_note/save_note_bloc.dart';
import 'package:ex_money/screens/main/blocs/update_expense/update_expense_bloc.dart';
import 'package:ex_money/screens/main/views/note/note_detail_screen.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/utils/utils.dart';
import 'package:ex_money/widgets/dialog_confirm.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:ex_money/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  bool isLoading = false;
  List<NoteModel> dataList = [];

  @override
  void initState() {
    super.initState();
    context.read<GetNoteListBloc>().add(const GetNoteListEv());
  }

  Future<void> doSaveNote(BuildContext ctx, NoteModel? oldItem) async {
    NoteModel noteUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext ctx) => NoteDetailScreen(data: oldItem,),
      ),
    );
    
    //call to server (new or update)
    ctx.read<SaveNoteBloc>().add(SaveNoteEv(id: noteUpdated.id, data: noteUpdated));
  }

  List<NoteModel> doChangeView(List<NoteModel> currentList, NoteModel noteUpdated) {

    bool isEqual = false;
    for (int i = 0; i < currentList.length; i++) {
      if (currentList[i].id == noteUpdated.id) {
        isEqual = true;
        currentList[i] = noteUpdated;
      }
    }

    //new item
    if (!isEqual) {
      currentList.add(noteUpdated);
    }
    
    // if (noteUpdated.id != null) { //update
    //   for (int i = 0; i < currentList.length; i++) {
    //     if (currentList[i].id == noteUpdated.id) {
    //       currentList[i] = noteUpdated;
    //     }
    //   }
    // } else { //new
    //   list.add(noteUpdated);
    // }

    currentList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return currentList;
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<GetNoteListBloc, GetNoteListState>(
        listener: (context, state) async {
          if (state is GetNoteListLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is GetNoteListSuccess) {
            setState(() {
              isLoading = false;
              dataList = state.list;
            });
          } else if (state is GetNoteListFailure) {
            setState(() {
              isLoading = false;
            });
            if (state.statusCode == 403) {
              await showDialogToRedirectLogin(context, state.message);
            } else {
              showDialogResponse(context, false, "Có lỗi xảy ra", state.message);
            }
          }
        },
        child: isLoading ? const Center(child: Loading(loadingColor: null,),) : BlocListener<SaveNoteBloc, SaveNoteState>(
          listener: (context, state) async {
            if (state is SaveNoteInitial || state is SaveNoteLoading) {

            } else if (state is SaveNoteSuccess) {
              List<NoteModel> listUpdated = doChangeView(dataList, state.data);
              setState(() {
                dataList = listUpdated;
              });
            } else if (state is SaveNoteFailure) {
              if (state.statusCode == 403) {
                await showDialogToRedirectLogin(context, state.message);
              } else {
                showDialogResponse(context, false, "Có lỗi xảy ra", state.message);
              }
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<GetNoteListBloc>().add(const GetNoteListEv());
            },
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: const Text(
                    "Ghi chú nhanh",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () async {
                        await doSaveNote(context, null);
                        // setState(() {
                        //   dataList = afterSync;
                        // });
                      },
                      child: const Icon(Icons.add, color: cPrimary,),
                    )
                  ],
                ),
                body: dataList.isNotEmpty ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 200 /*height of item*/),
                      child: Wrap(
                        spacing: ConstantSize.hozPadScreen / 2,
                        runSpacing: ConstantSize.hozPadScreen / 2,
                        children: List.generate(dataList.length, (index) {
                          double marginLR = 3;
                          double itemHeight = 200;
                          double itemWidth =
                              MediaQuery.sizeOf(context).width / 2 //chia đôi screen
                                  - ConstantSize.hozPadScreen      //bỏ mép screen
                                  - ConstantSize.hozPadScreen / 4  //khoảng cách giữa 2 item = hozPadScreen/2 -> 1 nửa khoảng cách = hozPadScreen/4
                                  - marginLR;                      //margin left or right
                          NoteModel item = dataList[index];
                          return GestureDetector(
                            onTap: () async {
                              await doSaveNote(context, item);
                              // setState(() {
                              //   dataList = afterSync;
                              // });
                            },
                            child: GestureDetector(
                              onLongPress: () async {
                                bool confirmed = await showDialogConfirm(context, "Xóa ghi chú", "Bạn có chắc chắn muốn xóa bản ghi chú này?", null, null);
                                if (confirmed) {
                                  context.read<DeleteNoteBloc>().add(DeleteNoteEv(id: item.id!));
                                  setState(() {
                                    dataList.removeWhere((e) => e.id == item.id);
                                  });
                                }
                              },
                              child: Container(
                                width: itemWidth,
                                height: itemHeight, //tạm
                                padding: const EdgeInsets.all(8),
                                margin: index % 2 == 0 ? EdgeInsets.only(left: marginLR) : EdgeInsets.only(right: marginLR),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        // offset: const Offset(0, 10), // changes position of shadow
                                      ),
                                    ]
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title.isNotEmpty ? item.title : "Ghi chú trống",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: item.title.isNotEmpty ? cText : cTextDisable
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4,),
                                        Text(
                                          item.content,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: cText
                                          ),
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          dateTimeFormatedFromStr(item.updatedAt, false),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              color: cTextDisable
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ) /* : (isLoading ? const Center(child: Loading(loadingColor: null),) : const Center(child: Text("Chưa có ghi chú nào"),)) */
                ) : const Center(child: Text("Chưa có ghi chú nào"),)
            ),
          ),
        ),
    );
  }
}
