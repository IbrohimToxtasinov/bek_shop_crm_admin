part of 'tab_cubit.dart';

class TabState extends Equatable {
  final int currentIndex;

  const TabState({required this.currentIndex});

  TabState copyWith({int? currentIndex}) {
    return TabState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object?> get props => [currentIndex];
}
