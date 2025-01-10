import 'package:car_fix_up/Routes/routes.dart';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/views/User/home/home_view.dart';
import 'package:car_fix_up/views/User/workshop/controller/workshop_controller.dart';
import 'package:car_fix_up/views/components/vendor_profile.dart';
import 'package:car_fix_up/views/widgets/workshop_tile.dart';
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
                    List<Vendor>? vendors = snapshot.data;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: vendors!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: WorkshopTile(
                              vendor: vendors[index],
                              onTap: () => Get.toNamed(RouteName.vendorProfile,
                                  arguments: vendors[index]),
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
