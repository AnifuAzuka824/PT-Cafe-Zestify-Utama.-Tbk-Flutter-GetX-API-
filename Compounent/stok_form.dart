import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_aplication_cafe/Compounent/panel_card.dart';
import 'package:flutter_aplication_cafe/Compounent/zestify_textfield.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class StokForm extends StatelessWidget {
  final String judul;
  final IconData icon;
  final Color warna;
  final List<ProdukModel> produk;
  final int Function(int id) stokDari;
  final Rxn<int> pilihan;
  final TextEditingController qtyController;
  final TextEditingController petugasController;
  final TextEditingController keteranganController;
  final String hintPetugas;
  final String labelKeterangan;
  final String hintKeterangan;
  final String labelTombol;
  final VoidCallback onSimpan;

  const StokForm({
    super.key,
    required this.judul,
    required this.icon,
    required this.warna,
    required this.produk,
    required this.stokDari,
    required this.pilihan,
    required this.qtyController,
    required this.petugasController,
    required this.keteranganController,
    required this.hintPetugas,
    required this.labelKeterangan,
    required this.hintKeterangan,
    required this.labelTombol,
    required this.onSimpan,
  });

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      judul: judul,
      icon: icon,
      warnaIcon: warna,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 6, bottom: 8),
            child: Text(
              'Nama Barang',
              style: TextStyle(
                color: ZestifyColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: ZestifyColors.input,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: ZestifyColors.border),
            ),
            child: Obx(
              () => DropdownButton<int>(
                value: pilihan.value,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                dropdownColor: ZestifyColors.input,
                borderRadius: BorderRadius.circular(14),
                iconEnabledColor: ZestifyColors.gold,
                hint: const Text(
                  '-- Pilih Barang --',
                  style: TextStyle(color: Color(0xFF555555)),
                ),
                style: const TextStyle(color: ZestifyColors.text, fontSize: 15),
                items: [
                  for (final p in produk)
                    DropdownMenuItem(
                      value: p.id,
                      child: Text(
                        '${p.namaProduk} (${stokDari(p.id)})',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (id) => pilihan.value = id,
              ),
            ),
          ),
          const SizedBox(height: 14),
          ZestifyTextField(
            label: 'Kuantitas (Porsi)',
            hintText: 'Contoh: 50',
            controller: qtyController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          ZestifyTextField(
            label: 'Operator',
            hintText: hintPetugas,
            controller: petugasController,
          ),
          const SizedBox(height: 14),
          ZestifyTextField(
            label: labelKeterangan,
            hintText: hintKeterangan,
            controller: keteranganController,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: onSimpan,
            icon: const Icon(Icons.save, size: 18),
            label: Text(labelTombol),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: warna,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
