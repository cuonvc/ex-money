import 'dart:developer';

import 'package:ex_money/screens/main/blocs/get_category/get_category_bloc.dart';
import 'package:ex_money/screens/main/blocs/save_category/save_category_bloc.dart';
import 'package:ex_money/screens/main/views/category_detail/category_detail.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/base_text_field_submit.dart';
import 'package:ex_money/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

class CategoryAll extends StatefulWidget {
  final num? walletId;
  const CategoryAll({super.key, required this.walletId});

  @override
  State<CategoryAll> createState() => _CategoryAllState();
}

class _CategoryAllState extends State<CategoryAll> {

  List<Map<dynamic, dynamic>> walletNameList = [];

  @override
  Widget build(BuildContext context) {

    // final data = ModalRoute.of(context)?.settings.arguments as String;
    // String walletId = data;
    TextEditingController keywordController = TextEditingController();
    final data = widget.walletId;

    return Scaffold(
      backgroundColor: cBackground,
      appBar: AppBar(
        backgroundColor: cBackground,
        leading: ModalRoute.of(context)!.canPop
            ? IconButton(onPressed: () => Navigator.pop(context, null), icon: const Icon(Icons.arrow_back_ios_new))
            : null,
        centerTitle: true,
        title: const Text("Tất cả danh mục", style: TextStyle(fontSize: 18),),
        actions: const [
          Icon(Icons.add, color: cPrimary,)
        ],
      ),
      body: BlocProvider(
        create: (context) => GetCategoryBloc(CategoryRepositoryImpl())..add(GetCategoryEv(walletId: data, isReload: false)),
        child: BlocBuilder<GetCategoryBloc, GetCategoryState>(
          builder: (context, state) {
            if (state is GetCategoryFailure) {
              return Center(child: Text(state.message),);
            } else if (state is GetCategoryLoading) {
              return const Center(child: Loading(),);
            } else if (state is GetCategorySuccess) {
              List<ExpenseCategoryResponse> list = state.data;
              walletNameList = state.walletListInfo;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: ConstantSize.hozPadScreen),
                child: Column(
                  children: [
                    BaseTextFieldSubmit(
                        controller: keywordController,
                        inputType: TextInputType.text,
                        icon: Icons.search,
                        hintText: "Tên, mô tả danh mục",
                        submitBtn: true,
                        fetchMethod: fetchSearch
                    ),
                    Expanded(child: ListView(children: _buildCategoryList(list),))
                  ],
                ),
              );
            } else {
              return const Center(child: Text("Ops! Có lỗi xảy ra"),);
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildCategoryList(List<ExpenseCategoryResponse> categories) {
    return categories.map((item) => _buildCategoryItem(item)).toList();
  }

  Widget _buildCategoryItem(ExpenseCategoryResponse category) {
    //from ChatGPT
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: cGreyBackground,
      ),
      child: ParentCategoryTile(category: category, walletNameList: walletNameList,)
    );
  }

  Future<void> fetchSearch(String keyword) async {
    log("Keyword searching -> $keyword");
  }
}

class ParentCategoryTile extends StatefulWidget {
  final ExpenseCategoryResponse category;
  final List<Map<dynamic, dynamic>> walletNameList;

  const ParentCategoryTile({super.key, required this.category, required this.walletNameList});

  @override
  _ParentCategoryTileState createState() => _ParentCategoryTileState();
}

class _ParentCategoryTileState extends State<ParentCategoryTile> {
  bool isExpanded = true;

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context, widget.category),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: toggleExpansion,
                    child: AnimatedRotation(
                      turns: isExpanded ? 0.75 : 0.5,
                      duration: const Duration(milliseconds: 200),
                      child: widget.category.children.isNotEmpty
                          ? const Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.grey,
                      ) : const SizedBox(),
                    ),
                  ),
                  const SizedBox(width: 10), // Space between arrow and main icon
                  Image.asset("assets/images/category/${widget.category.iconImage}.png", scale: 4.5,),
                  const SizedBox(width: 10,),
                  Text(widget.category.name),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right, color: cPrimary),
                onPressed: () async {
                  ExpenseCategoryResponse? expUpdated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => BlocProvider(
                          create: (ctx) => SaveCategoryBloc(CategoryRepositoryImpl()),
                          child: CategoryDetail(category: widget.category, walletNameList: widget.walletNameList,),
                        )
                    ),
                  );

                  if (expUpdated != null) {
                    //...
                  }
                },
              ),
            ],
          ),
        ),
        // Expanded children list
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 30),
            // Indent child categories
            child: Column(
              children: widget.category.children.map((subcategory) =>
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.pop(context, subcategory),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 30,),
                          Image.asset("assets/images/category/${subcategory.iconImage}.png", scale: 4.5,),
                          const SizedBox(width: 10,),
                          Text(subcategory.name),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_right, color: cPrimary),
                        onPressed: () {
                          // Add edit action for subcategory
                        },
                      ),
                    ],
                  ),
                )
              ).toList(),
            ),
          ),
      ],
    );
  }
}