import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/model/Vendor/workshop.model.dart';
import 'package:car_fix_up/views/components/vendor_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../resources/constatnt.dart';

class WorkshopTile extends StatelessWidget {
  final Vendor vendor;
  final Function() onTap;
  const WorkshopTile({super.key, required this.vendor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0.05.sw,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 0.15.sh,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0.02.sw),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0.5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 0.34.sw,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.02.sw),
                      bottomLeft: Radius.circular(0.02.sw)),
                  image: DecorationImage(
                    image: AssetImage(
                      vendor.workshop.imageUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      vendor.workshop.name,
                      style: GoogleFonts.oxanium(
                        color: kBlackColor,
                        fontSize: 0.04.sw,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${vendor.workshop.area},${vendor.workshop.city}",
                      style: GoogleFonts.oxanium(
                        color: kBlackColor,
                        fontSize: 0.03.sw,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              //Rating
              Padding(
                padding: EdgeInsets.only(left: 0.1.sw),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      vendor.workshopReviews.length > 1
                          ? avgRating(vendor).toStringAsFixed(2)
                          : "0.0",
                      style: GoogleFonts.oxanium(
                        color: kBlackColor,
                        fontSize: 0.04.sw,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: kPrimaryColor,
                      size: 0.05.sw,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
