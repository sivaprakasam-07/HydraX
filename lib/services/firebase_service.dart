import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Add Temperature Log to Firestore
  Future<void> logTemperature(double temperature) async {
    try {
      await _firestore.collection('temperatureLogs').add({
        'temperature': temperature,
        'timestamp': FieldValue.serverTimestamp(), // Automatically add server time
      });
      print("✅ Temperature log added successfully!");
    } catch (e) {
      print("❌ Error adding temperature log: $e");
    }
  }

  // ✅ Get Temperature Logs from Firestore
  Future<List<Map<String, dynamic>>> getTemperatureLogs() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('temperatureLogs')
          .orderBy('timestamp', descending: true)
          .get();

      // Map Firestore documents to a list of maps safely
      List<Map<String, dynamic>> logs = querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'temperature': data['temperature'],
              'timestamp': (data['timestamp'] != null)
                  ? (data['timestamp'] as Timestamp).toDate()
                  : DateTime.now(), // Fallback for null timestamp
            };
          })
          .toList();

      print("✅ Fetched ${logs.length} temperature logs.");
      return logs;
    } catch (e) {
      print("❌ Error fetching temperature logs: $e");
      return [];
    }
  }
}
