import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'social_links_state.dart';

class SocialLinksCubit extends Cubit<SocialLinksState> {
  SocialLinksCubit() : super(SocialLinksState());

  Future<void> openLink(String url) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final uri = Uri.parse(url);
      final isAsset = !url.startsWith('http') &&
          !url.startsWith('mailto') &&
          !url.startsWith('tel');

      if (isAsset) {
        await launchUrl(uri, webOnlyWindowName: '_blank');
        emit(state.copyWith(isLoading: false));
      } else if (await canLaunchUrl(uri)) {
        await launchUrl(uri,
            mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank');
        emit(state.copyWith(isLoading: false));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: 'Não foi possível abrir o link',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Erro ao abrir o link: $e',
      ));
    }
  }
}
