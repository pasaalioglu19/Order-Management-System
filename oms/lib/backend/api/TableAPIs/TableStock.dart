import 'package:oms/backend/api/StockApi.dart';
import 'package:oms/backend/models/Stock.dart';

class TableStock{
  static Future<Map<String,dynamic>> getTableContet(int pageLength,String searchValue,String searchKey,int pageIndex,String warehouse_id) async {
    List<Stock> stocks = await StockAPI.getSorted(warehouse_id, searchKey,searchValue,pageLength,pageIndex);
    Map<String,dynamic> m = {};
    for(Stock s in stocks){
      m[s.id!] = s.toStockData();
    }
    return m;
  }

  static Future<Map<String,dynamic>> getPageNumber(int pageLength,String searchValue,String searchKey,int pageIndex,String warehouse_id) async {
    var num = await StockAPI.getNumOfPage(warehouse_id, searchKey, searchValue, pageLength);
    return {"content":num};
  }
}