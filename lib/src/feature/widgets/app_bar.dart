import 'package:flutter/material.dart';
import 'package:trippy/src/constant/colors.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'images/icon.png',
            height: 40,
            width: 40,
          ),
          const Texts(
            texts: 'Trippy',
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          const Icon(Icons.sort)
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
