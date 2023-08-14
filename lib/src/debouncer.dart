import 'dart:async';
import 'dart:ui';

/// A utility class that helps in debouncing function calls.
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  /// Creates a [Debouncer] instance with a specified debounce time in milliseconds.
  ///
  /// The [milliseconds] parameter determines the time interval for which
  /// the function calls will be debounced.
  Debouncer({required this.milliseconds});

  /// Runs the provided [action] after a debounce period.
  ///
  /// If this method is called again within the specified [milliseconds] interval,
  /// the previous call to [run] will be canceled and a new timer will be started.
  /// After the debounce interval elapses, the [action] function will be invoked.
  ///
  /// Example:
  /// ```dart
  /// Debouncer debouncer = Debouncer(milliseconds: 300);
  ///
  /// void search(String query) {
  ///   debouncer.run(() {
  ///     // Perform search operation after debounce interval.
  ///     // This function will only be called if no new [run] calls occur
  ///     // within the specified [milliseconds] interval.
  ///     performSearch(query);
  ///   });
  /// }
  /// ```
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
