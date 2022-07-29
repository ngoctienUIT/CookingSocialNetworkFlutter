import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<Locale?> {
  final BuildContext context;

  LanguageCubit({required this.context}) : super(null) {
    load(context);
  }

  void load(BuildContext context) async {
    try {
      Locale locale = Localizations.localeOf(context);
      emit(locale);
    } catch (e) {
      emit(const Locale("vi", ""));
    }
  }

  void change(Locale locale) {
    emit(locale);
  }
}
