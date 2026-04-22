import 'package:flutter/material.dart';

class ContactAction {
  const ContactAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.url,
    required this.hoverColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String url;
  final Color hoverColor;
}

class ContactState {
  const ContactState({
    this.hoveredActionIndex = -1,
    this.actions = const [],
  });

  final int hoveredActionIndex;
  final List<ContactAction> actions;

  ContactState copyWith({
    int? hoveredActionIndex,
    List<ContactAction>? actions,
  }) {
    return ContactState(
      hoveredActionIndex: hoveredActionIndex ?? this.hoveredActionIndex,
      actions: actions ?? this.actions,
    );
  }
}
