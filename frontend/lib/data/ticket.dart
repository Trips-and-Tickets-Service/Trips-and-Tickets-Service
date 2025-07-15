class Ticket {
  final int id;
  final String from;
  final String to;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int availableSeats;
  final int maxSeats;
  final int price;

  Ticket({
    required this.id,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.availableSeats,
    required this.maxSeats,
    required this.price,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      from: json['from_planet'],
      to: json['to_planet'],
      departureTime: DateTime.parse(json['departure_time']),
      arrivalTime: DateTime.parse(json['arrival_time']),
      availableSeats: json['available_seats'],
      maxSeats: json['max_seats'],
      price: json['price'],
    );
  }
}
