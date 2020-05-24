import 'package:hanoi_tower_control/src/tower_game.dart';
import 'package:hanoi_tower_control/src/tower_elements.dart';
import 'package:test/test.dart';

void main() {
  group('Game Test', () {

    test('Throw error when trying to grab if game is not started', () {
      var gameTest = Game();

      expect(() => gameTest.grabFromFirstPin(), throwsStateError);
    });

    test('Throw error when trying to drop if game is not started', () {
      var gameTest = Game();

      expect(() => gameTest.dropDiskInSecondPin(Disk(5)), throwsStateError);
    });

    test('Throw error when grabbing a disk without drop another grabbed', () {
      var gameTest = Game();

      gameTest.start(2);

      () async {
        await gameTest.grabFromFirstPin();
        expect(() => gameTest.grabFromFirstPin(), throwsStateError);
      };
    });

    test('Start the game with two disks and error will rise when trying to remove third', () {
      var gameTest = Game();

      gameTest.start(2);

      () async {
        var disk1 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInSecondPin(disk1);
        var disk2 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(disk2);
        expect(() => gameTest.grabFromFirstPin(), throwsStateError);
      };
    });

    test('When does two moves counts two moves', () {
      var gameTest = Game();

      gameTest.start(3);

      () async {
        var disk1 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(disk1);
        var disk2 = await gameTest.grabFromFirstPin();
        var progress = await gameTest.dropDiskInSecondPin(disk2);

        assert(progress.moves() == 2);
      };
    });
  });
}