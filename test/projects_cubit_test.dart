import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/projects/projects_cubit.dart';
import 'package:flutter_portfolio/feature/presentation/bloc/projects/projects_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loadProjects reads the portfolio list from task.json', () async {
    final cubit = ProjectsCubit();

    await cubit.loadProjects();

    expect(cubit.state.status, ProjectsStatus.success);
    expect(cubit.state.projects, isNotEmpty);
    expect(cubit.state.projects.any((project) => project.id == 'p07'), isTrue);
    expect(cubit.state.projects.first.title, 'Rocket League');
  });

  test('reopening the same project resets the selection before reopening', () async {
    final cubit = ProjectsCubit();
    final seenSelections = <String?>[];
    final subscription = cubit.stream.listen((state) {
      seenSelections.add(state.selectedProjectId);
    });

    cubit.openProjectDetails('p01');
    cubit.openProjectDetails('p01');

    await Future<void>.delayed(const Duration(milliseconds: 10));
    await subscription.cancel();

    expect(seenSelections, contains(null));
    expect(seenSelections.last, 'p01');
  });
}
