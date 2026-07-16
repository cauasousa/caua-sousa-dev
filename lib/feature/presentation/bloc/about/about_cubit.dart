import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about_state.dart';

class AboutCubit extends Cubit<AboutState> {
  AboutCubit() : super(AboutState(capabilities: _initializeCapabilities()));

  static const String resumeUrl =
      'https://drive.google.com/file/d/1h7S4Vx7p8x4KJkVt4k5Q8j4uX8X2w7uT/view?usp=sharing';

  static List<Capability> _initializeCapabilities() {
    return [
      Capability(
        title: 'Full Stack Development',
        icon: Icons.developer_board_outlined,
        lines: [
          CapabilityLine(
            'Mobile',
            'Building performant, native experiences',
            badges: ['Flutter', 'Dart'],
            badgeColor: Color(0xFF60A5FA),
          ),
          CapabilityLine(
            'Backend',
            'Scalable APIs and real-time services',
            badges: ['Python', 'FastAPI', 'Django', 'Flask'],
            badgeColor: Color(0xFF34D399),
          ),
          CapabilityLine(
            'Frontend',
            'Interactive and responsive interfaces',
            badges: ['HTML/CSS', 'JavaScript', 'React', 'Next.js'],
            badgeColor: Color(0xFFE6B9F2),
          ),
          CapabilityLine(
            'Database',
            'Data architecture and optimization',
            badges: ['Firebase', 'SQL', 'MongoDB', 'PostgreSQL'],
            badgeColor: Color(0xFFFBBF24),
          ),
        ],
      ),
      Capability(
        title: 'Artificial Intelligence',
        icon: Icons.psychology_alt_outlined,
        lines: [
          CapabilityLine(
            '---',
            'Computer Vision & Deep Learning',
            badges: ['YOLO', 'DETR', 'RT-DETR', 'PyTorch', 'TensorFlow', "OpenCV"],
            badgeColor: Color(0xFF60A5FA),
          ),
          CapabilityLine(
            '--',
            'Edge AI & Model Optimization',
            badges: ['TensorRT', 'ONNX', 'Quantization', 'Optimization'],
            badgeColor: Color(0xFF34D399),
          ),
          CapabilityLine(
            '--',
            'Embedded Systems & Robotics',
            badges: ['ROS2', 'FPGA', 'Hardware Integration'],
            badgeColor: Color(0xFF34D399),
          ),

          
        ],
      ),
      
      Capability(
        title: 'Others',
        icon: Icons.design_services_outlined,
        lines: [
          CapabilityLine(
            'Embedded Systems',
            'Deploying models on hardware',
            badges: ['Raspberry Pi', 'FPGA', 'Edge'],
            badgeColor: Color(0xFFE6B9F2),
          ),
          CapabilityLine(
            'Tools',
            'High-fidelity design and workflows',
            badges: ['Figma', 'UX'],
            badgeColor: Color(0xFF34D399),
          ),
        ],
      ),
    ];
  }

  void setCardHovered(int index, bool hovered) {
    emit(state.copyWith(
      hoveredCardIndex: hovered ? index : -1,
    ));
  }

  Future<void> downloadResume() async {
    emit(state.copyWith(isDownloadingResume: true, clearError: true));

    try {
      final uri = Uri.parse(resumeUrl);
      if (!await canLaunchUrl(uri)) {
        emit(
          state.copyWith(
            isDownloadingResume: false,
            error: 'Nao foi possivel abrir o curriculo.',
          ),
        );
        return;
      }

      await launchUrl(uri, mode: LaunchMode.externalApplication);
      emit(state.copyWith(isDownloadingResume: false));
    } catch (_) {
      emit(
        state.copyWith(
          isDownloadingResume: false,
          error: 'Erro ao iniciar download do curriculo.',
        ),
      );
    }
  }
}
