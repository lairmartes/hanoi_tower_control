import 'dart:math';

import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'dart:io';

void main() async {
  var game = Game();

  var grabFunctions = <Function>[];
  var dropFunctions = <Function>[];

  grabFunctions.add(() => game.grabFromFirstPin());
  grabFunctions.add(() => game.grabFromSecondPin());
  grabFunctions.add(() => game.grabFromThirdPin());

  dropFunctions.add((disk) => game.dropDiskInFirstPin(disk));
  dropFunctions.add((disk) => game.dropDiskInSecondPin(disk));
  dropFunctions.add((disk) => game.dropDiskInThirdPin(disk));

  _message('Welcome to Hanoi Tower game');

  var totalDisks = _requestNumberFromZeroTo('How many disks?', 10);

  if (totalDisks == 0) return;

  var stepStartGame = await game.start(totalDisks);

  _showPins(stepStartGame.disksFirstPin().disks, stepStartGame.disksSecondPin().disks,
            stepStartGame.disksThirdPin().disks, totalDisks);

  do {
    var grabFrom = _requestNumberFromZeroTo('Grab from pin', 3);
    if (grabFrom < 1) break;
    var stepGrabDisk = await grabFunctions[grabFrom-1]() as Progress;
    _showPins(stepGrabDisk.disksFirstPin().disks, stepGrabDisk.disksSecondPin().disks,
              stepGrabDisk.disksThirdPin().disks, totalDisks);
    var dropTo = _requestNumberFromZeroTo('Drop in pin', 3);
    if (dropTo < 1) break;
    var stepDropDisk = await dropFunctions[dropTo-1](stepGrabDisk.diskGrabbed) as Progress;
    _showPins(stepDropDisk.disksFirstPin().disks, stepDropDisk.disksSecondPin().disks,
              stepDropDisk.disksThirdPin().disks, totalDisks);

    if (stepDropDisk.isGameOver) {
      _message('Kudos! All disks were moved to third pin! Game is completed!');
      break;
    }
  } while (true);
}

void _showPins(List<Disk> pin1, List<Disk> pin2, List<Disk> pin3, totalDisks) {

  var linePin1 = _createPinLine(pin1, totalDisks);
  var linePin2 = _createPinLine(pin2, totalDisks);
  var linePin3 = _createPinLine(pin3, totalDisks);

  for (var i = 0; i < totalDisks; i++) {
    var line1 = linePin1[i].padRight(totalDisks, ' ');
    var line2 = linePin2[i].padRight(totalDisks, ' ');
    var line3 = linePin3[i].padRight(totalDisks, ' ');

    print('|   $line1   |   $line2   |   $line3   |');
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

void _message(String message) {
  var size = 70;
  var sizeCentral = ((size - message.length) / 2).round();
  print(''.padRight(size, '*'));
  print('*'.padRight(size - 1) + '*');
  print('*'.padRight(sizeCentral, ' ') + message + '*'.padLeft(sizeCentral, ' '));
  print('*'.padRight(size - 1) + '*');
  print(''.padRight(size, '*'));
}

int _requestNumberFromZeroTo(String fieldMessage, int maxNumber) {
  int result;

  do {
    stdout.write('$fieldMessage (1-$maxNumber) or 0 (or no number) to quit ');
    var input = stdin.readLineSync();
    result = int.tryParse(input);
    result ??= 0;
  } while (result < 0 || result > maxNumber);

  return result;
}