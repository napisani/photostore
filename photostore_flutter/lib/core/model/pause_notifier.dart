class PauseNotifier {
  bool _paused = false;

  reset() => _paused = false;

  get hasBeenPaused => _paused;

  pause() => _paused = true;

  resume() => _paused = false;
}
