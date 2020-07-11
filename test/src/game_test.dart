import 'dart:math';

import 'package:hanoi_tower_control/src/tower_elements.dart';
import 'package:hanoi_tower_control/src/tower_game.dart';
import 'package:test/test.dart';

void main() {

  group('Game Test', () {

    test('When game is not started, no grab moves are allowed', () async {

      var gameTest = Game();

      expect(gameTest.grabFromFirstPin(), throwsStateError);
    });

    test('When game is not started, no drop moves are allowed', () async {
      var gameTest = Game();

      expect(gameTest.dropDiskInSecondPin(Disk(5)), throwsStateError);
    });

    test('When a disk is grabbed, grab another is not allowed', () async {
      var gameTest = Game();

      await gameTest.start(2);

      await gameTest.grabFromFirstPin();
      expect(gameTest.grabFromFirstPin(), throwsStateError);
    });

    test('When game is over, no grab moves are allowed', () async {
      var gameTest = Game();

      await gameTest.start(1);

      var progress = await gameTest.grabFromFirstPin();
      await gameTest.dropDiskInThirdPin(progress.diskGrabbed);
      expect(gameTest.grabFromThirdPin(), throwsStateError);
    });

    test('When there is no disks in pin, then throw an error when try to remove one more', () async {
      var gameTest = Game();

      Progress step1;
      Progress step2;

      await gameTest.start(2);

      step1 = await gameTest.grabFromFirstPin();
      await gameTest.dropDiskInSecondPin(step1.diskGrabbed);
      step2 = await gameTest.grabFromFirstPin();
      await gameTest.dropDiskInThirdPin(step2.diskGrabbed);
      expect(gameTest.grabFromFirstPin(), throwsStateError);
    });

    test('When drops disk two times, then counts two moves', () async {
      var gameTest = Game();

      Progress step1;
      Progress step2;
      Progress step3;

      await gameTest.start(3);

      step1 = await gameTest.grabFromFirstPin();
      await gameTest.dropDiskInThirdPin(step1.diskGrabbed);

      step2 = await gameTest.grabFromFirstPin();
      step3 = await gameTest.dropDiskInSecondPin(step2.diskGrabbed);

      assert(step3.moves == 2);
    });

    test('When game is not completed then the score is zero', () async {
      var gameTest = Game();

      Progress step1;
      Progress step2;
      Progress step3;

      await gameTest.start(3);

      step1 = await gameTest.grabFromFirstPin();
      await gameTest.dropDiskInThirdPin(step1.diskGrabbed);

      step2 = await gameTest.grabFromFirstPin();
      step3 = await gameTest.dropDiskInSecondPin(step2.diskGrabbed);
      assert(step3.score() == 0);
    });

    test('Flags game is over in progress only after game is over', () async {
      var gameTest = Game();

      Progress runningGame;
      Progress progressGameOver;
      Progress step1;
      Progress step2;
      Progress step3;

      await gameTest.start(2);

      step1 = await gameTest.grabFromFirstPin();
      runningGame = await gameTest.dropDiskInSecondPin(step1.diskGrabbed);
      assert(runningGame.isGameOver == false);

      step2 = await gameTest.grabFromFirstPin();
      runningGame = await gameTest.dropDiskInThirdPin(step2.diskGrabbed);
      assert(runningGame.isGameOver == false);

      step3 = await gameTest.grabFromSecondPin();
      progressGameOver = await gameTest.dropDiskInThirdPin(step3.diskGrabbed);
      assert(progressGameOver.isGameOver);
    });

    test('When plays perfect game then the score is 100%', () async {
      var gameTest = Game();

      Progress step1;
      Progress step2;
      Progress step3;

      Progress endGame;

      await gameTest.start(3);

      step1 = await gameTest.grabFromFirstPin();
      await gameTest.dropDiskInThirdPin(step1.diskGrabbed);
      step2 = await gameTest.grabFromFirstPin();
      await gameTest.dropDiskInSecondPin(step2.diskGrabbed);
      step1 = await gameTest.grabFromThirdPin();
      await gameTest.dropDiskInSecondPin(step1.diskGrabbed);
      step3 = await gameTest.grabFromFirstPin();
      await gameTest.dropDiskInThirdPin(step3.diskGrabbed);
      step1 = await gameTest.grabFromSecondPin();
      await gameTest.dropDiskInFirstPin(step1.diskGrabbed);
      step2 = await gameTest.grabFromSecondPin();
      await gameTest.dropDiskInThirdPin(step2.diskGrabbed);
      step1 = await gameTest.grabFromFirstPin();
      endGame = await gameTest.dropDiskInThirdPin(step1.diskGrabbed);

      assert(endGame.score() == 1);
    });

    test('When play is not perfect game then the score is less than 100%, but greater than zero', () async {
      var movesRequired = (int disks) => pow(2, disks) - 1;
      var gameTest = Game();

      Progress step1;
      Progress step2;

      Progress endGame;

      await gameTest.start(2);

      step1 = await gameTest.grabFromFirstPin();
      await gameTest.dropDiskInThirdPin(step1.diskGrabbed);

      step2 = await gameTest.grabFromFirstPin();
      await gameTest.dropDiskInSecondPin(step2.diskGrabbed);

      step1 = await gameTest.grabFromThirdPin();
      await gameTest.dropDiskInFirstPin(step1.diskGrabbed);

      step2 = await gameTest.grabFromSecondPin();
      await gameTest.dropDiskInThirdPin(step2.diskGrabbed);

      step1 = await gameTest.grabFromFirstPin();
      endGame = await gameTest.dropDiskInThirdPin(step1.diskGrabbed);

      assert(endGame.score() == movesRequired(2) / 5);
    });

    test('When start the game with 3 disks, must have 3 disks in first pin and zero in the others', () async {
      var gameTest = Game();

      var gameStart = await gameTest.start(3);
      assert(gameStart.disksFirstPin().disks.length == 3);
      assert(gameStart.disksSecondPin().disks.isEmpty);
      assert(gameStart.disksThirdPin().disks.isEmpty);
    });


    test('When move from 1st to 2nd pin, must have 2 disks in 1st pin, one in 2nd and 3rd is empty', () async {
      var gameTest = Game();

      await gameTest.start(3);
      var step1 = await gameTest.grabFromFirstPin();
      var step2 = await gameTest.dropDiskInSecondPin(step1.diskGrabbed);
      assert(step2.disksFirstPin().disks.length == 2);
      assert(step2.disksSecondPin().disks.length == 1);
      assert(step2.disksThirdPin().disks.isEmpty);
    });

    test('When move from 1st to 2nd pin, and move from 1st to 3rd, each pin must have 1 disk', () async {
      var gameTest = Game();

      await gameTest.start(3);
      var step1 = await gameTest.grabFromFirstPin();
      await gameTest.dropDiskInSecondPin(step1.diskGrabbed);
      var step3 = await gameTest.grabFromFirstPin();
      var step4 = await gameTest.dropDiskInThirdPin(step3.diskGrabbed);

      assert(step4.disksFirstPin().disks.length == 1);
      assert(step4.disksSecondPin().disks.length == 1);
      assert(step4.disksThirdPin().disks.length == 1);
    });

    test('When starting two different games with same disk totals, then progresses are equal', () async {
      var game1 = Game();
      var game2 = Game();

      var progress1 = await game1.start(3);
      var progress2 = await game2.start(3);

      expect(progress1, progress2);
    });

    test('When starting two different games with different disk totals, then progresses are equal', () async {
      var game1 = Game();
      var game2 = Game();

      var progress1 = await game1.start(3);
      var progress2 = await game2.start(4);

      expect(progress1, isNot(progress2));
    });
  });
}