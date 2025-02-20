# Bowling Game API

This is a Ruby on Rails API for a bowling game, designed to track scores and handle game logic.

## Features

* Records rolls with scores represented as numbers, "X" for strikes, "/" for spares, and "-" for misses.
* Calculates scores accurately, including bonuses for strikes and spares.
* Handles the special rules of the 10th frame.
* Provides API endpoints for creating games and recording rolls.
* Returns the complete game object upon completion with the completion flags all set.
* Features the `Rolls::RecordEtAl` operation which is fairly large, and the main component of the logic regarding game
  state, frames, and rolls.
    * I had the intention of splitting this up into sub-operations and chaining them using `dry-monads` but ran out of
      time, needs some refactoring for sure!
* Serializers provide the serialized data from the controller.
* SimpleCov would be nice
* Some items could be dispatched as jobs / using async
* A large amount of effort went into trying to split things up and keep it relatively lean. Although there's areas that
  definitely need work it's a decent MVP.

-----

## Implementation Details

* **Rails:** The API is built using Ruby on Rails in API-only mode for a lightweight and efficient backend.
* **Dry::RB:**  Dry::Validation and Dry::Monads are used for schema validation, contract validation, and result
  handling, promoting code clarity and maintainability.
* **Docker:** The application is containerized using Docker for easy setup and deployment.
* **SQLite:** SQLite is used as the database for simplicity.

-----

## API Endpoints

### Create a Game

### Endpoint: POST /api/v1/games

> Description: Creates a new bowling game and initializes it with 10 frames.
**Status**: 201 Created  
**Body**: JSON representation of the created game, including its ID and associated frames.

**Example Request**:
> POST /api/v1/games HTTP/1.1

**Example Response:**
```json
{
  "id": 40,
  "completed": true,
  "current_frame": 10,
  "current_score": 275,
  "frames": [
    {
      "carry_over_rolls": 0,
      "completed": true,
      "frame_number": 1,
      "score": 30,
      "rolls": [
        {
          "id": 244,
          "frame_id": 391,
          "pins": 10,
          "created_at": "2025-02-19T23:29:04.494Z",
          "updated_at": "2025-02-19T23:29:04.494Z"
        }
      ]
    },
    {
      "carry_over_rolls": 0,
      "completed": true,
      "frame_number": 2,
      "score": 30,
      "rolls": [
        {
          "id": 245,
          "frame_id": 392,
          "pins": 10,
          "created_at": "2025-02-19T23:29:05.133Z",
          "updated_at": "2025-02-19T23:29:05.133Z"
        }
      ]
    },
    {
      ...
    },
    {
      ...
    },
    {
      "carry_over_rolls": 0,
      "completed": true,
      "frame_number": 10,
      "score": 20,
      "rolls": [
        {
          "id": 253,
          "frame_id": 400,
          "pins": 5,
          "created_at": "2025-02-19T23:29:15.098Z",
          "updated_at": "2025-02-19T23:29:15.098Z"
        },
        {
          "id": 254,
          "frame_id": 400,
          "pins": 5,
          "created_at": "2025-02-19T23:29:17.459Z",
          "updated_at": "2025-02-19T23:29:17.459Z"
        },
        {
          "id": 255,
          "frame_id": 400,
          "pins": 10,
          "created_at": "2025-02-19T23:29:25.373Z",
          "updated_at": "2025-02-19T23:29:25.373Z"
        }
      ]
    }
  ]
}
```

-----

### Record a Roll

### Endpoint: POST /api/v1/games/:id/roll

> Description: Records a roll for the specified game.

**Request Parameters:**
pins: The number of pins knocked down, represented as a number (0-10), "X" for a strike, "/" for a spare, or "-" for a
miss.

**Status**: 201 Created  
**Body**: JSON representation of the updated game state, including the updated frame and roll information.
**Acceptable Values**:
digits: 0 - 10
characters: 'X', '/', '-'

**Example Request**:
> POST /api/v1/games/1/roll HTTP/1.1  
> Content-Type: application/json

```json
{
  "pins": "5"
}
```

```json
{
  "pins": "X"
}
```

**Example Response:**
```json
{
  "id": 1,
  "created_at": "2023-10-27T12:00:00.000Z",
  "updated_at": "2023-10-27T12:01:00.000Z",
  "frames": [
    {
      "id": 1,
      "game_id": 1,
      "frame_number": 1,
      "score": 5,
      "type": "Frame",
      "rolls": [
        {
          "id": 1,
          "frame_id": 1,
          "pins": "5"
        }
      ]
    },
    {
      ...
    }
  ]
}
```

## Error Handling

#### Responses
The API returns appropriate error responses for invalid requests:
- **400 Bad Request**: Returned for invalid pin values or if the game is already completed.
- **404 Not Found**: Returned if the specified game does not exist.


#### Validation Rules

The RollContract enforces the following validation rules:
- The pins parameter must be a valid symbol ("X", "/", "-") or a number between 0 and 10.
- A spare ("/") cannot be recorded on the first roll of a frame.
- A strike ("X") cannot be recorded on the second roll of a frame (except for the 10th frame).
- The total score for a frame cannot exceed the maximum score (30).