import 'package:com_sandeepgtm_sycamore_mobile/helpers/Components/transaction_list_item.dart';
import 'package:com_sandeepgtm_sycamore_mobile/helpers/sales_network_helper.dart';
import 'package:com_sandeepgtm_sycamore_mobile/models/home_screen_data.dart';
import 'package:com_sandeepgtm_sycamore_mobile/models/signup_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class AppData extends ChangeNotifier {

  var _signUpData = SignupData();
  final _lastSevenDaySales = <SalesData>[];
  final _lastNTransactions = <TransactionListItemElements>[];
  final _lastNSalesData = <SalesRecordData>[];
  late IndividualSalesRecord? _individualSalesData;
  late NewSalesRecorder _newSalesRecorder;
  late List<InventoryItems> _inventoryItems;
  late List<Supplier> _suppliers;

  // New sales order
  List<NewSalesBillRecord> getSalesRecorderBills() {
    return _newSalesRecorder.itemList;
  }

  void createNewSalesOrder() {
    _newSalesRecorder = NewSalesRecorder.init();
  }

  void updateSalesByCandidate(String salesById) {
    _newSalesRecorder.salesBy = salesById;
  }

  void updateBuyerContact(String value) {
    _newSalesRecorder.buyerContact = value;
  }

  void updateBuyerId(String value) {
    _newSalesRecorder.buyerId = value;
  }

  // suppliers
  void addMultipleSuppliers(List<Supplier> supplierList) {
    _suppliers.addAll(supplierList);
  }

  void removeAllSuppliers() {
    _suppliers.removeRange(0, _suppliers.length);
  }

  List<Supplier> get getSuppliers => _suppliers;
  int get getSuppliersListLength => _suppliers.length;

  void addNewSupplier(Supplier supplier) {
    _suppliers.add(supplier);
  }


  // Inventory Items
  void addMultipleInventoryItems(List<InventoryItems> inventoryItems) {
    _inventoryItems.addAll(inventoryItems);
  }

  void removeAllInventoryItems() {
    _inventoryItems.removeRange(0, _inventoryItems.length);
  }

  List<InventoryItems> get getInventoryItemsList => _inventoryItems;
  int get getInventoryItemsListLength => _inventoryItems.length;

  void addNewInventoryItem(InventoryItems item) {
    _inventoryItems.add(item);
  }


  // Individual Sales Detail
  set individualSalesData(IndividualSalesRecord value) {
    _individualSalesData = value;
  }

  IndividualSalesRecord? get getIndividualSalesData => _individualSalesData;

  void removeIndividualSalesData() {
    _individualSalesData = null;
  }


  // N Sales Data (Sales Screen)
  void addNewSalesRecordData(SalesRecordData salesRecordData) {
    _lastNSalesData.add(salesRecordData);
  }

  void addMultipleSalesRecordData(List<SalesRecordData> salesRecordData) {
    _lastNSalesData.addAll(salesRecordData);
  }

  void removeAllSalesRecordData() {
    _lastNSalesData.removeRange(0, _lastNSalesData.length);
  }

  List<SalesRecordData> get getSalesRecordData => _lastNSalesData;
  int get getSalesRecordDataCount => _lastNSalesData.length;


  // Transaction Data (Home Screen)
  void addTransactionData(TransactionListItemElements element) {
    _lastNTransactions.add(element);
  }

  void removeAllTransactionData() {
    _lastNTransactions.removeRange(0, _lastNTransactions.length);
  }

  List<TransactionListItemElements> get getTransactionData => _lastNTransactions;
  int get getTransactionDataCount => _lastNTransactions.length;

  // Sales Data (Home Screen)
  void addSalesData(SalesData salesData) {
    _lastSevenDaySales.add(salesData);
  }

  void removeAllSalesData() {
    _lastSevenDaySales.removeRange(0, _lastSevenDaySales.length);
  }

  List<SalesData> get get7DaySales => _lastSevenDaySales;
  int get get7DaySalesCount => _lastSevenDaySales.length;

  void setSignupData(SignupData signupData) {
    _signUpData = signupData;
    notifyListeners();
  }

  // Signup Data
  SignupData getSignupData() {
    return _signUpData;
  }

  String get signUpDataLastName => _signUpData.lastName;

  set signUpDataLastName(String value) {
    _signUpData.lastName = value;
  }

  String get signUpDataFirstName => _signUpData.firstName;

  set signUpDataFirstName(String value) {
    _signUpData.firstName = value;
  }

  String get signUpDataRepeatPassword => _signUpData.repeatPassword;

  set signUpDataRepeatPassword(String value) {
    _signUpData.repeatPassword = value;
  }

  String get signUpDataPassword => _signUpData.password;

  set signUpDataPassword(String value) {
    _signUpData.password = value;
  }

  String get signUpDataCountryCode => _signUpData.countryCode;

  set signUpDataCountryCode(String value) {
    _signUpData.countryCode = value;
  }

  String get signUpDataPhoneNumber => _signUpData.phoneNumber;

  set signUpDataPhoneNumber(String value) {
    _signUpData.phoneNumber = value;
  }

  String get signUpDataEmail => _signUpData.email;

  set signUpDataEmail(String value) {
    _signUpData.email = value;
  }


}


