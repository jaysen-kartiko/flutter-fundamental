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


# Per. 7 Tahap 1
- DUMP ENDPOINT
- URL Endpoint: https://randomuser.me/api/
- HTTP Method: GET
- Status Code: 200
- Response Body: 
{
    "results": [{
        "gender": "male",
        "name": {
            "title": "Mr",
            "first": "Cristian",
            "last": "Pascual"
        },
        "location": {
            "street": {
                "number": 2354,
                "name": "Avenida de América"
            },
            "city": "Madrid",
            "state": "Navarra",
            "country": "Spain",
            "postcode": 10260,
            "coordinates": {
                "latitude": "-38.3838",
                "longitude": "-158.4797"
            },
            "timezone": {
                "offset": "-3:00",
                "description": "Brazil, Buenos Aires, Georgetown"
            }
        },
        "email": "cristian.pascual@example.com",
        "login": {
            "uuid": "3b5308e0-48b5-4391-913a-b9c886102fd5",
            "username": "brownmouse739",
            "password": "basketball",
            "salt": "rFUumLfe",
            "md5": "ad194e9c6345c3d79ad9e47658fa4932",
            "sha1": "ebf63eb4f230cc5bdc8adcc914e3c9681e067ff5",
            "sha256": "34864a0bb42de64183e6f0b1d4231cc8691c725c2cfa0b0337abe68a93e489b7"
        },
        "dob": {
            "date": "1977-10-18T03:29:58.149Z",
            "age": 49
        },
        "registered": {
            "date": "2017-06-12T22:00:23.012Z",
            "age": 9
        },
        "phone": "954-001-983",
        "cell": "620-719-195",
        "id": {
            "name": "DNI",
            "value": "04916535-Q"
        },
        "picture": {
            "large": "https://randomuser.me/api/portraits/men/54.jpg",
            "medium": "https://randomuser.me/api/portraits/med/men/54.jpg",
            "thumbnail": "https://randomuser.me/api/portraits/thumb/men/54.jpg"
        },
        "nat": "ES"
    }],
    "info": {
        "seed": "82228890d563a712",
        "results": 1,
        "page": 1,
        "version": "1.4"
    }
}
- Empat Field JSON: Gender, Name, Location, Email