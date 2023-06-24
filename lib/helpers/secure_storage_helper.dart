import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:com_sandeepgtm_sycamore_mobile/models/storage_item.dart';


class SecureStorageHelper {

  final _secureStorage = FlutterSecureStorage();

  Future<void> writeSecureStorageData (StorageItem newItem) async {
    await _secureStorage.write(
      key: newItem.key,
      value: newItem.value,
      aOptions: _getAndroidOptions(),
      iOptions: _getIosOptions()

    );
  }

  Future<String?> readSecureStorageData(String key) async {
    return await _secureStorage.read(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIosOptions(),
    );
  }

  Future<void> deleteSecureStorageData(String key) async {
    await _secureStorage.delete(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: _getIosOptions()
    );
  }

  Future<bool> containsSecureStorageKey(String key) async {
    return await _secureStorage.containsKey(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: _getIosOptions()
    );
  }

  Future<List<StorageItem>> readAllSecureStorageData() async {
    Map<String, String> allData = await _secureStorage.readAll(
        iOptions: _getIosOptions(),
        aOptions: _getAndroidOptions()
    );

    List<StorageItem> list = allData.entries.map((e) => StorageItem(e.key, e.value)).toList();
    return list;

  }

  Future<void> deleteAllSecureStorageData() async {
    await _secureStorage.deleteAll(
        iOptions: _getIosOptions(),
        aOptions: _getAndroidOptions()
    );
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions();
  IOSOptions _getIosOptions() => const IOSOptions(accessibility: KeychainAccessibility.first_unlock);
}