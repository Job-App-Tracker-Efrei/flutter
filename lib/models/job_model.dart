import 'package:cloud_firestore/cloud_firestore.dart';

enum JobApplicationStatus {
  accepted,
  rejected,
  pending
}

class JobApplication {
  String? id;
  String? userId;
  String company;
  String position;
  JobApplicationStatus status;
  DateTime date;
  DateTime lastUpdate;

  JobApplication({
    this.id,
    this.userId,
    required this.company,
    required this.position,
    required this.status,
    DateTime? date,
    DateTime? lastUpdate,
  }) : 
    date = date ?? DateTime.now(),
    lastUpdate = lastUpdate ?? DateTime.now();

  // Convert from Firestore map
  factory JobApplication.fromFirestore(Map<String, dynamic> data, String documentId) {
    return JobApplication(
      id: documentId,
      userId: data['userId'],
      company: data['company'],
      position: data['position'],
      status: _parseStatus(data['status']),
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastUpdate: (data['lastUpdate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'company': company,
      'position': position,
      'status': status.toString().split('.').last,
      'date': date,
      'lastUpdate': lastUpdate,
    };
  }

  // Helper method to parse status from string
  static JobApplicationStatus _parseStatus(String? status) {
    switch (status) {
      case 'accepted':
        return JobApplicationStatus.accepted;
      case 'rejected':
        return JobApplicationStatus.rejected;
      case 'pending':
      default:
        return JobApplicationStatus.pending;
    }
  }
}