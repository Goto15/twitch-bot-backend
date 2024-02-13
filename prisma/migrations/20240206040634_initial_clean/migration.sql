-- CreateTable
CREATE TABLE "Token" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "token_name" TEXT NOT NULL,
    "token_type" TEXT,
    "access_token" TEXT NOT NULL,
    "refresh_token" TEXT,
    "scope" TEXT,
    "expires_in" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "GameRequest" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "game_id" TEXT NOT NULL,
    "requester_id" TEXT NOT NULL,
    "reward" TEXT NOT NULL,
    CONSTRAINT "GameRequest_requester_id_fkey" FOREIGN KEY ("requester_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Game" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "title" TEXT NOT NULL,
    "critic_score" INTEGER,
    "description" TEXT,
    "esrb_rating" TEXT,
    "release_date" DATETIME,
    "user_score" INTEGER,
    "length" INTEGER,
    "completed" BOOLEAN NOT NULL DEFAULT false,
    "blind" BOOLEAN NOT NULL DEFAULT true,
    "genres" TEXT,
    "completion_date" DATETIME,
    "status" TEXT DEFAULT 'Not Started',
    "review" TEXT,
    "custom_multiplier" INTEGER DEFAULT 1,
    "game_request_id" TEXT NOT NULL,
    CONSTRAINT "Game_game_request_id_fkey" FOREIGN KEY ("game_request_id") REFERENCES "GameRequest" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Genre" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "name" TEXT NOT NULL,
    "multiplier" INTEGER NOT NULL DEFAULT 1
);

-- CreateTable
CREATE TABLE "Reward" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "name" TEXT NOT NULL,
    "custom_reward_id" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "display_name" TEXT NOT NULL,
    "subscribed" BOOLEAN
);

-- CreateTable
CREATE TABLE "Vote" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "game_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    CONSTRAINT "Vote_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "Game" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Vote_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "Game_game_request_id_key" ON "Game"("game_request_id");

-- CreateIndex
CREATE UNIQUE INDEX "User_display_name_key" ON "User"("display_name");
