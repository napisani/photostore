class CancelNotifier {
  bool _cancelled = false;

  reset() => _cancelled = false;

  get hasBeenCancelled => _cancelled;

  cancel() => _cancelled = true;
}
