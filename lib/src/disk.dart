class Disk {
  final int _size;

  Disk(this._size) {
    if (_size < 1 || _size > 10) {
      throw ArgumentError('Disk size must be between 1 and 11');
    }
  }

  bool isGreater(Disk disk) => _size > disk._size;
}