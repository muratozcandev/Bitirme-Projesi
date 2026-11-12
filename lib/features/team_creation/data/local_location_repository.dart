import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../../data/database/app_database.dart';
import '../../../data/seed/seed_data.dart';
import '../domain/location_repository.dart';

class LocalLocationRepository implements LocationRepository {
  final AppDatabase appDatabase;
  List<String>? _cachedProvinces;
  Map<String, List<String>>? _cachedDistricts;

  LocalLocationRepository({required this.appDatabase});

  static const String _turkishAlphabet =
      'AaBbCcÇçDdEeFfGgĞğHhIıİiJjKkLlMmNnOoÖöPpRrSsŞşTtUuÜüVvYyZz';

  static int compareTurkish(String a, String b) {
    final len = a.length < b.length ? a.length : b.length;
    for (var i = 0; i < len; i++) {
      final idxA = _turkishAlphabet.indexOf(a[i]);
      final idxB = _turkishAlphabet.indexOf(b[i]);
      if (idxA != -1 && idxB != -1 && idxA != idxB) {
        return idxA.compareTo(idxB);
      }
      if (a[i] != b[i]) {
        return a[i].compareTo(b[i]);
      }
    }
    return a.length.compareTo(b.length);
  }

  @override
  Future<List<String>> getProvinces() async {
    if (_cachedProvinces != null) {
      return _cachedProvinces!;
    }
    final jsonString =
        await rootBundle.loadString('assets/data/provinces.json');
    final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
    final list = decoded.map((e) => e.toString()).toList()
      ..sort(compareTurkish);
    _cachedProvinces = list;
    return list;
  }

  @override
  Future<List<String>> getDistricts(String province) async {
    if (_cachedDistricts == null) {
      final jsonString =
          await rootBundle.loadString('assets/data/districts.json');
      final Map<String, dynamic> decoded =
          jsonDecode(jsonString) as Map<String, dynamic>;
      _cachedDistricts = decoded.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => e.toString()).toList()
            ..sort(compareTurkish),
        ),
      );
    }
    return _cachedDistricts![province] ?? <String>[];
  }

  @override
  Future<List<String>> getVenues({
    required String province,
    required String district,
  }) async {
    final db = await appDatabase.database;
    final rows = await db.query(
      'venues_cache',
      where: 'province = ? AND district = ?',
      whereArgs: [province, district],
      orderBy: 'venueName ASC',
    );

    if (rows.isNotEmpty) {
      return rows.map((r) => r['venueName'] as String).toList();
    }

    final generated = SeedData.generateDeterministicVenues(province, district);
    final batch = db.batch();
    for (final venue in generated) {
      batch.insert(
        'venues_cache',
        {
          'province': province,
          'district': district,
          'venueName': venue,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
    return generated;
  }
}
