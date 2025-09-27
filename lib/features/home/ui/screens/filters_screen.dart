import 'package:ecommerce/core/helpers/strings.dart';
import 'package:ecommerce/features/shop/categories/data/models/category_model.dart';
import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String selectedOption = 'Our Picks';
  List<CategoryModel> categories = [];
  int selectedCategory = -1;
  @override
  void initState() {
    categories = context.read<HomeCubit>().localCategories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implement logic to reset filters to default
              setState(() {
                selectedOption = Strings.ourPicks;
                selectedCategory = -1;
              });
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12.h),
              _buildRadioListTile(Strings.ourPicks),
              // _buildRadioListTile('New Items'),
              _buildRadioListTile(Strings.highPrice),
              _buildRadioListTile(Strings.lowPrice),
              SizedBox(height: 20.h),
              Divider(height: 1, color: Colors.grey[300]),
              SizedBox(height: 20.h),
              Text(
                'Filter by',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12.h),
              _buildFilterByListView(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          onPressed: () {
            // context.read<HomeCubit>().filterProducts(
            //   sortBy: selectedOption,
            //   filterBy:
            //       selectedCategory == -1
            //           ? ''
            //           : categories[selectedCategory].name,
            // );
            // Navigator.of(context).pop();
          },
          child: Text(
            'Apply Filters',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioListTile(String title) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: TextStyle(fontSize: 14.sp, color: Colors.black87),
      ),
      value: title,
      groupValue: selectedOption,
      onChanged: (value) {
        setState(() {
          selectedOption = value!;
        });
      },
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeColor: Colors.black,
    );
  }

  _buildFilterByListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildFilterByListTile(index);
      },
      itemCount: categories.length,
    );
  }

  _buildFilterByListTile(int index) {
    return ListTile(
      onTap: () {
        setState(() {
          if (selectedCategory != index) {
            selectedCategory = index;
          } else {
            selectedCategory = -1;
          }
        });
      },
      title: Text(
        categories[index].name,
        style: TextStyle(fontSize: 14.sp, color: Colors.black87),
      ),
      trailing: selectedCategory == index ? Icon(Icons.done) : null,
    );
  }
}
