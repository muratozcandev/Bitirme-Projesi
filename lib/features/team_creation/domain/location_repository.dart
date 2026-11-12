abstract class LocationRepository {
  Future<List<String>> getProvinces();
  Future<List<String>> getDistricts(String province);
  Future<List<String>> getVenues({
    required String province,
    required String district,
  });
}

