import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/job_model.dart';

class JobApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new job application
  Future<bool> addJobApplication(JobApplication jobApplication) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found'), backgroundColor: Colors.red),
        );
        return false;
      }

      jobApplication.userId = user.uid;
      final docRef = await _firestore.collection('jobApplications').add(jobApplication.toFirestore());
      
      // Update the id after adding
      jobApplication.id = docRef.id;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job application added'), backgroundColor: Colors.green),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding job application: $e'), backgroundColor: Colors.red),
      );
      return false;
    }
  }

  // Get all job applications for the current user
  Stream<List<JobApplication>> getJobApplications() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not found');
    }

    return _firestore
        .collection('jobApplications')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => JobApplication.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Get a specific job application by ID
  Future<JobApplication?> getJobApplicationById(String id) async {
    try {
      final doc = await _firestore.collection('jobApplications').doc(id).get();
      if (!doc.exists) {
        return null;
      }
      return JobApplication.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      print('Error getting job application: $e');
      return null;
    }
  }

  // Update a job application
  Future<bool> updateJobApplication(JobApplication jobApplication) async {
    try {
      if (jobApplication.id == null) {
        throw Exception('Job application ID is required');
      }

      jobApplication.lastUpdate = DateTime.now();
      
      await _firestore
          .collection('jobApplications')
          .doc(jobApplication.id)
          .update(jobApplication.toFirestore());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job application updated'), backgroundColor: Colors.green),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating job application: $e'), backgroundColor: Colors.red),
      );
      return false;
    }
  }

  // Delete a job application
  Future<bool> deleteJobApplication(String id) async {
    try {
      await _firestore.collection('jobApplications').doc(id).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job application deleted'), backgroundColor: Colors.green),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting job application: $e'), backgroundColor: Colors.red),
      );
      return false;
    }
  }

  // BuildContext is needed for SnackBar, so we'll use a method to set it
  late BuildContext context;
  void setContext(BuildContext ctx) {
    context = ctx;
  }
}