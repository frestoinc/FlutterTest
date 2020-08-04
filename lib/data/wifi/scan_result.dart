import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scan_result.g.dart';

@JsonSerializable(explicitToJson: true)
@immutable
class ScanResult extends Equatable {
  @JsonKey(name: 'SSID')
  final String SSID;

  @JsonKey(name: 'BSSID')
  final String BSSID;

  @JsonKey(name: 'capabilities')
  final String capabilities;

  @JsonKey(name: 'level')
  final int level;

  @JsonKey(name: 'frequency')
  final int frequency;

  @JsonKey(name: 'timestamp')
  final int timestamp;

  ScanResult({
    this.SSID,
    this.BSSID,
    this.capabilities,
    this.level,
    this.frequency,
    this.timestamp,
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) =>
      _$ScanResultFromJson(json);

  Map<String, dynamic> toJson() => _$ScanResultToJson(this);

  @override
  List<Object> get props =>
      [SSID, BSSID, capabilities, level, frequency, timestamp];

  @override
  bool get stringify => true;
}
