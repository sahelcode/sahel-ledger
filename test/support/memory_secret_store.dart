import 'package:sahel_ledger/features/lock/app_lock.dart';

class MemorySecretStore implements SecretStore {
  final data = <String, String>{};
  @override
  Future<void> delete(String key) async => data.remove(key);
  @override
  Future<String?> read(String key) async => data[key];
  @override
  Future<void> write(String key, String value) async => data[key] = value;
}
