import 'package:hanoi_tower_control/hanoi_tower_control.dart';

void main() async {
  var game = Game();

  var totalDisks = 5;

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
  pin.forEach((disk) => result.add(''.padRight(disk.size, '▒')));

  return result;
}