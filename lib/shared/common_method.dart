import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String? validateMobileNumberLength(String? value) {
  if (value!.length != 11) {
    return 'Phone Number must be of 11 digit';
  }
  return null;
}

String? validateConfirmPassword(String? confirmPassword, String? password) {
  if (confirmPassword != password) {
    return 'Confirm Password must be same as Password';
  }
  return null;
}

String? validateEmail(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value!)) {
    return 'Please enter a valid email address';
  }
  return null;
}

getInitials(String name) {
  List<String> nameParts = name.split(' ');
  String initials = '';
  for (var part in nameParts) {
    initials += part[0];
  }
  return initials.toUpperCase();
}

//Below are DATE FORMAT METHODS
String getDay(DateTime date) {
  return DateFormat('EEEE').format(date).toString();
}

String getCurrentDay() {
  return getDay(DateTime.now());
}

String getCurrentDate() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(now);
}

String getDateFormattedAsDDMMYYYYHHMM(DateTime date) {
  return DateFormat('d MMM yyyy - hh:mm a').format(date).toString();
}

String getDateFormattedAsHHMM(DateTime date) {
  return DateFormat('hh:mm a').format(date).toString();
}

String getDate(DateTime date) {
  return DateFormat('d').format(date).toString();
}

String getDateMonth(DateTime date) {
  return DateFormat('d/MM').format(date).toString();
}

String getDateFormattedAsYYYYMMMD(DateTime date) {
  return DateFormat('yyyy MMM d').format(date).toString();
}

String getDateFormattedAsDDMMYYYY(DateTime date) {
  return DateFormat('d/MM/yyyy').format(date).toString();
}

String getDateFormattedAsDayMonDate(DateTime date) {
  return DateFormat('E MMM d, yyyy').format(date).toString();
}

String timeStampToDate(Timestamp timestamp) {
  // Parse the input timestamp string to a Dat
  DateTime dateTime = timestamp.toDate();
  // Format the DateTime object to a 12-hour format with AM/PM
  String formattedDate = DateFormat('d MMM yyyy').format(dateTime);
  return formattedDate;
}

// tring getDateFormattedAsDDMMYYYY(DateTime date) {
//   return DateFormat('d/MM/yyyy').format(date).toString();
// }

// String getDateFormattedAsDayMonDate(DateTime date) {
//   return DateFormat('E MMM d, yyyy').format(date).toString();
// }

String timeStampToRelativeTime(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference.inDays == 0) {
    return "Today";
  } else if (difference.inDays == 1) {
    return "Yesterday";
  } else if (difference.inDays < 7) {
    return "${difference.inDays} days ago";
  } else if (difference.inDays < 30) {
    return "${(difference.inDays / 7).floor()} weeks ago";
  } else if (difference.inDays < 365) {
    return "${(difference.inDays / 30).floor()} months ago";
  } else {
    return "${(difference.inDays / 365).floor()} years ago";
  }
}

String timeStampTo12HourFormat(String timestamp) {
  // Parse the input timestamp string to a DateTime object
  DateTime dateTime = DateTime.parse(timestamp);

  // Format the DateTime object to a 12-hour format with AM/PM
  String formattedTime = DateFormat('h:mm a').format(dateTime);

  return formattedTime;
}
