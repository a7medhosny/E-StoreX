import 'package:ecommerce/core/helpers/cache_keys.dart';
import 'package:ecommerce/core/helpers/cache_network.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class OnboardingSecondScreen extends StatefulWidget {
  const OnboardingSecondScreen({super.key});

  @override
  State<OnboardingSecondScreen> createState() => _OnboardingSecondScreenState();
}

class _OnboardingSecondScreenState extends State<OnboardingSecondScreen> {
  List<bool> visibleList = List.generate(8, (_) => false);

  @override
  void initState() {
    super.initState();
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    for (int i = 0; i < visibleList.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          visibleList[i] = true;
        });
      }
    }
  }

  Widget _animatedItem({required Widget child, required bool isVisible}) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      child: child,
    );
  }

  Widget _buildCard(String text, bool isVisible) {
    return _animatedItem(
      isVisible: isVisible,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    bool isOutlined = false,
    bool isVisible = false,
  }) {
    return _animatedItem(
      isVisible: isVisible,
      child: SizedBox(
        height: 50.h,
        child:
            isOutlined
                ? OutlinedButton(
                  onPressed: onPressed,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/on_boarding2.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withAlpha(100)),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 24.h),
                    _buildCard('Welcome to our shop!', visibleList[0]),
                    _buildCard(
                      'Discover top brands and exclusive offers.',
                      visibleList[1],
                    ),
                    _buildCard(
                      'Start shopping now and enjoy a smooth experience.',
                      visibleList[2],
                    ),
                    SizedBox(height: 24.h),
                    _animatedItem(
                      isVisible: visibleList[3],
                      child: Text(
                        "BECOME A MEMBER",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _animatedItem(
                      isVisible: visibleList[4],
                      child: Text(
                        "Join us to get the best deals and updates.",
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // 🟢 الأزرار
                    _buildActionButton(
                      text: 'Join Us',
                      isVisible: visibleList[5],
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.loginRegisterTabSwitcher,
                          arguments: false,
                        );
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildActionButton(
                      text: 'Sign In',
                      isVisible: visibleList[6],
                      isOutlined: true,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.loginRegisterTabSwitcher,
                          arguments: true,
                        );
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildActionButton(
                      text: 'Continue as Guest',
                      isVisible: visibleList[7],
                      isOutlined: true,
                      onPressed: () {
                        if (TokenManager.guestId == null) {
                          final uuid = Uuid();
                          String guestId = uuid.v4();
                          print("Geust Id $guestId");
                          CacheNetwork.insertToCache(
                            key: CacheKeys.guestId,
                            value: guestId,
                          );
                        }
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.layoutScreen,
                          (route) => false,
                        );
                      },
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
