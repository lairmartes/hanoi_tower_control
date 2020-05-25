import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'dart:io';

void main() async {
  var game = Game();
  int totalDisks;

  welcomeMessage();

  do {
    stdout.write('How many disks? (1-10) or 0 to quit > ');
    var input = stdin.readLineSync();
    totalDisks = int.tryParse(input);
    totalDisks ??= 0;
  } while (totalDisks < 0 || totalDisks > 10);

  if (totalDisks == 0) return;

  Progress progress;
  progress = await game.start(totalDisks);

  _showPins(progress.disksFirstPin().disks, progress.disksSecondPin().disks,
           progress.disksThirdPin().disks, totalDisks);
}

void _showPins(List<Disk> pin1, List<Disk> pin2, List<Disk> pin3, totalDisks) {

  var linePin1 = _createPinLine(pin1, totalDisks);
  var linePin2 = _createPinLine(pin2, totalDisks);
  var linePin3 = _createPinLine(pin3, totalDisks);

  for (var i = 0; i < totalDisks; i++) {
    var line1 = linePin1[i].padRight(totalDisks, ' ');
    var line2 = linePin2[i].padRight(totalDisks, ' ');
    var line3 = linePin3[i].padRight(totalDisks, ' ');

    print('| $line1 | $line2 | $line3 |');
  }
}

List<String> _createPinLine(List<Disk> pin, totalDisks) {
  var result = <String>[];
  var emptyLines = totalDisks - pin.length;

  for (var i = 0; i < emptyLines; i++) {
    result.add('');
  }
  pin.forEach((disk) => result.add(''.padRight(disk.size, '█')));

  return result;
}

void welcomeMessage() {
  var size = 60;
  var message = 'Welcome to Hanoi Tower Example';
  var sizeCentral = ((size - message.length) / 2).round();
  print(''.padRight(size, '*'));
  print('*'.padRight(size - 1) + '*');
  print('*'.padRight(sizeCentral, ' ') + message + '*'.padLeft(sizeCentral, ' '));
  print('*'.padRight(size - 1) + '*');
  print(''.padRight(size, '*'));
}