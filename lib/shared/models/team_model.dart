// Oluşturulan takımın saha, maç saati, diziliş ve oyuncu kadrosunu tutan veri modelidir.

import 'formation.dart';
import 'team_member_model.dart';

/// Kurulan bir 7v7 takımının kaptan, saha, tarih/saat, taktiksel diziliş
/// ve 7 kişilik oyuncu kadrosunu kapsayan ana veri modeli.
class TeamModel {
  final String id;
  final String captainId;
  final String captainName;
  final Formation formation;
  final String province;
  final String district;
  final String venueName;
  final String matchDate;
  final String startTime;
  final String endTime;
  final DateTime createdAt;
  final String status;
  final List<TeamMemberModel> members;

  const TeamModel({
    required this.id,
    required this.captainId,
    this.captainName = '',
    required this.formation,
    required this.province,
    required this.district,
    required this.venueName,
    required this.matchDate,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    this.status = 'active',
    this.members = const [],
  });

  /// Maç başlangıç ve bitiş saatini birleşik formatta döndürür (Örn: '20.00 - 21.00')
  String get timeSlot => '$startTime - $endTime';

  /// 'YYYY-MM-DD' formatındaki maç tarihini 'DD.MM.YYYY' görsel formatına dönüştürür
  String get formattedDate {
    final parts = matchDate.split('-');
    if (parts.length == 3) {
      return '${parts[2]}.${parts[1]}.${parts[0]}';
    }
    return matchDate;
  }

  /// Takım dizilişinde henüz oyuncu atanmamış boş mevki yuvalarının listesini hesaplar
  List<PlayerPositionSlot> get emptyPositions {
    final occupiedKeys = members
        .where((m) => m.displayName.trim().isNotEmpty)
        .map((m) => m.position)
        .toSet();
    return formation.positions
        .where((slot) => !occupiedKeys.contains(slot.key))
        .toList();
  }

  /// Mevcut modelin belirli alanlarını güncelleyerek yeni bir kopyasını üretir
  TeamModel copyWith({
    String? id,
    String? captainId,
    String? captainName,
    Formation? formation,
    String? province,
    String? district,
    String? venueName,
    String? matchDate,
    String? startTime,
    String? endTime,
    DateTime? createdAt,
    String? status,
    List<TeamMemberModel>? members,
  }) {
    return TeamModel(
      id: id ?? this.id,
      captainId: captainId ?? this.captainId,
      captainName: captainName ?? this.captainName,
      formation: formation ?? this.formation,
      province: province ?? this.province,
      district: district ?? this.district,
      venueName: venueName ?? this.venueName,
      matchDate: matchDate ?? this.matchDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      members: members ?? this.members,
    );
  }

  /// Modeli SQLite veritabanına eklemek için Map yapısına dönüştürür
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'captainId': captainId,
      'formation': formation.label,
      'province': province,
      'district': district,
      'venueName': venueName,
      'matchDate': matchDate,
      'startTime': startTime,
      'endTime': endTime,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  /// SQLite sorgu sonucundan (Map) model örneği oluşturur
  factory TeamModel.fromMap(
    Map<String, dynamic> map, {
    String captainName = '',
    List<TeamMemberModel> members = const [],
  }) {
    return TeamModel(
      id: map['id'] as String,
      captainId: map['captainId'] as String,
      captainName: captainName,
      formation: Formation.fromLabel(map['formation'] as String),
      province: map['province'] as String,
      district: map['district'] as String,
      venueName: map['venueName'] as String,
      matchDate: map['matchDate'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      status: (map['status'] as String?) ?? 'active',
      members: members,
    );
  }
}
