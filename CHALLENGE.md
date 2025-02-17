# Bowling Scoring Challenge

Build an application to track the score of a single game of bowling. The application will accept the result of each ball bowled and calculate the correct score, including spares and strikes. The application must also indicate if the 10th frame includes a third ball.

Results of each roll are input one at a time, sequentially. The application should assign the scores to the correct frames. The application should sanitize inputs to only allow valid scores to be entered at any given time. The score should be updated as the rolls are entered. *Do not* assume all rolls will be entered at once.

## Example

Input: Strike, 7, Spare, 9, Miss, Strike, Miss, 8, 8, Spare, Miss, 6, Strike, Strike, Strike, 8, 1

| Frame |  1 | 2  | 3  | 4  | 5  | 6  | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| Input| X  |  7 / |  9 - | X  | - 8  |  8 / |  - 6 |  X | X  |  X 8 1 |
|Score|  20 | 39  |  48 | 66  | 74  |  84 |  90 |  120 | 148  | 167  |

## Bowling Game

* A game of bowling consists of 10 frames. Two balls are rolled per frame in an attempt to knock down all ten pins.
* If all ten pins are knocked down in two turns in the 10th frame, an extra roll is awarded.
* A **strike** is defined as knocking down all ten pins in the first roll of a frame. It's indicated with an `X`.
* A **spare** is defined as knocking down all the remaining pins in the second roll of a frame. It's indicated with a `/`.
* A **miss** is defined as zero pins being knocked down on a roll. It's indicated with a `-`.

## Scoring Rules

* Generally, 1 point is awarded per pin knocked down.
* A **strike** scores 10 points (for knocking down all ten pins), plus the total of the next two rolls.
* A **spare** scores 10 points, plus the total number of pins knocked down on the next roll only.
* Each frame displays the cumulative score up to that point for all completed frames. If a frame has a strike or spare, the score for that frame is not displayed until sufficient subsequent rolls have been recorded.

## Milestones

### Milestone 1 - Data Model

- A fully implemented and unit-tested data model for the above.
- Should include well-encapsulated interfaces for all classes, properties, and methods of the model layer.

### Milestone 2 - Business Logic

- Implementation of the business logic, which includes maintaining the state of a game in progress, keeping track of the current frame, calculating the score, and stepping through the game one roll at a time.
- Unit tests for core logic. (100% code coverage isn't necessary, but we'd like to see the most common scenarios tested.)
- The functionality can be demonstrated with hard-coded data or use a basic interface to allow rolls to be entered.

### Milestone 3 (OPTIONAL) - Front-end layer / views

- Implement a front end UI, using any architecture and technologies you prefer.
- It should have an interface to enter in scores and a live updating scoreboard that correctly indicates the current score, the current frame, and how many rolls remain in the current frame.
- The game does not have to be stored between runs of the app or saved in any way.

## What we're looking for

Here are some things we will be looking for when assessing your implementation:

1) Your code runs.
2) Your code includes unit tests.
3) Your score calculation is able to handle a variety of games.
