import 'dart:math';

import 'package:hanoi_tower_control/hanoi_tower_control.dart';

class Game {
  final Pin _pinFirst = Pin();
  final Pin _pinSecond = Pin();
  final Pin _pinThird = Pin();

  int _movesDone = 0;
  int _minimumMovesRequired;
  int _totalDisks;

  bool _isGrabbing = false;

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
    return Progress(_movesDone, _isGameOver(), null, _minimumMovesRequired,
                    _pinFirst.pinDisks(), _pinSecond.pinDisks(), _pinThird.pinDisks());
  }

  Future<Progress> grabFromFirstPin() async {
    var disk = _removeFrom(_pinFirst);
    return Progress(_movesDone, _isGameOver(), disk, _minimumMovesRequired,
                    _pinFirst.pinDisks(), _pinSecond.pinDisks(), _pinThird.pinDisks());
  }

  Future<Progress> grabFromSecondPin() async {
    var disk = _removeFrom(_pinSecond);
    return Progress(_movesDone, _isGameOver(), disk, _minimumMovesRequired,
        _pinFirst.pinDisks(), _pinSecond.pinDisks(), _pinThird.pinDisks());
  }

  Future<Progress> grabFromThirdPin() async {
    var disk = _removeFrom(_pinThird);
    return Progress(_movesDone, _isGameOver(), disk, _minimumMovesRequired,
        _pinFirst.pinDisks(), _pinSecond.pinDisks(), _pinThird.pinDisks());
  }

  Disk _removeFrom(Pin pin) {
    if (_isGrabbing) throw StateError('Can not grab another dis while one is grabbed');
    if (_totalDisks < 1) throw StateError('Game has not started');
    if (_isGameOver()) throw StateError('Game is over and no disk can be removed.');
    var result = pin.remove();
    _isGrabbing = true;
    return result;
  }

  Future<Progress> dropDiskInFirstPin(Disk disk) async {
    return dropDisk(_pinFirst, disk);
  }

  Future<Progress> dropDiskInSecondPin(Disk disk) async {
    return dropDisk(_pinSecond, disk);
  }

  Future<Progress> dropDiskInThirdPin(Disk disk) async {
    return dropDisk(_pinThird, disk);
  }

  Progress dropDisk(Pin pin, Disk disk) {
    if (_totalDisks < 1) throw StateError('Game has not started');
    if (_isGameOver()) throw StateError('Game is over and no disk can be added');
    pin.add(disk);
    _isGrabbing = false;
    _movesDone++;
    return Progress(_movesDone, _isGameOver(), null, _minimumMovesRequired,
                    _pinFirst.pinDisks(), _pinSecond.pinDisks(), _pinThird.pinDisks());
  }

  bool _isGameOver() => _totalDisks == _pinThird.pinDisks().disks.length;
}

class Progress {
  final int moves;
  final bool isGameOver;
  final int _minimumMovesRequired;
  final Disk diskGrabbed;
  final PinDisks _disksFirstPin;
  final PinDisks _disksSecondPin;
  final PinDisks _disksThirdPin;

  Progress(this.moves, this.isGameOver,
           this.diskGrabbed, this._minimumMovesRequired,
           this._disksFirstPin, this._disksSecondPin, this._disksThirdPin);

  double score() => isGameOver ? _minimumMovesRequired / moves : 0;
  PinDisks disksFirstPin() => _disksFirstPin;
  PinDisks disksSecondPin() => _disksSecondPin;
  PinDisks disksThirdPin() => _disksThirdPin;
}
