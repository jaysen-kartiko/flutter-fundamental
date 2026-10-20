import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/course.dart';
import '../../core/providers/course_provider.dart';

class editCoursePage extends StatefulWidget {
  final Course course;
  final String? courseId;
  const editCoursePage({
    super.key,
    required this.course,
    required this.courseId,
  });

  @override
  State<editCoursePage> createState() => _editCoursePageState();
}

class _editCoursePageState extends State<editCoursePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _codeController;
  late TextEditingController _statusController;
  late TextEditingController _creditController; 

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course.title);
    _codeController = TextEditingController(text: widget.course.code);
    _statusController = TextEditingController(text: widget.course.status);
    _creditController = TextEditingController(text: widget.course.credits.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    _statusController.dispose();
    _creditController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CourseProvider>();
    
    // Guard submit ganda
    if (provider.isSaving) return;

    final updatedCourse = Course(
      id: widget.course.id,
      code: _codeController.text,
      title: _titleController.text,
      status: _statusController.text,
      credits: int.tryParse(_creditController.text) ?? 0,
    );

    final success = await provider.updateCourse(widget.courseId, updatedCourse);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course berhasil diperbarui!')),
      );
      Navigator.pop(context); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Gagal memperbarui course')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Field code dibuat read-only
              TextFormField(
                controller: _codeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Kode',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Course',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              // 4. Tambahkan TextFormField untuk Credits
              TextFormField(
                controller: _creditController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'SKS / Credits',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Credits wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Credits harus berupa angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Status wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: provider.isSaving ? null : _submitForm,
                child: provider.isSaving
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}