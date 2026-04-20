├── assets/ <-- (Raiz do projeto)
│ ├── data/
│ │ └── tasks.json <-- (Onde ficarão teus dados simulados)
│ ├── images/
│ │ └── profile.png
│ └── fonts/
│
├── lib/
│ ├── core/
│ │ ├── di/
│ │ │ └── injection_container.dart
│ │ ├── error/
│ │ │ ├── exceptions.dart
│ │ │ └── failures.dart
│ │ ├── usecases/
│ │ │ └── usecase.dart
│ │ ├── utils/
│ │ │ ├── constants.dart
│ │ │ └── theme.dart
│ │ └── widgets/
│ │ ├── custom_navbar.dart
│ │ └── social_links.dart
│ │
│ ├── features/
│ │ └── tasks/
│ │ ├── data/
│ │ │ ├── datasources/
│ │ │ │ └── task_local_data_source.dart
│ │ │ ├── models/
│ │ │ │ └── task_model.dart
│ │ │ └── repositories/
│ │ │ └── task_repository_impl.dart
│ │ ├── domain/
│ │ │ ├── entities/
│ │ │ │ └── task.dart
│ │ │ ├── repositories/
│ │ │ │ └── task_repository.dart
│ │ │ └── usecases/
│ │ │ ├── get_tasks.dart
│ │ │ ├── add_task.dart
│ │ │ ├── update_task.dart
│ │ │ └── delete_task.dart
│ │ └── presentation/
│ │ ├── bloc/
│ │ │ ├── task_bloc.dart
│ │ │ ├── task_event.dart
│ │ │ └── task_state.dart
│ │ ├── pages/
│ │ │ └── task_page.dart
│ │ └── widgets/
│ │ ├── task_card.dart
│ │ └── task_dialog.dart
│ │
│ └── main.dart
│
├── pubspec.yaml <-- (Não esqueças de declarar o asset aqui)
└── build.sh <-- (Configuração para o deploy)