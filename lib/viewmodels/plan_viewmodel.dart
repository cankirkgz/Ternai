import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/budget_plan_model.dart';
import '../models/day_plan_model.dart';
import '../models/plan_plan_model.dart';
import '../services/plan_service.dart';

class PlanViewModel extends ChangeNotifier {
  final PlanService _planService = PlanService();

  List<BudgetPlanModel> _budgetPlans = [];
  List<DayPlanModel> _dayPlans = [];
  List<PlanPlanModel> _planPlans = [];

  List<BudgetPlanModel> get budgetPlans => _budgetPlans;
  List<DayPlanModel> get dayPlans => _dayPlans;
  List<PlanPlanModel> get planPlans => _planPlans;

  Future<void> createPlan(String userId, Map<String, dynamic> plan) async {
    try {
      await _planService.createPlan(userId, plan);
      // Yeni planları yükleyin veya güncelleyin
      await fetchPlans();
    } catch (e) {
      print("Plan oluşturulurken hata oluştu: $e");
      throw e;
    }
  }

  Future<void> fetchPlans() async {
    try {
      // Planları servisinizden çekin ve _budgetPlans, _dayPlans ve _planPlans listelerini güncelleyin
      // Örnek olarak:
      // _budgetPlans = await _planService.fetchBudgetPlans();
      // _dayPlans = await _planService.fetchDayPlans();
      // _planPlans = await _planService.fetchPlanPlans();
      notifyListeners();
    } catch (e) {
      print("Planlar getirilirken hata oluştu: $e");
      throw e;
    }
  }

  Future<void> updatePlan(String planId, Map<String, dynamic> data) async {
    try {
      await _planService.updatePlan(planId, data);
      // Planları güncelleyin
      await fetchPlans();
    } catch (e) {
      print("Plan güncellenirken hata oluştu: $e");
      throw e;
    }
  }

  Future<void> deletePlan(String planId) async {
    try {
      await _planService.deletePlan(planId);
      // Planları silin
      await fetchPlans();
    } catch (e) {
      print("Plan silinirken hata oluştu: $e");
      throw e;
    }
  }
}


Future<List<PlanPlanModel>> fetchPlanPlans(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final planPlansData = userDoc.data()?['plan_plans'] as List<dynamic>? ?? [];

    return planPlansData.map((data) {
      return PlanPlanModel.fromJson(data as Map<String, dynamic>);
    }).toList();
  }