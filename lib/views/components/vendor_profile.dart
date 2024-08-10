import 'package:car_fix_up/model/vendor.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/views/User/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

double avgRating(Vendor vendor) {
  double totalRating = 0;
  for (var review in vendor.workshopReviews) {
    totalRating += review.rating;
  }
  return totalRating / vendor.workshopReviews.length;
}

class VendorProfile extends StatelessWidget {
  final Vendor vendor;
  const VendorProfile({required this.vendor, super.key});

  @override
  Widget build(BuildContext context) {
    double avgRating() {
      double totalRating = 0;
      for (var review in vendor.workshopReviews) {
        totalRating += review.rating;
      }
      return totalRating / vendor.workshopReviews.length;
    }

    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: BottomCurveClipper(),
            child: Container(
              height: 0.25.sh,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kBlackColor, Colors.grey[800]!],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0.05.sh),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: kWhiteColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: 0.1.sw,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.02.sh),
                    child: Text(
                      "Workshop Profile",
                      style: GoogleFonts.oxanium(
                        color: kPrimaryColor,
                        fontSize: 0.06.sw,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //Image
          Padding(
            padding:
                EdgeInsets.only(top: 0.01.sh, right: 0.03.sw, left: 0.03.sw),
            child: Container(
              padding: EdgeInsets.all(0.02.sw),
              height: 0.3.sh,
              width: 1.sw,
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 0.15.sw,
                          backgroundImage: AssetImage(vendor.workshop.imageUrl),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vendor.workshop.name,
                              style: GoogleFonts.oxanium(
                                color: kBlackColor,
                                fontSize: 0.05.sw,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 0.01.sh,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: kPrimaryColor,
                                ),
                                Text(
                                  "${vendor.workshop.area},${vendor.workshop.city}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: GoogleFonts.oxanium(
                                    color: kBlackColor,
                                    fontSize: 0.03.sw,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //Description
                  Padding(
                    padding: EdgeInsets.only(top: 0.03.sh, left: 0.02.sw),
                    child: Text(
                      vendor.workshop.desc,
                      style: GoogleFonts.oxanium(
                        color: kBlackColor,
                        fontSize: 0.04.sw,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //Review Heading with rating and review count
          Padding(
            padding:
                EdgeInsets.only(top: 0.02.sh, left: 0.03.sw, right: 0.03.sw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Reviews",
                  style: GoogleFonts.oxanium(
                    color: kBlackColor,
                    fontSize: 0.05.sw,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      avgRating().toStringAsFixed(1),
                      style: GoogleFonts.oxanium(
                        color: kBlackColor,
                        fontSize: 0.04.sw,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.star,
                      color: kPrimaryColor,
                    ),
                    Text(
                      "(${vendor.workshopReviews.length})",
                      style: GoogleFonts.oxanium(
                        color: kBlackColor,
                        fontSize: 0.04.sw,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //Review List
          Container(
            height: 0.3.sh,
            child: ListView.builder(
              itemCount: vendor.workshopReviews.length,
              itemBuilder: (context, index) {
                if (vendor.workshopReviews.isEmpty) {
                  return Center(
                    child: Text(
                      "No Reviews Yet",
                      style: GoogleFonts.oxanium(
                        color: kBlackColor,
                        fontSize: 0.04.sw,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.only(
                      bottom: 0.01.sh, right: 0.03.sw, left: 0.03.sw),
                  child: Container(
                    padding: EdgeInsets.all(0.03.sw),
                    height: 0.15.sh,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Initials
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 0.05.sw,
                                  child: Text(
                                    vendor
                                        .workshopReviews[index].reviewerName[0],
                                    style: GoogleFonts.oxanium(
                                      color: kWhiteColor,
                                      fontSize: 0.04.sw,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  vendor.workshopReviews[index].reviewerName,
                                  style: GoogleFonts.oxanium(
                                    color: kBlackColor,
                                    fontSize: 0.04.sw,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            //Rating
                            Row(
                              children: [
                                Text(
                                  vendor.workshopReviews[index].rating
                                      .toString(),
                                  style: GoogleFonts.oxanium(
                                    color: kBlackColor,
                                    fontSize: 0.04.sw,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(
                                  Icons.star,
                                  color: kPrimaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                        //Row for rating (show rating in number and star colored and default star)
                        //Row for rating (show rating in number and star colored and default star)
                        // Row(
                        //   children: [
                        //     Text(
                        //       vendor.workshopReviews[index].rating.toString(),
                        //       style: GoogleFonts.oxanium(
                        //         color: kBlackColor,
                        //         fontSize: 0.04.sw,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     ...List.generate(5, (starIndex) {
                        //       return Icon(
                        //         Icons.star,
                        //         color: starIndex <
                        //                 vendor.workshopReviews[index].rating
                        //             ? kPrimaryColor
                        //             : Colors.grey,
                        //       );
                        //     }),
                        //   ],
                        // ),
                        SizedBox(
                          height: 0.015.sh,
                        ),

                        Text(
                          vendor.workshopReviews[index].comment,
                          style: GoogleFonts.oxanium(
                            color: kBlackColor,
                            fontSize: 0.04.sw,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
