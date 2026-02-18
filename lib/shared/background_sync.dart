
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workmanager/workmanager.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:selleri/features/transaction/api/transaction_api.dart';
import 'package:selleri/shared/utils/fetch.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/features/auth/model/token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

const syncTask = "syncTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    log("Native called background task: $task");

    try {
      // 1. Initialize Flutter bindings
      // Required for platform channels (PathProvider, SecureStorage etc)
      // Note: WidgetsFlutterBinding.ensureInitialized() is called by Workmanager automatically

      // 2. Initialize Environment Variables
      // Pass the env file path from main isolate if needed, or load default
      String envFile = inputData?['env'] ?? '.env'; 
      await dotenv.load(fileName: envFile);

      // 3. Initialize ObjectBox
      // We must create a new instance for the background isolate
      // The store reference cannot be pas sed between isolates easily in this setup without complex setup
      // So we open the box again. ObjectBox supports multiple readers/writers.
      final String? appDocDir = inputData?['appDocDir'];
      final objectBox = await ObjectBox.create(path: appDocDir);
      
      // 4. Initialize Dio and API
      final dio = fetch();
      // We need to manually add the interceptor logic since we don't have Ref/ProviderScope here
      // duplicating the interceptor logic from fetch.dart but simplified for background
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
             const storage = FlutterSecureStorage();
             String? tokenString = await storage.read(key: StoreKey.token.name);
             if (tokenString != null) {
               final Token token = Token.fromJson(json.decode(tokenString));
               options.headers['Authorization'] = 'Bearer ${token.accessToken}';
             }
             String? deviceId = await storage.read(key: StoreKey.device.name);
             options.headers['device'] = deviceId;
             options.headers['is-app'] = 1;
             return handler.next(options);
        },
      ));

      final transactionApi = TransactionApi(api: dio);

      switch (task) {
        case syncTask:
          log("Running Sync Task");
          final transactions = await objectBox.offlineTransactions();
          if (transactions.isNotEmpty) {
             log("Found ${transactions.length} offline transactions to sync");
             final synced = await transactionApi.storeTransaction(transactions);
             log("Synced ${synced.length} transactions");
             
             final ids = synced.map((t) => t.transactionNo).toList();
             await objectBox.deleteOfflineTransactions(ids);
          } else {
            log("No offline transactions found");
          }
          break;
      }
      
      // Close ObjectBox store to release resources
      objectBox.store.close();
      return Future.value(true);
      
    } catch (err, stack) {
      log("Background Task Failed: $err");
      log(stack.toString());
      return Future.value(false); // Task failed
    }
  });
}
