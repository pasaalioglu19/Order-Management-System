class CarStates{
  static const String OnDelivery = "On Delivery";
  static const String Waiting = "Waiting";
  static const String Returning = "Returning"; 
  static const String Loading="Loading";
  static const String inWarehouse="In Warehouse";

}

class OrderStates{
  static const String Preparing="Preparing";
  static const String Pending="Pending";
  static const String AwaitingConfirmation="awaitingConfirmation";
  static const String OnDelivery = "OnDelivery";
  static const String Delivered="Delivered";
  static const String Cancelled="Cancelled";
  static const String Undeliverable="Undeliverable";
}

class PersonStates{
  static const String WorkDay="Work Day";
  static const String OnLeave ="On Leave";
  static const String Quiting="Quiting From Job";// ?
}