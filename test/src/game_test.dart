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
        var progress = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(progress.diskGrabbed);
        expect(() async => await gameTest.grabFromThirdPin(), throwsStateError);
      };
    });

    test('Start the game with two disks and error will rise when trying to remove third', () {
      var gameTest = Game();

      Progress progress1;
      Progress progress2;

      gameTest.start(2);

      () async {
        progress1 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInSecondPin(progress1.diskGrabbed);
        progress2 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(progress2.diskGrabbed);
        expect(() => gameTest.grabFromFirstPin(), throwsStateError);
      };
    });

    test('When does two moves counts two moves', () {
      var gameTest = Game();

      Progress progress1;
      Progress progress2;
      Progress progress3;

      gameTest.start(3);

      () async {
        progress1 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(progress1.diskGrabbed);

        progress2 = await gameTest.grabFromFirstPin();
        progress3 = await gameTest.dropDiskInSecondPin(progress2.diskGrabbed);
        assert(progress3.moves == 2);
      };
    });

    test('When game is not completed then the score is zero', () {
      var gameTest = Game();

      Progress progress1;
      Progress progress2;
      Progress progress3;

      gameTest.start(3);

          () async {
        progress1 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(progress1.diskGrabbed);

        progress2 = await gameTest.grabFromFirstPin();
        progress3 = await gameTest.dropDiskInSecondPin(progress2.diskGrabbed);
        assert(progress3.score() == 0);
      };
    });

    test('Flags game is over in progress only after game is over', () {
      var gameTest = Game();

      Progress runningGame;
      Progress progressGameOver;
      Progress progress1;
      Progress progress2;
      Progress progress3;

      gameTest.start(2);

      () async {

        progress1 = await gameTest.grabFromFirstPin();
        runningGame = await gameTest.dropDiskInSecondPin(progress1.diskGrabbed);
        assert(runningGame.isGameOver == false);

        progress2 = await gameTest.grabFromFirstPin();
        runningGame = await gameTest.dropDiskInThirdPin(progress2.diskGrabbed);
        assert(runningGame.isGameOver == false);

        progress3 = await gameTest.grabFromSecondPin();
        progressGameOver = await gameTest.dropDiskInThirdPin(progress3.diskGrabbed);
        assert(progressGameOver.isGameOver);
      };
    });

    test('When plays perfect game then the score is 100%', () {
      var gameTest = Game();

      Progress progress1;
      Progress progress2;
      Progress progress3;

      Progress progress;

      gameTest.start(3);

      () async {
        progress1 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(progress1.diskGrabbed);
        progress2 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInSecondPin(progress2.diskGrabbed);
        progress1 = await gameTest.grabFromThirdPin();
        await gameTest.dropDiskInSecondPin(progress1.diskGrabbed);
        progress3 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(progress3.diskGrabbed);
        progress1 = await gameTest.grabFromSecondPin();
        await gameTest.dropDiskInFirstPin(progress1.diskGrabbed);
        progress2 = await gameTest.grabFromSecondPin();
        await gameTest.dropDiskInThirdPin(progress2.diskGrabbed);
        progress1 = await gameTest.grabFromFirstPin();
        progress = await gameTest.dropDiskInThirdPin(progress1.diskGrabbed);

        assert(progress.score() == 1);
      };
    });

    test('When play is not perfect game then the score is less than 100%, but greater than zero', () {
      var movesRequired = (int disks) => pow(2, disks);
      var gameTest = Game();

      Progress progress1;
      Progress progress2;

      Progress progress;

      gameTest.start(2);

      () async {
        progress1 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInThirdPin(progress1.diskGrabbed);

        progress2 = await gameTest.grabFromFirstPin();
        await gameTest.dropDiskInSecondPin(progress2.diskGrabbed);

        progress1 = await gameTest.grabFromThirdPin();
        await gameTest.dropDiskInFirstPin(progress1.diskGrabbed);

        progress2 = await gameTest.grabFromSecondPin();
        await gameTest.dropDiskInThirdPin(progress2.diskGrabbed);

        progress1 = await gameTest.grabFromFirstPin();
        progress = await gameTest.dropDiskInThirdPin(progress1.diskGrabbed);

        assert(progress.score() == movesRequired(2) / 5);
      };
    });

  });
}