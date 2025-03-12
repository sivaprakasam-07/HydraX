class WaterLog {
  final int amount; // Water intake in milliliters (ml)
  final DateTime timestamp; // Time when water was consumed

  WaterLog({required this.amount, required this.timestamp});

  // Convert to JSON (for Firebase)
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create WaterLog object from JSON (for Firebase retrieval)
  factory WaterLog.fromJson(Map<String, dynamic> json) {
    return WaterLog(
      amount: json['amount'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
