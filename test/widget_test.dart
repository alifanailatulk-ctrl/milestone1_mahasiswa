import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestone1_mahasiswa/main.dart';

void main() {
  testWidgets('Tambah mahasiswa lalu buka halaman detail', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Awal: 1 mahasiswa
    expect(find.text('Mahasiswa (1)'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsOneWidget);

    // Buka form lewat tombol +
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Mahasiswa'), findsOneWidget);

    // Isi form
    final kolom = find.byType(TextFormField);
    await tester.enterText(kolom.at(0), 'Siti Aminah');
    await tester.enterText(kolom.at(1), '2201002');
    await tester.enterText(kolom.at(2), 'siti@mail.com');
    await tester.enterText(kolom.at(3), 'Teknik Informatika');

    // Simpan
    await tester.tap(find.text('Simpan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Kembali ke Dashboard: daftar bertambah + SnackBar
    expect(find.text('Mahasiswa (2)'), findsOneWidget);
    expect(find.text('Siti Aminah'), findsOneWidget);
    expect(find.text('Siti Aminah berhasil ditambahkan'), findsOneWidget);

    // Ketuk kartu mahasiswa baru -> halaman Detail
    await tester.tap(find.text('Siti Aminah'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Mahasiswa'), findsOneWidget);
    expect(find.text('siti@mail.com'), findsOneWidget);
    expect(find.text('Teknik Informatika'), findsOneWidget);
  });
}