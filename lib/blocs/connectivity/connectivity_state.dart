// part of 'connectivity_bloc.dart';
//
// class ConnectivityState extends Equatable {
//   const ConnectivityState({
//     required this.connectivityResult,
//     required this.hasInternet,
//   });
//
//   final ConnectivityResult connectivityResult;
//   final bool hasInternet;
//
//   ConnectivityState copyWith({
//     ConnectivityResult? connectivityResult,
//     bool? hasInternet,
//   }) {
//     return ConnectivityState(
//       connectivityResult: connectivityResult ?? this.connectivityResult,
//       hasInternet: hasInternet ?? this.hasInternet,
//     );
//   }
//
//   @override
//   List<Object> get props => [
//     connectivityResult,
//     hasInternet,
//   ];
// }