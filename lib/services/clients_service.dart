import 'package:cloud_firestore/cloud_firestore.dart';

class ClientsService {
  ClientsService({required this.uid});

  final String uid;

  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users_accounts',
  );

  CollectionReference get _clients => users.doc(uid).collection('My_Clients');

  Query getClientsQuery(String searchName) {
    return _clients
        .orderBy('full_name')
        .where('full_name', isGreaterThanOrEqualTo: searchName)
        .where('full_name', isLessThanOrEqualTo: '$searchName\uf8ff');
  }

  Future<void> addClient(String name) {
    return _clients.add({
      'full_name': name.trim().toLowerCase(),
      'created_at': DateTime.now(),
      'total_amount': 0,
    });
  }

  Future<void> updateClientName(String clientId, String newName) {
    return _clients.doc(clientId).update({
      'full_name': newName.trim().toLowerCase(),
    });
  }

  DocumentReference clientDoc(String clientId) {
    return _clients.doc(clientId);
  }

  Future<void> deleteClientWithTransactions(String clientId) async {
    final batch = FirebaseFirestore.instance.batch();
    final clientDoc = _clients.doc(clientId);
    final transactions = await clientDoc.collection('transactions').get();

    for (final transaction in transactions.docs) {
      batch.delete(transaction.reference);
    }

    batch.delete(clientDoc);
    await batch.commit();
  }
}
