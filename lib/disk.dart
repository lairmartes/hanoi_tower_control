class Disk {
  final int _size;

  Disk(this._size);

  bool isGreater(Disk disk) => _size > disk._size;
}