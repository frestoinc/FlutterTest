// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanResult _$ScanResultFromJson(Map<String, dynamic> json) {
  return ScanResult(
    SSID: json['SSID'] as String,
    BSSID: json['BSSID'] as String,
    capabilities: json['capabilities'] as String,
    level: json['level'] as int,
    frequency: json['frequency'] as int,
    timestamp: json['timestamp'] as int,
  );
}

Map<String, dynamic> _$ScanResultToJson(ScanResult instance) =>
    <String, dynamic>{
      'SSID': instance.SSID,
      'BSSID': instance.BSSID,
      'capabilities': instance.capabilities,
      'level': instance.level,
      'frequency': instance.frequency,
      'timestamp': instance.timestamp,
    };
