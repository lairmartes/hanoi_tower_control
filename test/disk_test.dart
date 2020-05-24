import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'package:test/test.dart';

void main() {
  group('Disk Test', () {

    test('Disks must be equals if they have the same size', () {
      var disk1 = Disk(3);
      var disk2 = Disk(3);

      assert(disk1 == disk2);
    });

    test('Disk must be greater if disk is bigger', () {
      var disk = Disk(3);
      var biggerDisk = Disk(4);
      
      assert(biggerDisk > disk);
    });

    test('Disk must be lesser if disk is shorter', () {
      var disk = Disk(4);
      var shorterDisk = Disk(3);

      assert(shorterDisk < disk);
    });

    test('Disk must NOT be greater if disk is same size', () {
      var disk = Disk(3);
      var diskSameSize = Disk(3);

      assert((disk > diskSameSize) == false);
    });

    test('Disk must NOT be lesser if disk is same size', () {
      var disk = Disk(3);
      var diskSameSize = Disk(3);

      assert((disk < diskSameSize) == false);
    });

    test('Disk must NOT be greater if disk is shorter', () {
      var disk = Disk(4);
      var shorterDisk = Disk(3);

      assert((shorterDisk > disk) == false);
    });

    test('Disk must NOT be lesser if disk is bigger', () {
      var disk = Disk(3);
      var biggerDisk = Disk(4);

      assert((biggerDisk < disk) == false);
    });

    test('Launch error if disk is size zero',
            () => expect(() => Disk(0), throwsArgumentError));

    test('Launch error if disk is greater than 10',
            () => expect(() => Disk(11), throwsArgumentError));

  });
}