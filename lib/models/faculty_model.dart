class Faculty {
  final String id;
  final String name;
  final String dept;
  final String roomNo;
  final String email;
  final String number;
  final String facultyId;
  final String availability;

  Faculty({
    required this.id,
    required this.name,
    required this.dept,
    required this.roomNo,
    required this.email,
    required this.number,
    required this.facultyId,
    required this.availability,
  });

  factory Faculty.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return Faculty(
      id: documentId,
      name: data['name'] ?? '',
      dept: data['dept'] ?? '',
      roomNo: data['roomNo'] ?? '',
      email: data['email'] ?? '',
      number: data['number'].toString(),
      facultyId: data['facultyId'] ?? '',
      availability: data['availability'] ?? 'Unknown',
    );
  }
}
