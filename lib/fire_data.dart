class FireData {
  String countryId;
  double latitude;
  double longitude;
  double brightTi4;
  double scan;
  double track;
  String acqDate;
  int acqTime;
  String satellite;
  String instrument;
  String confidence;
  String version;
  double brightTi5;
  double frp;
  String dayNight;

  FireData({
    required this.countryId,
    required this.latitude,
    required this.longitude,
    required this.brightTi4,
    required this.scan,
    required this.track,
    required this.acqDate,
    required this.acqTime,
    required this.satellite,
    required this.instrument,
    required this.confidence,
    required this.version,
    required this.brightTi5,
    required this.frp,
    required this.dayNight,
  });
}
