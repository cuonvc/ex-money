import 'dart:developer';

import 'package:ex_money/screens/main/blocs/save_note/save_note_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/dialog_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

class NoteDetailScreen extends StatefulWidget {
  final NoteModel? data;

  const NoteDetailScreen({super.key, required this.data});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  NoteModel noteData = NoteModel.empty();

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      noteData = widget.data!;
      if (noteData.title.isNotEmpty) {
        titleController.text = noteData.title;
      }
      if (noteData.content.isNotEmpty) {
        contentController.text = noteData.title;
      }
    }
  }

  void onBackScreen(BuildContext ctx) {
    noteData.title = titleController.text;
    noteData.content = contentController.text;
    ctx.read<SaveNoteBloc>().add(SaveNoteEv(id: noteData.id, data: noteData));

    // String nowFormatedLikeServer = DateTime.now().toIso8601String();
    // noteData.updatedAt = nowFormatedLikeServer;
    // Navigator.pop(ctx, noteData);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          onBackScreen(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: ModalRoute.of(context)!.canPop
              ? IconButton(onPressed: () => onBackScreen(context),
              icon: const Icon(Icons.arrow_back_ios_new))
              : null,
          automaticallyImplyLeading: false,
        ),
        body: BlocListener<SaveNoteBloc, SaveNoteState>(
          listener: (context, state) {
            if (state is SaveNoteInitial || state is SaveNoteLoading) {

            } else if (state is SaveNoteSuccess) {
              Navigator.pop(context, state.data);
            } else if (state is SaveNoteFailure) {
              showDialogResponse(context, false, "Lưu ghi chú", state.message);
              Navigator.pop(context, null);
            } else {
              Navigator.pop(context, null);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: ConstantSize.hozPadScreen),
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.multiline,
                  cursorColor: cLineText,
                  minLines: 1,
                  maxLines: 3,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                  ),
                  decoration: const InputDecoration(
                    hintText: "Tiêu đề",
                    hintStyle: TextStyle(
                        color: cTextDisable,
                        fontSize: 20,
                        fontWeight: FontWeight.w400
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),

                Expanded(
                  child: TextFormField(
                    controller: contentController,
                    keyboardType: TextInputType.multiline,
                    expands: true,
                    maxLines: null,
                    cursorColor: cLineText,
                    decoration: const InputDecoration(
                      hintText: "Nội dung",
                      hintStyle: TextStyle(
                          color: cTextDisable,
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
