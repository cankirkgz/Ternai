import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelguide/models/budget_plan_model.dart';
import 'package:travelguide/models/day_plan_model.dart';
import 'package:travelguide/models/plan_plan_model.dart';
import 'package:travelguide/models/user_model.dart';

class PlanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPlan(String userId, Map<String, dynamic> plan) async {
    try {
      final planType = plan['type'];
      final planId = plan['id'];

      if (planType == 'budget') {
        await _firestore.collection('users').doc(userId).update({
          'budget_plans': FieldValue.arrayUnion([plan])
        });
      } else if (planType == 'day') {
        await _firestore.collection('users').doc(userId).update({
          'day_plans': FieldValue.arrayUnion([plan])
        });
      } else if (planType == 'plan') {
        await _firestore.collection('users').doc(userId).update({
          'plan_plans': FieldValue.arrayUnion([plan])
        });
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> updatePlan(String planId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('plans').doc(planId).update(data);
    } catch (e) {
      throw e;
    }
  }

  Future<void> deletePlan(String planId) async {
    try {
      await _firestore.collection('plans').doc(planId).delete();
    } catch (e) {
      throw e;
    }
  }
}
