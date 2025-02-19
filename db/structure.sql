CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "games" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "completed" boolean, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "frames" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "game_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "completed" boolean NOT NULL, "frame_number" integer NOT NULL, "score" integer NOT NULL, "type" varchar NOT NULL, "carry_over_rolls" integer /*application='BowlingScorekeeper'*/, CONSTRAINT "fk_rails_ee0b37ac02"
FOREIGN KEY ("game_id")
  REFERENCES "games" ("id")
);
CREATE INDEX "index_frames_on_game_id" ON "frames" ("game_id") /*application='BowlingScorekeeper'*/;
CREATE TABLE IF NOT EXISTS "rolls" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "frame_id" integer NOT NULL, "pins" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_f09717ac94"
FOREIGN KEY ("frame_id")
  REFERENCES "frames" ("id")
);
CREATE INDEX "index_rolls_on_frame_id" ON "rolls" ("frame_id") /*application='BowlingScorekeeper'*/;
INSERT INTO "schema_migrations" (version) VALUES
('20250219030855'),
('20250217214702'),
('20250217214656'),
('20250217214649');

