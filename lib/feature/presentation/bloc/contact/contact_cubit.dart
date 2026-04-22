import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(ContactState(actions: _buildActions()));

  static List<ContactAction> _buildActions() {
    return const [
      ContactAction(
        title: 'Email',
        subtitle: 'Open a direct mail conversation',
        icon: Icons.email_outlined,
        url: 'mailto:cauasousa.dev@gmail.com',
        hoverColor: Color(0xFFE6B9F2),
      ),
      ContactAction(
        title: 'LinkedIn',
        subtitle: 'Connect professionally and keep in touch',
        icon: Icons.work_outline,
        url: 'https://www.linkedin.com/in/cau%C3%A3-de-sousa-lima-9734a7259/',
        hoverColor: Color(0xFF0EA5E9),
      ),
      ContactAction(
        title: 'Resume',
        subtitle: 'Download my latest CV and portfolio summary',
        icon: Icons.download_rounded,
        url:
            'https://drive.google.com/file/d/1h7S4Vx7p8x4KJkVt4k5Q8j4uX8X2w7uT/view?usp=sharing',
        hoverColor: Color(0xFF10B981),
      ),
    ];
  }

  void setHoveredActionIndex(int index) {
    emit(state.copyWith(hoveredActionIndex: index));
  }

  void clearHoveredAction() {
    emit(state.copyWith(hoveredActionIndex: -1));
  }
}
