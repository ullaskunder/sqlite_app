class Employee {
  int id;
  String name;

  Employee(this.id, this.name);

  Map<String, dynamic> toMap() {
    var map = {
      'id': this.id,
      'name': this.name,
    };
    return map;
  }

  Employee.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }
}
