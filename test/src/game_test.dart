import 'dart:math';

import 'package:hanoi_tower_control/src/tower_game.dart';
import 'package:hanoi_tower_control/src/tower_elements.dart';
import 'package:test/test.dart';

void main() {

  group('Game Test', () {

    test('Throws error when trying to grab if game is not started', () {
      var gameTest = Game();

      expect(() => gameTest.grabFromFirstPin(), throwsStateError);
    });

    test('Throws error when trying to drop if game is not started', () {
      var gameTest = Game();

      expect(() => gameTest.dropDiskInSecondPin(Disk(5)), throwsStateError);
    });

    test('Throws error when grabbing a disk without drop another grabbed', () {
      var gameTest = Game();

      gameTest.start(2);

      () async {
        await gameTest.grabFromFirstPin();
        expect(() => gameTest.grabFromFirstPin(), throwsStateError);
      };
    });

    test('Throws error when grab disk after game is over', () {
      var gameTest = Game();

      gameTest.start(1);

      () async {
        var disk = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(disk);
        expect(() async => await gameTest.grabFromThirdPin(), throwsStateError);
      };
    });

    test('Start the game with two disks and error will rise when trying to remove third', () {
      var gameTest = Game();

      Disk disk1;
      Disk disk2;

      gameTest.start(2);

      () async {
        disk1 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInSecondPin(disk1);
        disk2 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(disk2);
        expect(() => gameTest.grabFromFirstPin(), throwsStateError);
      };
    });

    test('When does two moves counts two moves', () {
      var gameTest = Game();

      Disk disk1;
      Disk disk2;
      Progress progress;

      gameTest.start(3);

      () async {
        disk1 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(disk1);

        disk2 = await gameTest.grabFromFirstPin();
        progress = await gameTest.dropDiskInSecondPin(disk2);
        assert(progress.moves() == 2);
      };
    });

    test('When game is not completed then the score is zero', () {
      var gameTest = Game();

      Disk disk1;
      Disk disk2;
      Progress progress;

      gameTest.start(3);

          () async {
        disk1 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(disk1);

        disk2 = await gameTest.grabFromFirstPin();
        progress = await gameTest.dropDiskInSecondPin(disk2);
        assert(progress.score() == 0);
      };
    });

    test('Flags game is over in progress only after game is over', () {
      var gameTest = Game();

      Progress progress;
      Disk disk1;
      Disk disk2;

      gameTest.start(2);

      () async {

        disk1 = await gameTest.grabFromFirstPin();
        progress = await gameTest.dropDiskInSecondPin(disk1);
        assert(progress.isGameOver() == false);

        disk2 = await gameTest.grabFromFirstPin();
        progress = await gameTest.dropDiskInThirdPin(disk2);
        assert(progress.isGameOver() == false);

        disk1 = await gameTest.grabFromSecondPin();
        progress = await gameTest.dropDiskInThirdPin(disk1);
        assert(progress.isGameOver());
      };
    });

    test('When plays perfect game then the score is 100%', () {
      var gameTest = Game();

      Disk disk1;
      Disk disk2;
      Disk disk3;

      Progress progress;

      gameTest.start(3);

      () async {
        disk1 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(disk1);
        disk2 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInSecondPin(disk2);
        disk1 = await gameTest.grabFromThirdPin();
        await gameTest.dropDiskInSecondPin(disk1);
        disk3 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(disk3);
        disk1 = await gameTest.grabFromSecondPin();
        await gameTest.dropDiskInFirstPin(disk1);
        disk2 = await gameTest.grabFromSecondPin();
        await gameTest.dropDiskInThirdPin(disk2);
        disk1 = await gameTest.grabFromFirstPin();
        progress = await gameTest.dropDiskInThirdPin(disk1);

        assert(progress.score() == 1);
      };
    });

    test('When play is not perfect game then the score is less than 100%, but greater than zero', () {
      var movesRequired = (int disks) => pow(2, disks);
      var gameTest = Game();

      Disk disk1;
      Disk disk2;

      Progress progress;

      gameTest.start(2);

      () async {
        disk1 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(disk1);

        disk2 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInSecondPin(disk2);

        disk1 = await gameTest.grabFromThirdPin();
        await gameTest.dropDiskInFirstPin(disk1);

        disk2 = await gameTest.grabFromSecondPin();
        await gameTest.dropDiskInThirdPin(disk2);

        disk1 = await gameTest.grabFromFirstPin();
        progress = await gameTest.dropDiskInThirdPin(disk1);

        assert(progress.score() == movesRequired(2) / 5);
      };
    });

  });
}