part of 'previous_trips_screen.dart';

mixin _PreviousTripsScreenMixin on State<PreviousTripsScreen> {

  Future<List<BudgetPlanModel>> fetchBudgetPlans(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final budgetPlansData = userDoc.data()?['budget_plans'] as List<dynamic>? ?? [];

    return budgetPlansData.map((data) {
      return BudgetPlanModel.fromJson(data as Map<String, dynamic>);
    }).toList();
  }

  Future<List<DayPlanModel>> fetchDayPlans(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final dayPlansData = userDoc.data()?['day_plans'] as List<dynamic>? ?? [];

    return dayPlansData.map((data) {
      return DayPlanModel.fromJson(data as Map<String, dynamic>);
    }).toList();
  }

  Future<List<PlanPlanModel>> fetchPlanPlans(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final planPlansData = userDoc.data()?['plan_plans'] as List<dynamic>? ?? [];

    return planPlansData.map((data) {
      return PlanPlanModel.fromJson(data as Map<String, dynamic>);
    }).toList();
  }
}