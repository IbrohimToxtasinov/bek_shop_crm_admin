import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tab_state.dart';

class TabCubit extends Cubit<TabState> {
  TabCubit() : super(TabState(currentIndex: 0));

  changeCurrentIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
