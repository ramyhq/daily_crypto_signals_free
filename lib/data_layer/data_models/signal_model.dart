

class SignalModel {

  final String coinName;
  final String entryPrice;
  final String stopLoss;
  final String target1;
  final String target2;
  final String target3;
  final DateTime signalDate;
  final bool sendNotification = true;

  SignalModel({
    required this.coinName,
    required this.entryPrice,
    required this.stopLoss,
    required this.target1,
    required this.target2,
    required this.target3,
    required this.signalDate,
  });


}