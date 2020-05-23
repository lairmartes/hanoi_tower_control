import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'package:test/test.dart';
import 'package:collection/collection.dart';

void main() {
  group('Pin Test', () {

    test('Cannot remove disk from empty pin',
      () => expect(() => Pin().remove(), throwsStateError));

    test('Cannot add a greater disk over a lesser one', () {
      var lesser = Disk(1);
      var greater = Disk(2);
      var pin = Pin();

      pin.add(lesser);
      expect(() => pin.add(greater), throwsArgumentError);
    });

    test('Disks must be removed in the order they have been put', () {
      var disksForTest = [Disk(1), Disk(2), Disk(3), Disk(4), Disk(5)];

      var pinTest = Pin();

      for (var i = 4; i >= 0; i--) {
        pinTest.add(disksForTest[i]);
      }

      var disksRemoved = [];

      var i = 0;
      while (i < 5) {
        disksRemoved.add(pinTest.remove());
        i++;
      }

      assert(ListEquality().equals(disksForTest, disksRemoved));

    });
  });

}