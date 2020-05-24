import 'package:stack/stack.dart';

class Disk {
  final int _size;

  Disk(this._size) {
    if (_size < 1 || _size > 10) throw ArgumentError('Disk size must be between 1 and 11');
  }

  @override
  bool operator ==(Object operand) =>
      identical(this, operand) || operand is Disk && _size == operand._size;

  bool operator >(Object operand) =>
      identical(this, operand) || operand is Disk && _size > operand._size;

  bool operator <(Object operand) =>
      identical(this, operand) || operand is Disk && _size < operand._size;
}

class Pin {
  Stack<Disk> _stack;

  Pin() {
    _stack = Stack();
  }

  void add(Disk disk) {
    if (_stack.isNotEmpty) {
      var diskTop = _stack.top();
      if (disk > diskTop) throw ArgumentError('Disk added cannot be greater than tha last included');
    }
    _stack.push(disk);
  }

  Disk remove() {
    if (_stack.isNotEmpty) {
      return _stack.pop();
    } else {
      throw StateError('Pin is empty and is not possible to remove disks');
    }
  }

  void reset() {
    while (_stack.isNotEmpty) {
      _stack.pop();
    }
  }

  void init(int totalDisks) {
    reset();
    for (var i=totalDisks ; i > 0; i--) {
      _stack.push(Disk(i));
    }
  }
}