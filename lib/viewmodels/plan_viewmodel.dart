import 'package:flutter/material.dart';
import 'package:travelguide/models/budget_plan_model.dart';
import 'package:travelguide/models/day_plan_model.dart';
import 'package:travelguide/models/plan_plan_model.dart';
import 'package:travelguide/services/plan_service.dart';

class PlanViewModel extends ChangeNotifier {
  final PlanService _planService = PlanService();

  List<BudgetPlanModel> _budgetPlans = [];
  List<DayPlanModel> _dayPlans = [];
  List<PlanPlanModel> _planPlans = [];

  List<BudgetPlanModel> get budgetPlans => _budgetPlans;
  List<DayPlanModel> get dayPlans => _dayPlans;
  List<PlanPlanModel> get planPlans => _planPlans;

  Future<void> fetchPlans(String userId) async {
    try {
      _budgetPlans = await _planService.fetchBudgetPlans(userId);
      _dayPlans = await _planService.fetchDayPlans(userId);
      _planPlans = await _planService.fetchPlanPlans(userId);
      notifyListeners();
    } catch (e) {
      print("Planlar getirilirken hata oluştu: $e");
      throw e;
    }
  }

  Future<void> createPlan(String userId, Map<String, dynamic> plan) async {
    try {
      await _planService.createPlan(userId, plan);
      await fetchPlans(userId); // Yeni planları yükleyin veya güncelleyin
    } catch (e) {
      print("Plan oluşturulurken hata oluştu: $e");
      throw e;
    }
  }

  Future<void> updatePlan(String planId, Map<String, dynamic> data) async {
    try {
      await _planService.updatePlan(planId, data);
      await fetchPlans(data['userId']); // Planları güncelleyin
    } catch (e) {
      print("Plan güncellenirken hata oluştu: $e");
      throw e;
    }
  }

  Future<void> deletePlan(String planId) async {
    try {
      await _planService.deletePlan(planId);
      // Planları silin
      notifyListeners();
    } catch (e) {
      print("Plan silinirken hata oluştu: $e");
      throw e;
    }
  }
}
