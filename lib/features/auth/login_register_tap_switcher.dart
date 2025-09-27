import 'package:ecommerce/features/auth/login/ui/screens/login_screen.dart';
import 'package:ecommerce/features/auth/register/ui/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginRegisterTabSwitcher extends StatefulWidget {
  final bool initialTabIsLogin;

  const LoginRegisterTabSwitcher({super.key, this.initialTabIsLogin = true});

  @override
  State<LoginRegisterTabSwitcher> createState() =>
      _LoginRegisterTabSwitcherState();
}

class _LoginRegisterTabSwitcherState extends State<LoginRegisterTabSwitcher> {
  late bool isLogin;

  @override
  void initState() {
    super.initState();
    isLogin = widget.initialTabIsLogin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              _buildTabSwitcher(),
              Expanded(
                child: isLogin ? const LoginScreen() : const RegisterScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return SizedBox(
      height: 40.h,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() => isLogin = true);
                },
                child: Text(
                  'SIGN IN',
                  style: TextStyle(fontSize: 12.sp, color: Colors.black),
                ),
              ),
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () {
                  setState(() => isLogin = false);
                },
                child: Text(
                  'I\'M NEW HERE',
                  style: TextStyle(fontSize: 12.sp, color: Colors.black),
                ),
              ),
            ],
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: isLogin ? 0.w : 65.w,
            top: 22.h,
            child: Container(
              width: isLogin ? 45.w : 80.w,
              height: 2.h,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
