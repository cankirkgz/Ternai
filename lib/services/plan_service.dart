import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelguide/models/budget_plan_model.dart';
import 'package:travelguide/models/day_plan_model.dart';
import 'package:travelguide/models/plan_plan_model.dart';

class PlanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPlan(String userId, Map<String, dynamic> plan) async {
    try {
      final planType = plan['type'];

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

      await _firestore.collection('users').doc(userId).update({
        'vacation_plan_count': FieldValue.increment(1),
      });
    } catch (e) {
      throw e;
    }
  }

  Future<List<BudgetPlanModel>> fetchBudgetPlans(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final budgetPlansData =
          userDoc.data()?['budget_plans'] as List<dynamic>? ?? [];

      return budgetPlansData.map((data) {
        return BudgetPlanModel.fromJson(data as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw e;
    }
  }

  Future<List<DayPlanModel>> fetchDayPlans(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final dayPlansData = userDoc.data()?['day_plans'] as List<dynamic>? ?? [];

      return dayPlansData.map((data) {
        return DayPlanModel.fromJson(data as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw e;
    }
  }

  Future<List<PlanPlanModel>> fetchPlanPlans(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final planPlansData =
          userDoc.data()?['plan_plans'] as List<dynamic>? ?? [];

      return planPlansData.map((data) {
        return PlanPlanModel.fromJson(data as Map<String, dynamic>);
      }).toList();
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
