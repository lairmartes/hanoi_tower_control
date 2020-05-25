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

  _message(List.unmodifiable([
      'Welcome to Hanoi Tower game!',
      'Move all disks from pin 1 to pin 3',
      'However, a bigger pin can not be put over a shorter one!',
      ' ---------------------------------------------- ',
      'According to an Indian legend, if a game with 64 disks ...',
      '... is completed ...',
      '... then the world will end!']));

  var totalDisks = _requestNumberFromZeroTo('How many disks?', 10);

  if (totalDisks == 0) return;

  var stepStartGame = await game.start(totalDisks);

  _showPins(stepStartGame.disksFirstPin().disks,
            stepStartGame.disksSecondPin().disks,
            stepStartGame.disksThirdPin().disks, totalDisks,
            stepStartGame.diskGrabbed);

  Disk diskGrabbed;

  do {
    int grabFrom;
    int dropTo;
    do {
      grabFrom = _requestNumberFromZeroTo('Grab from pin', 3);
      if (grabFrom < 1) break;
      try {
        var stepGrabDisk = await grabFunctions[grabFrom - 1]() as Progress;
        diskGrabbed = stepGrabDisk.diskGrabbed;
        _showPins(stepGrabDisk.disksFirstPin().disks,
                  stepGrabDisk.disksSecondPin().disks,
                  stepGrabDisk.disksThirdPin().disks, totalDisks, diskGrabbed);

        break;
      } on StateError catch (e) {
        _alertMessage(e.message);
      }
    } while(true);

    if (grabFrom == 0) break;

    do {
      dropTo = _requestNumberFromZeroTo('Drop in pin', 3);
      if (dropTo < 1) break;
      Progress stepDropDisk;
      try {
        stepDropDisk = await dropFunctions[dropTo - 1](diskGrabbed) as Progress;
        _showPins(stepDropDisk.disksFirstPin().disks,
                  stepDropDisk.disksSecondPin().disks,
                  stepDropDisk.disksThirdPin().disks, totalDisks,
                  stepDropDisk.diskGrabbed);

        if (stepDropDisk.isGameOver) {
          _message( List.filled(1,
              'Kudos! All disks were moved to third pin! Game is completed!'));
          dropTo = 0;
        }
        break;
      } on ArgumentError catch (e) {
        _alertMessage(e.message);
      }
    } while (true);

    if (grabFrom == 0 || dropTo == 0) break;
  } while (true);
}

void _showPins(List<Disk> pin1, List<Disk> pin2, List<Disk> pin3, totalDisks, Disk diskGrabbed) {

  var linePin1 = _createPinLine(pin1, totalDisks);
  var linePin2 = _createPinLine(pin2, totalDisks);
  var linePin3 = _createPinLine(pin3, totalDisks);

  for (var i = 0; i < totalDisks; i++) {
    var messageDiskGrabbed = '';
    var line1 = linePin1[i].padRight(totalDisks, ' ');
    var line2 = linePin2[i].padRight(totalDisks, ' ');
    var line3 = linePin3[i].padRight(totalDisks, ' ');

    if (i == totalDisks - 1 && diskGrabbed != null) {
      messageDiskGrabbed = 'Disk grabbed: ' + ''.padRight(diskGrabbed.size, '█');
    }

    print('|   $line1   |   $line2   |   $line3   | $messageDiskGrabbed');
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

void _message(List<String> messages) {
  var size = 70;
  print(''.padRight(size, '*'));
  print('*'.padRight(size - 1) + '*');
  messages.forEach((message) {
    var sizeCentral = ((size - message.length) / 2).round();
    print('*'.padRight(sizeCentral, ' ') + message + '*'.padLeft(sizeCentral, ' '));
  } );
  print('*'.padRight(size - 1) + '*');
  print(''.padRight(size, '*'));
}

void _alertMessage(String message) {
  print('--> $message !!!');
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