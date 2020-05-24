import 'package:hanoi_tower_control/src/tower_elements.dart';
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

    test('No disks can be found if pin is reset', () {
      var pinTest = Pin();
      pinTest.add(Disk(4));
      pinTest.add(Disk(3));
      pinTest.add(Disk(2));

      pinTest.remove();

      pinTest.reset();

      pinTest.add(Disk(5));

      pinTest.remove();

      () => expect(pinTest.remove(), throwsStateError);
    });

    test('All disks can be removed after initializing a Pin', () {
      var pinTest = Pin();

      pinTest.init(5);

      assert(Disk(1) == pinTest.remove());
      assert(Disk(2) == pinTest.remove());
      assert(Disk(3) == pinTest.remove());
      assert(Disk(4) == pinTest.remove());
      assert(Disk(5) == pinTest.remove());
    });

    test('Adding 5 disks and removing 2 the balance is 3', () {
      var pinTest = Pin();

      pinTest.add(Disk(7));
      pinTest.add(Disk(6));
      pinTest.add(Disk(5));
      pinTest.add(Disk(4));
      pinTest.add(Disk(3));
      pinTest.remove();
      pinTest.remove();

      assert(3 == pinTest.diskBalance());
    });
  });
}