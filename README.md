# Tanggung Jawab singkat tiap folder

- **`lib/`**: Folder utama untuk seluruh kode sumber aplikasi.
- **`lib/core/`**: Menyimpan logika inti, data, dan fungsionalitas global aplikasi.
  - **`models/`**: Definisi struktur data / objek (`course.dart`).
  - **`providers/`**: Pengelola *state* untuk menghubungkan data ke UI.
  - **`repositories/`**: Perantara penghubung sumber data (lokal/API).
  - **`services/`**: Layanan komunikasi eksternal (API, database, dll).
- **`lib/screens/`**: Kumpulan antarmuka (UI) tampilan aplikasi.
  - **`components/`**: Bagian-bagian penyusun tampilan yang spesifik.
  - **`pages/`**: Halaman utama aplikasi secara utuh (Home, Profile, dll).
  - **`widgets/`**: Komponen UI yang dapat digunakan kembali (*reusable*).
  
## Debugging Challange 

Kasus A: hapus notifyListeners() sementara dan amati UI. Kembalikan setelah memahami efeknya.
Masalah: UI tidak melakukan re-render (update) saat data pada state berubah. Data baru sudah tersimpan di memory, tetapi layar tetap menampilkan data lama.

Solusi: Kembalikan panggilan notifyListeners() di dalam metode yang mengubah data agar Flutter memberitahu widget listener untuk memperbarui tampilannya.
---
Kasus B: panggil Provider dari context yang berada di atas ChangeNotifierProvider dan amati error, lalu perbaiki.
Masalah: Terjadi runtime error ProviderNotFoundException karena BuildContext yang digunakan berada di luar (di atas) hirarki ChangeNotifierProvider, sehingga Flutter tidak dapat menemukan instance-nya.

Solusi: Panggil Provider menggunakan BuildContext yang berada di bawah (child) dari ChangeNotifierProvider (misalnya menggunakan widget Builder atau memisahkan child widget ke komponen baru).
---
Kasus C: sengaja buat error pada CourseService dan pastikan error state terlihat.
Masalah: Jika CourseService melempar exception (throw error) saat mengambil data, aplikasi bisa crash atau terus-menerus menampilkan indikator loading tanpa pesan yang jelas.

Solusi: Bungkus panggilan CourseService menggunakan blok try-catch, tangkap error-nya, lalu perbarui state menjadi error state (misal: isError = true atau simpan pesan errorMessage) dan panggil notifyListeners() agar UI menampilkan pesan kesalahan.
---
Kasus D: lakukan perubahan state setelah async; jika diperlukan periksa mounted sebelum setState pada widget lokal.
Masalah: Memanggil setState() setelah baris await dapat menyebabkan error SetState called after dispose jika pengguna sudah berpindah halaman (widget sudah di-unmount) saat proses async selesai.

Solusi: Tambahkan pemeriksaan if (!mounted) return; tepat setelah panggilan await dan sebelum memanggil setState() pada StatefulWidget.

