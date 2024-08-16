// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:trippy/src/constant/colors.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';

class kBar extends StatelessWidget implements PreferredSizeWidget {
  const kBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'images/icon.png',
            height: 40,
            width: 40,
          ),
          const SizedBox(width: 110),
          const Texts(
            textAlign: TextAlign.center,
            texts: 'Trippy',
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
