import 'package:ecommerce/features/home/ui/screens/home_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavCubit extends Cubit<int> {
  NavCubit() : super(0);
  void changeTap(int index) => emit(index);
  void reset() => emit(0);
}
