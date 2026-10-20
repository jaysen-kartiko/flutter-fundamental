class Course {
  final String? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String?,
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: json['status'] as String ?? 'planned',
    );
  }

    Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
  };

}

