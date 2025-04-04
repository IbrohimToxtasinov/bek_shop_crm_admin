import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'connectivity_event.dart';

part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc()
      : super(
          const ConnectivityState(
            connectivityResult: ConnectivityResult.none,
            hasInternet: false,
          ),
        ) {
    on<CheckConnectivity>(_checkConnectivity);
    add(CheckConnectivity());
  }

  final Connectivity _connectivity = Connectivity();

  _checkInitialState(Emitter emit) async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();

    if (results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi)) {
      emit(
        state.copyWith(
          hasInternet: true,
          connectivityResult: results.first,
        ),
      );
    } else {
      emit(
        state.copyWith(
          hasInternet: false,
          connectivityResult: results.first,
        ),
      );
    }

    debugPrint("HAS INTERNET INITIAL CHECK:${state.hasInternet}");
    debugPrint("HAS INTERNET INITIAL STATES:$results");
  }

  _checkConnectivity(
      CheckConnectivity event, Emitter<ConnectivityState> emit) async {
    _checkInitialState(emit);
    await emit.onEach(
      _connectivity.onConnectivityChanged,
      onData: (List<ConnectivityResult> results) {
        if (results.contains(ConnectivityResult.mobile) ||
            results.contains(ConnectivityResult.wifi)) {
          emit(state.copyWith(
            hasInternet: true,
            connectivityResult: results.first,
          ));
        } else {
          emit(state.copyWith(
            hasInternet: false,
            connectivityResult: results.first,
          ));
        }
        debugPrint("HAS INTERNET CONTINUES CHECK:${state.hasInternet}");
        debugPrint("HAS INTERNET CONTINUES STATES:$results");
      },
    );
  }
}
