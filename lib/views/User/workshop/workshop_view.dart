import 'package:car_fix_up/Routes/routes.dart';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/views/User/home/home_view.dart';
import 'package:car_fix_up/views/User/workshop/controller/workshop_controller.dart';
import 'package:car_fix_up/views/components/vendor_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkshopView extends StatelessWidget {
  const WorkshopView({super.key});

  @override
  Widget build(BuildContext context) {
    WorkshopController workshopController = Get.put(WorkshopController());
    return Scaffold(
        backgroundColor: Colors.white,
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
                            icon: const Icon(Icons.menu_rounded),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            color: Colors.white,
                          ),
                          IconButton(
                            icon: const Icon(Icons.person),
                            onPressed: () {},
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.02.sh),
                      child: Text(
                        "Find yourself a Professional Workshop",
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
            //Text Representation of the Workshop
            Padding(
              padding: EdgeInsets.only(left: 0.02.sw),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Workshops",
                  style: GoogleFonts.oxanium(
                    color: kBlackColor,
                    fontSize: 0.06.sw,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            FutureBuilder(
                future: workshopController.getAllWorkshop(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ));
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  if (snapshot.data == null) {
                    return Center(
                      child: Text(
                        "No Workshop Found",
                        style: GoogleFonts.oxanium(
                          color: kPrimaryColor,
                          fontSize: 0.06.sw,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    List<Vendor>? workshops = snapshot.data;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: workshops!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 0.05.sw,
                            ),
                            child: InkWell(
                              onTap: () => Get.toNamed(RouteName.vendorProfile,
                                  arguments: workshops[index]),
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
                                            bottomLeft:
                                                Radius.circular(0.02.sw)),
                                        image: DecorationImage(
                                          image: AssetImage(workshops[index]
                                              .workshop
                                              .imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0.02.sw),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            workshops[index].workshop.name,
                                            style: GoogleFonts.oxanium(
                                              color: kBlackColor,
                                              fontSize: 0.04.sw,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${workshops[index].workshop.area},${workshops[index].workshop.city}",
                                            style: GoogleFonts.oxanium(
                                              color: kBlackColor,
                                              fontSize: 0.03.sw,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Rating
                                    Padding(
                                      padding: EdgeInsets.only(left: 0.1.sw),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            avgRating(workshops[index])
                                                .toString(),
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
                        },
                      ),
                    );
                  }
                  return Center(
                    child: Text((snapshot.data == null)
                        ? "No Workshop"
                        : "Server Error"),
                  );
                })
          ],
        ));
  }
}
