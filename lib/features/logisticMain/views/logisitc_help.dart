import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_app/constants/colors.dart';

class LogisticHelp extends StatelessWidget {
  const LogisticHelp({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.only(top: 25, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //title
            SizedBox(height: screenHeight * 0.08 ,),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Center(
                child: Text(
                  "Pusat Bantuan",
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.025 ,),
            LimitedBox(
              maxHeight: screenHeight * 0.61,
              maxWidth: screenWidth,
              child: ListView(
                  padding: const EdgeInsets.all(0),
                  scrollDirection: Axis.vertical,
                  children: [
                    //navigation help
                    Card(
                      color: Colors.grey.shade300,
                      elevation: 0,
                      child: ExpansionTile(
                        backgroundColor: taSecondaryColor,
                        collapsedIconColor: Colors.grey.shade400,
                        maintainState: true,
                        expandedAlignment: Alignment.center,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 14),
                          child: Text(
                            "Cara memilih menu daftar Logistik Masuk atau daftar Logistik Keluar",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: taPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 26),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //solving methods
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Ketika masuk aplikasi, akan secara otomatis  terpilih menu list Logistik Masuk. "
                                              "Apabila ingin memilih menu list Logistik Keluar, klik logo 'Logistik Keluar' "
                                              "pada menu navigasi di sisi bawah aplikasi. Hal ini juga berlaku apabila ingin"
                                              "kembali ke menu Logistik Masuk",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),

                    //add logisticIn item help
                    Card(
                      color: Colors.grey.shade300,
                      elevation: 0,
                      child: ExpansionTile(
                        backgroundColor: taSecondaryColor,
                        collapsedIconColor: Colors.grey.shade400,
                        maintainState: true,
                        expandedAlignment: Alignment.center,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 14),
                          child: Text(
                            "Cara menambah item logistik",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: taPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 26),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //solving methods
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "1.  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Klik tombol '☰' di bagian kanan bawah, lalu klik tombol '+'. Anda akan diarahkan ke halaman input barang.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "2. ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Ketikkan informasi barang yang akan diinputkan kedalam kolom yang telah disediakan.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "3. ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Setelah semua informasi telah dimasukkan, klik tombol 'Tambah Item'. Anda akan diarahkan kembali ke halaman utama, dan item barang telah berhasil dimasukkan",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  //tips
                                  const SizedBox(height: 14,),
                                  Text(
                                    "Tips. ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "1.   ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Apabila Anda ingin membatalkan proses input, klik tombol 'Kembali' atau menggunakan tombol kembali perangkat ponsel Anda.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "2.  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Apabila terjadi kesalahan dalam proses input barang, atau proses input tidak dapat dilaksanakan dengan semestinya,"
                                              "mohon cek kembali koneksi internet pada ponsel Anda, karena proses input kedalam sistem memerlukan"
                                              "koneksi internet.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "3.  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Apabila daftar item logistik masuk tidak terbarui setelah proses input barang,"
                                              "cek kembali koneksi interet anda, lalu navigasikan halaman ke menu Logistik Keluar,"
                                              "lalu klik kembali ke menu Logistik Masuk. Hal ini bertujuan untuk memuat ulang daftar"
                                              "yang ada pada Logistik Masuk",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),

                    //detail item help
                    Card(
                      color: Colors.grey.shade300,
                      elevation: 0,
                      child: ExpansionTile(
                        backgroundColor: taSecondaryColor,
                        collapsedIconColor: Colors.grey.shade400,
                        maintainState: true,
                        expandedAlignment: Alignment.center,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 14),
                          child: Text(
                            "Cara menampilkan detail item logistik",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: taPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 26),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //solving methods
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Klik item barang yang telah tersedia di daftar. Anda akan diarahkan ke halaman detail barang. Halaman detail barang telah berisi seluruh informasi terkait barang tersebut",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  //tips
                                  const SizedBox(height: 14,),
                                  Text(
                                    "Tips. ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Pada halaman detail barang masuk, terdapat tombol tambahan yang berfungsi untuk proses barang keluar",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),

                    //add logisticOut item help
                    Card(
                      color: Colors.grey.shade300,
                      elevation: 0,
                      child: ExpansionTile(
                        backgroundColor: taSecondaryColor,
                        collapsedIconColor: Colors.grey.shade400,
                        maintainState: true,
                        expandedAlignment: Alignment.center,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 14),
                          child: Text(
                            "Cara mengeluarkan item logistik",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: taPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 26),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //solving methods
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "1.  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Klik detail barang yang akan dikeluarkan di daftar item yang tersedia pada halaman menu Logistik Masuk.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "2. ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Klik tombol 'Lanjutkan untuk barang keluar' yang terletak pada bagian bawah halaman detail barang masuk.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "3. ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Masukkan informasi tambahan terkait barang yang akan dikeluarkan sesuai dengan perintah yang ditampilkan pada halaman.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "4. ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Setelah informasi tambahan telah dimasukkan, klik tombol 'Konfirmasi' untuk melanjutkan. "
                                              "Anda akan diarahkan kembali ke halaman utama, dan item barang telah sukses masuk kedalam daftar"
                                              "pada halaman menu Logistik Keluar",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  //tips
                                  const SizedBox(height: 14,),
                                  Text(
                                    "Tips. ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "1.   ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Apabila Anda ingin membatalkan proses input barang keluar, klik tombol 'Batal' atau menggunakan tombol kembali perangkat ponsel Anda.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "2.  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Apabila terjadi kesalahan dalam proses input barang keluar, atau proses input tidak dapat dilaksanakan dengan semestinya,"
                                              "mohon cek kembali koneksi internet pada ponsel Anda, karena proses input kedalam sistem memerlukan"
                                              "koneksi internet.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),

                    //search item help
                    Card(
                      color: Colors.grey.shade300,
                      elevation: 0,
                      child: ExpansionTile(
                        backgroundColor: taSecondaryColor,
                        collapsedIconColor: Colors.grey.shade400,
                        maintainState: true,
                        expandedAlignment: Alignment.center,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 14),
                          child: Text(
                            "Cara melakukan pencarian data",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: taPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 26),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //solving methods
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "1.   ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Klik pada kotak pencarian.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "2.   ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Ketikkan nama barang yang ingin Anda cari.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "3.   ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Daftar item akan otomatis terbarui sesuai kata kunci yang Anda masukkan.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                  //tips
                                  const SizedBox(height: 14,),
                                  Text(
                                    "Tips. ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Daftar item akan bertuliskan 'Data tidak ditemukan' apabila kata kunci pencarian tidak"
                                              "cocok dengan nama item apapun yang tersedia didalam daftar.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),

                    //filter item help
                    Card(
                      color: Colors.grey.shade300,
                      elevation: 0,
                      child: ExpansionTile(
                        backgroundColor: taSecondaryColor,
                        collapsedIconColor: Colors.grey.shade400,
                        maintainState: true,
                        expandedAlignment: Alignment.center,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 14),
                          child: Text(
                            "Cara melakukan filter data",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: taPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 26),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //solving methods
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "1.   ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Klik tombol filter yang berada disebelah kanan kotak pencarian. Anda akan diarahkan ke halaman 'Filter Data'.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "2.  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Pada halaman tersebut, pilih opsi filter yang Anda inginkan. Pilihan yang terdapat "
                                              "di bawah judul 'Kategori' akan mengkategorikan daftar item bedasarkan "
                                              "kategori yang dipilih, dan dapat memilih lebih dari satu.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "3.  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Dibawah judul 'Tanggal Masuk' atau 'Tanggal Keluar' terdapat dua kolom yang digunakan untuk"
                                              "memilih tanggal sesuai yang diinginkan. Daftar item logistik masuk atau logistik keluar"
                                              "akan terbarui sesuai dengan tanggal masuk atau tanggal keluar yang telah dipilih."
                                              "Apabila ingin menampilkan daftar item bedasarkan dari satu tanggal masuk "
                                              "atau tanggal keluar, Anda dapat menggunakan kolom dengan judul 'Awal' saja, dan apabila"
                                              "ingin menampilkan daftar item yang berada di jarak antara dua tanggal, Anda dapat"
                                              "mengisikan kolom dengan judul 'Akhir', setelah Anda menentukan tanggal pada kolom 'Awal'.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "3.  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Apabila telah selesai memilih, tekan tombol 'Terapkan' untuk menerapkan filter, dan kembali ke halaman utama"
                                              "Apabila ingin mengulang pemilihan filter, tekan tombol 'Hapus Semua'",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  //tips
                                  const SizedBox(height: 14,),
                                  Text(
                                    "Tips. ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "1.   ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Untuk menutup halaman 'Filter Data', Anda harus menggunakan  tombol 'Terapkan'."
                                              "Halaman tidak akan tertutup dengan cara menekan layar diluar halaman 'Filter Data'"
                                              "maupun dengan menekan tombol kembali perangkat Anda",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "2.  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Daftar item akan bertuliskan 'Data tidak ditemukan' apabila pemilihan tanggal tidak sesuai"
                                              "dengan yang ada pada sistem. Harap diperhatikan bahwa tanggal masuk atau tanggal keluar"
                                              "dengan judul 'Akhir' tidak dapat lebih awal daripada tanggal dengan judul 'Awal', dan"
                                              "kedua kolom ini tidak dapat memiliki nilai tanggal yang sama.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),

                    //report item help
                    Card(
                      color: Colors.grey.shade300,
                      elevation: 0,
                      child: ExpansionTile(
                        backgroundColor: taSecondaryColor,
                        collapsedIconColor: Colors.grey.shade400,
                        maintainState: true,
                        expandedAlignment: Alignment.center,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 14),
                          child: Text(
                            "Cara mencetak laporan logistik",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: taPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 26),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //solving methods
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "1.   ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Klik tombol '☰' di bagian kanan bawah, lalu klik ikon 'Pdf'. Anda akan diarahkan ke halaman pratinjau laporan.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "2.  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Klik tombol 'Bagikan' untuk membagikan laporan, dan klik tombol 'Tutup Pratinjau' untuk kembali ke halaman utama.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  //tips
                                  const SizedBox(height: 14,),
                                  Text(
                                    "Tips. ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "1.   ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Data yang akan dicetak dapat disaring terlebih dahulu sesuai kebutuhan dengan menggunakan opsi pencarian maupun filter.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "2.  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Fail yang telah dibagikan juga akan tersimpan "
                                              "didalam penyimpanan ponsel Anda pada folder 'Downloads'.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),

                    // Card(
                    //   color: Colors.grey.shade300,
                    //   elevation: 0,
                    //   child: ExpansionTile(
                    //     backgroundColor: taSecondaryColor,
                    //     collapsedIconColor: Colors.grey.shade400,
                    //     maintainState: true,
                    //     expandedAlignment: Alignment.center,
                    //     title: Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 14),
                    //       child: Text(
                    //         "Tidak dapat login kedalam aplikasi",
                    //         style: GoogleFonts.poppins(
                    //           fontSize: 16,
                    //           color: taPrimaryColor,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ),
                    //     children: [
                    //       Padding(
                    //           padding: const EdgeInsets.only(left: 25, right: 25, bottom: 26),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Row(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Text(
                    //                     "1.  ",
                    //                     style: GoogleFonts.poppins(
                    //                       fontSize: 14,
                    //                     ),
                    //                   ),
                    //                   Flexible(
                    //                     child: Text(
                    //                       "Mohon cek apakah internet sudah terhubung dengan baik.",
                    //                       style: GoogleFonts.poppins(
                    //                         fontSize: 14,
                    //                       ),
                    //                     ),
                    //                   )
                    //                 ],
                    //               ),
                    //               Row(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Text(
                    //                     "2. ",
                    //                     style: GoogleFonts.poppins(
                    //                       fontSize: 14,
                    //                     ),
                    //                   ),
                    //                   Flexible(
                    //                     child: Text(
                    //                       "Mohon cek kembali informasi akun yang Anda gunakan untuk login.",
                    //                       style: GoogleFonts.poppins(
                    //                         fontSize: 14,
                    //                       ),
                    //                     ),
                    //                   )
                    //                 ],
                    //               ),
                    //               Row(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Text(
                    //                     "3. ",
                    //                     style: GoogleFonts.poppins(
                    //                       fontSize: 14,
                    //                     ),
                    //                   ),
                    //                   Flexible(
                    //                     child: Text(
                    //                       "Apabila masih terjadi kendala, mohon hubungi admin untuk bantuan lebih lanjut",
                    //                       style: GoogleFonts.poppins(
                    //                         fontSize: 14,
                    //                       ),
                    //                     ),
                    //                   )
                    //                 ],
                    //               ),
                    //             ],
                    //           )
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ]
              ),
            ),
            SizedBox(height: screenHeight * 0.025 ,),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Kontak Bantuan:',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Untuk bantuan lebih lanjut, mohon hubungi \nrizqymahardika21@gmail.com.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02 ,),
          ],
        )
      )
    );
  }
}
