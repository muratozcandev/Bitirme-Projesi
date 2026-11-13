// İl, ilçe ve saha bilgilerini getiren soyut konum arayüzünü tanımlar.

/// Halı saha maçı için il, ilçe ve saha seçeneklerini sorgulayan konum arayüzü (repository interface).
abstract class LocationRepository {
  /// Sistemde kayıtlı şehir/il listesini alfabetik olarak döndürür.
  Future<List<String>> getProvinces();

  /// Seçili ile bağlı ilçeleri listeler.
  Future<List<String>> getDistricts(String province);

  /// Seçili il ve ilçede yer alan halı saha tesislerinin listesini döndürür.
  Future<List<String>> getVenues({
    required String province,
    required String district,
  });
}
