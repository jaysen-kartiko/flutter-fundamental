import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/course_provider.dart';
import '../../core/models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final Function(Course) onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final item = course;
    return InkWell(
      onTap: () => onTap(item),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Informasi Kursus'),
            content: Text(
              'Kode: ${item.code}\nStatus: ${item.status}\nSKS: ${item.credits}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                item.status == "done"
                    ? Icons.check_circle
                    : item.status == 'active'
                    ? Icons.run_circle
                    : Icons.calendar_month_rounded,
                color: Colors.blue,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Kode: ${item.code}'),
                  ],
                ),
              ),
              Text(
                "${item.credits} SKS",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Consumer<CourseProvider>(
                builder: (context, courseProvider, child) {
                  final bool isFavorite = courseProvider.isFavorite(item.code);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      courseProvider.toggleFavorite(item.code);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}