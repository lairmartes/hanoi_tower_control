import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'package:test/test.dart';

void main() {
  group('Disk Test', () {

    test('Disk must be greater if disk is greater', () {
      var disk = Disk(3);
      var greaterDisk = Disk(5);
      
      assert(greaterDisk.isGreater(disk));
    });

    test('Disk must NOT be greater if disk is lesser', () {
      var disk = Disk(5);
      var lesserDisk = Disk(3);

      assert(disk.isGreater(lesserDisk));
    });

    test('Disk must NOT be greater if disk is same size', () {
      var disk = Disk(3);
      var diskSameSize = Disk(3);

      assert(disk.isGreater(diskSameSize) == false);
    });

  });
}