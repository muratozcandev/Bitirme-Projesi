abstract class LocationRepository { // LocationRepository soyut arayüz (interface) sınıfını tanımlar
  Future<List<String>> getProvinces(); // İlgili kod satırını ve işlemi yürütür
  Future<List<String>> getDistricts(String province); // İlgili kod satırını ve işlemi yürütür
  Future<List<String>> getVenues({ // İlgili kod satırını ve işlemi yürütür
    required String province, // İlgili kod satırını ve işlemi yürütür
    required String district, // İlgili kod satırını ve işlemi yürütür
  }); // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

