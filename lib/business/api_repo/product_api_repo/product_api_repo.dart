import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../../../utils/mscm_retail_app.dart';

class ProductApiRepo {
  late OdooClient client;

  ProductApiRepo() {
    client = OdooClient(MSCMRetail.serverUrl, MSCMRetail.odooSession);
  }

  Future<dynamic> getProduct(String barcodeOrSerial) async {
    Dio dio = Dio(BaseOptions(baseUrl: MSCMRetail.serverUrl));
    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      responseBody: true,
      error: true,
      requestBody: true,
      responseHeader: true,
    ));
    final jsonData = {
      "jsonrpc": "2.0",
      "method": "call",
      "id": 921359310,
      "params": {
        "service": "object",
        "method": "execute",
        "args": [
          "${MSCMRetail.odooSession?.dbName}",
          "${MSCMRetail.odooSession?.userId}",
          MSCMRetail.password,
          "stock.quant",
          "search_read",
          [
            if (barcodeOrSerial.startsWith('00'))
              ['lot_id', 'ilike', barcodeOrSerial],
            if (!barcodeOrSerial.startsWith('00'))
              ['barcode', 'ilike', barcodeOrSerial]
          ],
          // ['product_id', 'image', 'private_price']
          ['id', 'product_id', 'image', 'private_price', 'price_per_kg']
        ]
      }
    };
    Response response = await dio.post('/jsonrpc', data: jsonData);

    return response.data;
  }
}
// response = await dio.post('/jsonrpc', data: {
//   "jsonrpc": "2.0",
//   "method": "call",
//   "id": 921359310,
//   "params": {
//     "service": "object",
//     "method": "execute",
//     "args": [
//       "${MSCMRetail.odooSession?.dbName}",
//       "${MSCMRetail.odooSession?.userId}",
//       MSCMRetail.password,
//       "product.template",
//       "search_read",
//       [
//         ['barcode', 'ilike', barcodeOrSerial]
//       ],
//       ["name", "barcode", "image_1920", 'list_price']
//     ]
//   }
// });

// if (!barcodeOrSerial.startsWith('000')) {
//   return client.callKw({
//     "model": "product.template",
//     "method": "search_read",
//     "args": [],
//     "kwargs": {
//       "context": {"bin_size": true},
//       "domain": [
//         ['barcode', 'ilike', barcodeOrSerial]
//       ],
//       "fields": [],
//       "limit": 1
//     }
//   });
// } else {
//   final retData = await client.callKw({
//     "model": "stock.production.lot",
//     "method": "search_read",
//     "args": [],
//     "kwargs": {
//       "context": {"bin_size": true},
//       "domain": [
//         ['name', 'ilike', barcodeOrSerial]
//       ],
//       "fields": [],
//       "limit": 1
//     }
//   });
//   print(retData);
//   return retData;
// }

// response = await dio.post('/jsonrpc', data: {
//   "jsonrpc": "2.0",
//   "method": "call",
//   "id": 921359310,
//   "params": {
//     "service": "object",
//     "method": "execute",
//     "args": [
//       "${MSCMRetail.odooSession?.dbName}",
//       "${MSCMRetail.odooSession?.userId}",
//       MSCMRetail.password,
//       "product.template",
//       "search_read",
//       [
//         ['barcode', 'ilike', barcodeOrSerial]
//       ],
//       ["name", "barcode", "image_1920", 'list_price']
//     ]
//   }
// });
