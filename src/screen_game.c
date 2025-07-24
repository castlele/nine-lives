#include "raylib.h"
#include "screen.h"
#include "levels.h"
#include "types.h"

extern BOOL isDebug;

static void ListenEvents();
static void ReloadLevel();

static void InitLevel(Level type);
static void DeinitLevel(Level type);
static void UpdateLevel(Level type, float dt);
static void DrawLevel(Level type);

static Level currentLevel = FIRST;

void InitGameScreen() {
    InitLevel(currentLevel);
}

void DeinitGameScreen() {
    DeinitLevel(currentLevel);
}

void UpdateGameScreen(float dt) {
    ListenEvents();

    UpdateLevel(currentLevel, dt);
}

void DrawGameScreen() {
    DrawLevel(currentLevel);
}

BOOL IsGameFinished() {
    return NO;
}

ScreenType GameNavigateToScreen() {
    return NONE;
}

// Private functions

static void ListenEvents() {
    if (isDebug) {
        if (IsKeyDown(KEY_LEFT_SHIFT) && IsKeyPressed(KEY_R)) {
            ReloadLevel();
        }
    }
}

static void ReloadLevel() {
    DeinitLevel(currentLevel);
    InitLevel(currentLevel);
}

static void InitLevel(Level type) {
    switch (type) {
        case FIRST:
            InitFirstLevel();
            break;
    }
}

static void DeinitLevel(Level type) {
    switch (type) {
        case FIRST:
            DeinitFirstLevel();
            break;
    }
}

static void UpdateLevel(Level type, float dt) {
    switch (type) {
        case FIRST:
            UpdateFirstLevel(dt);
            break;
    }
}

static void DrawLevel(Level type) {
    switch (type) {
        case FIRST:
            DrawFirstLevel();
            break;
    }
}

