import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TowingRideService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> sendTowingRideRequestStream(
      LatLng pickup, String requesterId, String requesterName) async {
    try {
      final response = await _firestore.collection("towing_requests").add({
        "pickup": GeoPoint(pickup.latitude, pickup.longitude),
        "requesterId": requesterId,
        "requesterName": requesterName,
        "status": "pending",
        "isAccepted": false,
        "timestamp": FieldValue.serverTimestamp(),
        "accepterId": "",
        "active_location": GeoPoint(0, 0),
      });
      //return requestId (Document ID)
      return response.id;
    } catch (e) {
      throw e;
    }
  }

  Stream<bool> checkIsTowingRideAccepted(String requestId) {
    return _firestore
        .collection("towing_requests")
        .doc(requestId)
        .snapshots()
        .map((event) => event.get("isAccepted"));
  }

  deleteTowingRequest(String requestId) async {
    _firestore.collection("towing_requests").doc(requestId).delete();
  }

  Stream<List<DocumentSnapshot>> getTowingActiveRequests() {
    return _firestore.collection("towing_requests").snapshots().map((event) {
      return event.docs
          .where((element) =>
              element.get("status") == "pending" ||
              element.get("status") == "in_progress" ||
              element.get("status") == "accepted")
          .toList();
    });
  }

  void acceptTowingRequest(String requestId, String accepterId) {
    _firestore.collection("towing_requests").doc(requestId).update({
      "status": "accepted",
      "isAccepted": true,
      "accepterId": accepterId,
    });
  }

  void changeTowingStatusToInProgress(String requestId) {
    _firestore.collection("towing_requests").doc(requestId).update({
      "status": "in_progress",
    });
  }

  void changeTowingStatusToCompleted(String requestId) {
    _firestore.collection("towing_requests").doc(requestId).update({
      "status": "completed",
    });
  }
}
