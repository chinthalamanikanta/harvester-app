late final double pricePerAcre;
class Machine {
  final int id;
  final String machineName;
  final String machineType;
  final String state;
  final String district;
  final double pricePerAcre;

  Machine({
    required this.id,
    required this.machineName,
    required this.machineType,
    required this.state,
    required this.district,
    required this.pricePerAcre,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'],
      machineName: json['machine_name'],
      machineType: json['machine_type'],
      state: json['state'],
      district: json['district'],
      pricePerAcre: json['price_per_acre'].toDouble(),
    );
  }
}