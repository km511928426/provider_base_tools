import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider_base_tools/provider_base_tools.dart';

mixin ProviderTickerProviderStateMixin<T> on BaseModel<T>
    implements TickerProvider {
  Set<Ticker>? _tickers;

  // @override
  // void onClose() {
  //   assert(() {
  //     if (_tickers != null) {
  //       for (final ticker in _tickers!) {
  //         if (ticker.isActive) {
  //           throw FlutterError.fromParts(<DiagnosticsNode>[
  //             ErrorSummary('$this was disposed with an active Ticker.'),
  //             ErrorDescription(
  //               '$runtimeType created a Ticker via its GetTickerProviderStateMixin, but at the time '
  //               'dispose() was called on the mixin, that Ticker was still active. All Tickers must '
  //               'be disposed before calling super.dispose().',
  //             ),
  //             ErrorHint(
  //               'Tickers used by AnimationControllers '
  //               'should be disposed by calling dispose() on the AnimationController itself. '
  //               'Otherwise, the ticker will leak.',
  //             ),
  //             ticker.describeForError('The offending ticker was'),
  //           ]);
  //         }
  //       }
  //     }
  //     return true;
  //   }());
  //   super.onClose();
  // }

  @override
  Ticker createTicker(TickerCallback onTick) {
    if (_tickerModeNotifier == null) {
      // Setup TickerMode notifier before we vend the first ticker.
      _updateTickerModeNotifier();
    }
    assert(_tickerModeNotifier != null);
    _tickers ??= <_WidgetTicker>{};
    final _WidgetTicker result = _WidgetTicker(onTick, this,
        debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null)
      ..muted = !_tickerModeNotifier!.value;
    _tickers!.add(result);
    return result;
  }

  void _removeTicker(_WidgetTicker ticker) {
    assert(_tickers != null);
    assert(_tickers!.contains(ticker));
    _tickers!.remove(ticker);
  }

  ValueNotifier<bool>? _tickerModeNotifier;

  // @override
  // void activate() {
  //   super.activate();
  //   // We may have a new TickerMode ancestor, get its Notifier.
  //   _updateTickerModeNotifier();
  //   _updateTickers();
  // }

  void _updateTickers() {
    if (_tickers != null) {
      final bool muted = !_tickerModeNotifier!.value;
      for (final Ticker ticker in _tickers!) {
        ticker.muted = muted;
      }
    }
  }

  void _updateTickerModeNotifier() {
    final ValueNotifier<bool> newNotifier = TickerMode.getNotifier(OneContext.getInstance.context);
    if (newNotifier == _tickerModeNotifier) {
      return;
    }
    _tickerModeNotifier?.removeListener(_updateTickers);
    newNotifier.addListener(_updateTickers);
    _tickerModeNotifier = newNotifier;
  }

  @override
  void dispose() {
    assert(() {
      if (_tickers != null) {
        for (final Ticker ticker in _tickers!) {
          if (ticker.isActive) {
            throw FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary('$this was disposed with an active Ticker.'),
              ErrorDescription(
                '$runtimeType created a Ticker via its TickerProviderStateMixin, but at the time '
                'dispose() was called on the mixin, that Ticker was still active. All Tickers must '
                'be disposed before calling super.dispose().',
              ),
              ErrorHint(
                'Tickers used by AnimationControllers '
                'should be disposed by calling dispose() on the AnimationController itself. '
                'Otherwise, the ticker will leak.',
              ),
              ticker.describeForError('The offending ticker was'),
            ]);
          }
        }
      }
      return true;
    }());
    _tickerModeNotifier?.removeListener(_updateTickers);
    _tickerModeNotifier = null;
    super.dispose();
  }

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(DiagnosticsProperty<Set<Ticker>>(
  //     'tickers',
  //     _tickers,
  //     description: _tickers != null
  //         ? 'tracking ${_tickers!.length} ticker${_tickers!.length == 1 ? "" : "s"}'
  //         : null,
  //     defaultValue: null,
  //   ));
  // }
  // Ticker? _ticker;

  // @override
  // Ticker createTicker(TickerCallback onTick) {
  //   assert(() {
  //     if (_ticker == null) return true;
  //     throw FlutterError.fromParts(<DiagnosticsNode>[
  //       ErrorSummary(
  //           '$runtimeType is a GetSingleTickerProviderStateMixin but multiple tickers were created.'),
  //       ErrorDescription(
  //           'A GetSingleTickerProviderStateMixin can only be used as a TickerProvider once.'),
  //       ErrorHint(
  //         'If a State is used for multiple AnimationController objects, or if it is passed to other '
  //         'objects and those objects might use it more than one time in total, then instead of '
  //         'mixing in a GetSingleTickerProviderStateMixin, use a regular GetTickerProviderStateMixin.',
  //       ),
  //     ]);
  //   }());
  //   _ticker =
  //       Ticker(onTick, debugLabel: kDebugMode ? 'created by $this' : null);
  //   return _ticker!;
  // }

  // void didChangeDependencies(BuildContext context) {
  //   if (_ticker != null) _ticker!.muted = !TickerMode.of(context);
  // }

  // @override
  // void onClose() {
  //   assert(() {
  //     if (_ticker == null || !_ticker!.isActive) return true;
  //     throw FlutterError.fromParts(<DiagnosticsNode>[
  //       ErrorSummary('$this was disposed with an active Ticker.'),
  //       ErrorDescription(
  //         '$runtimeType created a Ticker via its GetSingleTickerProviderStateMixin, but at the time '
  //         'dispose() was called on the mixin, that Ticker was still active. The Ticker must '
  //         'be disposed before calling super.dispose().',
  //       ),
  //       ErrorHint(
  //         'Tickers used by AnimationControllers '
  //         'should be disposed by calling dispose() on the AnimationController itself. '
  //         'Otherwise, the ticker will leak.',
  //       ),
  //       _ticker!.describeForError('The offending ticker was'),
  //     ]);
  //   }());
  //   super.onClose();
  // }
}

class _WidgetTicker extends Ticker {
  _WidgetTicker(super.onTick, this._creator, {super.debugLabel});

  final ProviderTickerProviderStateMixin _creator;

  @override
  void dispose() {
    _creator._removeTicker(this);
    super.dispose();
  }
}
