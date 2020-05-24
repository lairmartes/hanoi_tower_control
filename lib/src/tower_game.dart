import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'dart:math';

class Game {
  final Pin _pinFirst = Pin();
  final Pin _pinSecond = Pin();
  final Pin _pinThird = Pin();

  int _movesDone = 0;
  int _minimumMovesRequired;
  int _totalDisks;

  void start(int totalDisks) async {
    _totalDisks = totalDisks;
    _pinFirst.reset();
    _pinSecond.reset();
    _pinThird.reset();
    _pinFirst.init(_totalDisks);
    _movesDone = 0;
    _minimumMovesRequired = pow(2, _totalDisks) - 1;
  }

  Future<Disk> grabFromFirstPin() async {
    return removeFrom(_pinFirst);
  }

  Future<Disk> grabFromSecondPin() async {
    return removeFrom(_pinSecond);
  }

  Future<Disk> grabFromThirdPin() async {
    return removeFrom(_pinThird);
  }

  Disk removeFrom(Pin pin) {
    if (isGameOver()) throw StateError('Game is over and no disk can be removed.');
    return pin.remove();
  }

  Future<GameProgress> dropDiskInFirstPin(Disk disk) async {
    return dropDisk(_pinFirst, disk);
  }

  Future<GameProgress> dropDiskInSecondPin(Disk disk) async {
    return dropDisk(_pinFirst, disk);
  }

  Future<GameProgress> dropDiskInThirdPin(Disk disk) async {
    return dropDisk(_pinFirst, disk);
  }

  GameProgress dropDisk(Pin pin, Disk disk) {
    if (isGameOver()) throw StateError('Game is over and no disk can be added');
    pin.add(disk);
    return GameProgress(_movesDone, isGameOver(), _minimumMovesRequired);
  }

  bool isGameOver() => _totalDisks == _pinThird.diskBalance();
}

class GameProgress {
  final int _movesDone;
  final bool _isGameOver;
  final int _minimumMovesRequired;

  GameProgress(this._movesDone, this._isGameOver, this._minimumMovesRequired);

  int moves() => _movesDone;
  bool isGameOver() => _isGameOver;
  double score() => _minimumMovesRequired / _movesDone;
}