class NewSalesRecorder {

  late String salesId;
  String businessId = 'ca2fd0c2-6094-48f0-ae88-f69dc289d8f9';
  late DateTime salesDate;
  late String? salesBy;
  late String? buyerId;
  late String? buyerContact;

  late String paymentId;
  num subTotalAmount = 0;
  num discountPercentage = 0;
  num beforeVATAmount = 0;
  late num vatPercentage = 13;
  num finalAmount = 0;
  late String remarks;
  num paidAmount = 0;
  late PaymentMethodType paymentMethod;
  late String transactionGatewayId;
  num dueAmount = 0;

  List<NewSalesBillRecord> itemList = [];

  NewSalesRecorder.init(){
    salesId = const Uuid().v4();
    salesDate = DateTime.now();
  }

  bool addNewSalesItem(NewSalesBillRecord billRecord) {
    bool isAdded = false;
    subTotalAmount += billRecord.itemPrice * billRecord.quantity;
    beforeVATAmount += subTotalAmount - (discountPercentage/100 * (billRecord.itemPrice * billRecord.quantity));
    beforeVATAmount > 0 ? isAdded = !isAdded : isAdded = isAdded;
    itemList.add(billRecord);
    return isAdded;
  }

  bool finalizeData(int paidAmount) {
    bool isComplete = false;
    try {
      finalAmount += beforeVATAmount + (vatPercentage/100 * beforeVATAmount);
      dueAmount = paidAmount - finalAmount;
      isComplete = true;
    } catch(e) {
      isComplete = false;
      print("Error");
    }

    return isComplete;
  }

}



class Supplier {
  late String supplierId;
  late String? supplierName;

  Supplier.init({
    required this.supplierId,
    this.supplierName
  });

  factory Supplier.fromJson(Map<String, dynamic> parsedJson) {
    return Supplier.init(
        supplierId: parsedJson['supplierId'],
        supplierName: parsedJson['supplierName']
    );
  }
}

class InventoryItems {
  late String inventoryId;
  late String itemName;
  late String itemId;
  late num itemPrice;
  late num salesPrice;
  late num? discountPercentage;
  late String? remark;
  late DateTime? lastRestockDate;
  late String suppliedBy;
  late num? quantity;


  InventoryItems.init({
    required this.inventoryId,
    required this.itemName,
    required this.itemId,
    required this.itemPrice,
    required this.salesPrice,
    this.discountPercentage,
    this.remark,
    this.lastRestockDate,
    required this.suppliedBy,
    this.quantity
  });

  factory InventoryItems.fromJson(Map<String, dynamic> parsedJson) {

    return InventoryItems.init(
      inventoryId: parsedJson['paymentRecord']['paymentId'],
      itemName: parsedJson['itemName'],
      itemId: parsedJson['itemID'],
      itemPrice: parsedJson['itemPrice'],
      salesPrice: parsedJson['salesPrice'],
      discountPercentage: parsedJson['discountPercentage'],
      remark: parsedJson['remarks'],
      lastRestockDate: parsedJson['lastRestockedDate'],
      suppliedBy: parsedJson['suppliedBy'],
      quantity: parsedJson['quantity']
    );
  }
}


class NewSalesBillRecord {
  late String itemizedBillId;
  late String itemName;
  late String itemId;
  late String itemizedBillRecNum;
  late num itemPrice;
  late num itemDiscountPercentage;
  late String remarks;
  late num quantity;
  late num subTotal;


  NewSalesBillRecord.generate({
    required this.itemizedBillId,
    required this.itemName,
    required this.itemPrice,
    required this.itemId,
    required this.itemDiscountPercentage,
    required this.remarks,
    required this.quantity
  }) {
    itemizedBillRecNum = Uuid().v4();
    subTotal = (quantity * itemPrice) - (itemDiscountPercentage * quantity * itemPrice);
  }
}