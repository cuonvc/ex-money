import 'package:ex_money/screens/main/blocs/get_category/get_category_bloc.dart';
import 'package:ex_money/screens/main/blocs/get_expense/get_expense_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {

    final data = ModalRoute.of(context)?.settings.arguments as String;
    String walletId = data;

    return Scaffold(
      appBar: AppBar(
        title: Text("All category"),
      ),
      body: BlocProvider(
        create: (context) => GetCategoryBloc(CategoryRepositoryImpl())..add(GetCategoryEv(walletId)),
        child: BlocBuilder<GetCategoryBloc, GetCategoryState>(
          builder: (context, state) {
            if (state is GetCategoryFailure) {
              return const Center(child: Text("Fail to get categories"),);
            } else if (state is GetCategoryLoading) {
              return const Center(child: CircularProgressIndicator(),);
            } else {
              List data = state.props;
              if(data.isNotEmpty) {
                final List<ExpenseCategoryResponse> list = ExpenseCategoryResponse.fromList(data[0]);
                return ListView(children: _buildCategoryList(list),);
              } else {
                return Center();
              }
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
    if (category.children.isEmpty) {
      return ListTile(
        title: Text(category.name),
      );
    } else {
      return ExpansionTile(
        title: Text(category.name),
        children: _buildCategoryList(category.children),
      );
    }
  }
}
