// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trippy/src/constant/app_spaces.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';
import 'package:trippy/src/feature/widgets/containers.dart';

class Card_3D extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String desc;
  final String price;
  final void Function()? onTap;

  const Card_3D({
    required this.imageUrl,
    required this.title,
    required this.desc,
    super.key,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Containers(
        onTap: onTap,
        width: double.infinity,
        height: 107,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 194, 193, 193).withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: double.infinity,
                width: 107, // Adjust width as needed
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.asset(
                  'images/pink.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Text section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Texts(
                      texts: title.capitalizeFirst.toString(),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: Containers(
                        width: maxWidth(context),
                        child: Column(
                          children: [
                            Expanded(
                              child: Containers(
                                width: maxWidth(context),
                                child: Text(
                                  desc,
                                  maxLines: 3,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color:
                                        const Color.fromRGBO(164, 164, 164, 1),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: Containers(
                                width: maxWidth(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Rs ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      price,
                                      maxLines: 3,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      ' each',
                                      maxLines: 3,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Containers(
                      // onTap: () {
                      //   Get.to(() => const TripPlannerPage());
                      // },
                      width: 110,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(56, 183, 255, 1),
                            Color.fromRGBO(131, 165, 255, 1),
                          ],
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(width: 2),
                          Icon(
                            CupertinoIcons.paperplane_fill,
                            color: Colors.white,
                            size: 16,
                          ),
                          Texts(
                            texts: 'More info',
                            fontSize: 4,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          SizedBox(width: 2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
