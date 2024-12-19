import 'package:ex_money/screens/main/views/category/category_all.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:repository/repository.dart';

class SelectCategory extends StatefulWidget {
  ExpenseCategoryResponse? categorySelected;
  TextEditingController categoryController;
  num? walletId;


  SelectCategory({
    super.key,
    required this.categorySelected,
    required this.categoryController,
    required this.walletId
  });

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  @override
  Widget build(BuildContext context) {
    ExpenseCategoryResponse? selected = widget.categorySelected;
    TextEditingController controller = widget.categoryController;
    num? walletId = widget.walletId;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            iconStyle(Icons.format_list_bulleted),
            const SizedBox(width: 10,),
            selected == null || selected.id == 0
                ? Text("Danh mục", style: hintStyle(),)
                : Text(selected.name, style: selectedStyle(),)
          ],
        ),
        const SizedBox(width: 8,),
        GestureDetector(
          onTap: () async {
            // Navigator.pushNamed(context, NavigatePath.categoryListPath, arguments: walletId);
            ExpenseCategoryResponse? category = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryAll(walletId: walletId,))
            );
            if (category != null) {
              setState (() {
                selected = category;
                controller.text = selected!.id.toString();
              });
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Tất cả", style: hintStyle(),),
              iconStyle(Icons.keyboard_arrow_right)
            ],
          ),
        )
      ],
    );
  }

  Widget iconStyle(IconData icon) {
    return Icon(
      icon,
      size: 20,
      color: cTextDisable,
    );
  }

  TextStyle hintStyle() {
    return const TextStyle(
      fontSize: 16,
      color: cTextDisable,
    );
  }

  TextStyle selectedStyle() {
    return const TextStyle(
      fontSize: 16,
      color: cText,
    );
  }
}
