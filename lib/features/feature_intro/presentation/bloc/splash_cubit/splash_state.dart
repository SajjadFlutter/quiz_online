part of 'splash_cubit.dart';

class SplashState {
  final ConnectionStatus connectionStatus;

  SplashState({required this.connectionStatus});

  SplashState copyWith({required ConnectionStatus? newConnectionStatus}) {
    return SplashState(
      connectionStatus: newConnectionStatus ?? connectionStatus,
    );
  }
}
