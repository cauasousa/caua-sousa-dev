import 'package:flutter/material.dart';

class Capability {
  const Capability({
    required this.title,
    required this.icon,
    required this.lines,
  });

  final String title;
  final IconData icon;
  final List<CapabilityLine> lines;
}

class CapabilityLine {
  const CapabilityLine(
    this.label,
    this.value, {
    this.badges = const [],
    this.badgeColor = const Color(0xFFE6B9F2),
  });

  final String label;
  final String value;
  final List<String> badges;
  final Color badgeColor;
}

class AboutState {
  const AboutState({
    this.isDownloadingResume = false,
    this.error,
    this.hoveredCardIndex = -1,
    this.capabilities = const [],
  });

  final bool isDownloadingResume;
  final String? error;
  final int hoveredCardIndex;
  final List<Capability> capabilities;

  AboutState copyWith({
    bool? isDownloadingResume,
    String? error,
    bool clearError = false,
    int? hoveredCardIndex,
    List<Capability>? capabilities,
  }) {
    return AboutState(
      isDownloadingResume: isDownloadingResume ?? this.isDownloadingResume,
      error: clearError ? null : (error ?? this.error),
      hoveredCardIndex: hoveredCardIndex ?? this.hoveredCardIndex,
      capabilities: capabilities ?? this.capabilities,
    );
  }
}
