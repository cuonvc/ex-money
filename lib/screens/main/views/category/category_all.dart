import 'package:ex_money/screens/main/blocs/get_category/get_category_bloc.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:ex_money/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

class CategoryAll extends StatefulWidget {
  num? walletId;
  CategoryAll({super.key, this.walletId});

  @override
  State<CategoryAll> createState() => _CategoryAllState();
}

class _CategoryAllState extends State<CategoryAll> {
  @override
  Widget build(BuildContext context) {

    // final data = ModalRoute.of(context)?.settings.arguments as String;
    // String walletId = data;
    final data = widget.walletId;

    return Scaffold(
      appBar: AppBar(
        title: Text("Tất cả danh mục")
      ),
      body: BlocProvider(
        create: (context) => GetCategoryBloc(CategoryRepositoryImpl())..add(GetCategoryEv(data)),
        child: BlocBuilder<GetCategoryBloc, GetCategoryState>(
          builder: (context, state) {
            if (state is GetCategoryFailure) {
              return Center(child: Text(state.message),);
            } else if (state is GetCategoryLoading) {
              return const Center(child: Loading(),);
            } else if (state is GetCategorySuccess) {
              List<ExpenseCategoryResponse> list = state.data;
              return ListView(children: _buildCategoryList(list),);
            } else {
              return Center(child: Text("Ops! Có lỗi xảy ra"),);
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
    return ParentCategoryTile(category: category);
  }
}

class ParentCategoryTile extends StatefulWidget {
  final ExpenseCategoryResponse category;

  const ParentCategoryTile({super.key, required this.category});

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
          onTap: () {
            Navigator.pop(context, widget.category);
          },
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Arrow icon with tap detection to expand/hide children
                GestureDetector(
                  onTap: toggleExpansion,
                  child: AnimatedRotation(
                    turns: isExpanded ? 0.75 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Space between arrow and main icon
                Icon(Icons.fastfood, size: 28,),
              ],
            ),
            title: Text(widget.category.name),
            trailing: IconButton(
              icon: Icon(Icons.edit_note_outlined, color: cPrimary),
              onPressed: () {
                // Add your edit action here
              },
            ),
          ),
        ),
        // Expanded children list
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 56.0),
            // Indent child categories
            child: Column(
              children: widget.category.children
                  .map((subcategory) =>
                  ListTile(
                    leading: Icon(Icons.emoji_food_beverage_rounded, size: 28,),
                    title: Text(subcategory.name),
                    trailing: IconButton(
                      icon: Icon(Icons.edit_note_outlined, color: cPrimary),
                      onPressed: () {
                        // Add edit action for subcategory
                      },
                    ),
                  ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}