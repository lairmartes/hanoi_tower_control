import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'dart:math';

class Game {
  final Pin _pinFirst = Pin();
  final Pin _pinSecond = Pin();
  final Pin _pinThird = Pin();

  int _movesDone = 0;
  int _minimumMovesRequired;
  int _totalDisks;

  bool _isGrabbing;

  Game() {
    _totalDisks = 0;
  }

  Future<Progress> start(int totalDisks) async {
    if (totalDisks < 1) throw ArgumentError('Game must have at least one disk');
    _totalDisks = totalDisks;
    _pinFirst.reset();
    _pinSecond.reset();
    _pinThird.reset();
    _pinFirst.init(_totalDisks);
    _movesDone = 0;
    _minimumMovesRequired = pow(2, _totalDisks) - 1;
    _isGrabbing = false;
    return Progress(_movesDone, _isGameOver(), _minimumMovesRequired,
                    _pinFirst.pinDisks(), _pinSecond.pinDisks(), _pinThird.pinDisks());
  }

  Future<Disk> grabFromFirstPin() async {
    return _removeFrom(_pinFirst);
  }

  Future<Disk> grabFromSecondPin() async {
    return _removeFrom(_pinSecond);
  }

  Future<Disk> grabFromThirdPin() async {
    return _removeFrom(_pinThird);
  }

  Disk _removeFrom(Pin pin) {
    if (_totalDisks < 1) throw StateError('Game has not started');
    if (_isGameOver()) throw StateError('Game is over and no disk can be removed.');
    return pin.remove();
  }

  Future<Progress> dropDiskInFirstPin(Disk disk) async {
    return dropDisk(_pinFirst, disk);
  }

  Future<Progress> dropDiskInSecondPin(Disk disk) async {
    return dropDisk(_pinFirst, disk);
  }

  Future<Progress> dropDiskInThirdPin(Disk disk) async {
    return dropDisk(_pinFirst, disk);
  }

  Progress dropDisk(Pin pin, Disk disk) {
    if (_totalDisks < 1) throw StateError('Game has not started');
    if (_isGameOver()) throw StateError('Game is over and no disk can be added');
    if (_isGrabbing) throw StateError('Can not grab another dis while one is grabbed');
    pin.add(disk);
    _isGrabbing = false;
    return Progress(_movesDone, _isGameOver(), _minimumMovesRequired,
                    _pinFirst.pinDisks(), _pinSecond.pinDisks(), _pinThird.pinDisks());
  }

  bool _isGameOver() => _totalDisks == _pinThird.pinDisks().disks.length;
}

class Progress {
  final int _movesDone;
  final bool _isGameOver;
  final int _minimumMovesRequired;
  final PinDisks _disksFirstPin;
  final PinDisks _disksSecondPin;
  final PinDisks _disksThirdPin;

  Progress(this._movesDone, this._isGameOver, this._minimumMovesRequired,
           this._disksFirstPin, this._disksSecondPin, this._disksThirdPin);

  int moves() => _movesDone;
  bool isGameOver() => _isGameOver;
  double score() => _isGameOver ? 0 : _minimumMovesRequired / _movesDone;
  PinDisks disksFirstPin() => _disksFirstPin;
  PinDisks disksSecondPin() => _disksSecondPin;
  PinDisks disksThirdPin() => _disksThirdPin;
}
