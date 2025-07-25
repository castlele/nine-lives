#include <raylib.h>

#include "screen.h"

#if defined(PLATFORM_WEB)
#include <emscripten/emscripten.h>
#endif

#define DEFAULT_WIN_W 800
#define DEFAULT_WIN_H 600
#define WIN_NAME "Template Project"

BOOL isDebug = NO;

static void UpdateDrawFrame();
static void Update();
static void Draw();

static void InitScreen(ScreenType);
static void DeinitScreen(ScreenType);
static void UpdateScreen(ScreenType, float dt);
static void ListenCommonEvents();
static void DrawScreen(ScreenType);

static void NavigationStarted(ScreenType from, ScreenType to);
static void NavigationFinished(ScreenType from, ScreenType to);

static ScreenType currentScreen = MAIN;

int main() {
    InitWindow(DEFAULT_WIN_W, DEFAULT_WIN_H, WIN_NAME);

    InitScreen(currentScreen);

#if defined(PLATFORM_WEB)
    emscripten_set_main_loop(UpdateDrawFrame, 0, 1);
#else
    SetTargetFPS(60);

    while (!WindowShouldClose()) {
        UpdateDrawFrame();
    }
#endif

    DeinitScreen(currentScreen);

    CloseWindow();

    return 0;
}

static void UpdateDrawFrame() {
    Update();
    Draw();
}

static void Update() {
    float dt = GetFrameTime();

    UpdateScreen(currentScreen, dt);
}

static void Draw() {
    ClearBackground(RAYWHITE);

    BeginDrawing();
        DrawScreen(currentScreen);
    EndDrawing();
}

static void InitScreen(ScreenType screen) {
    switch (screen) {
        case NONE:
            break;
        case MAIN:
            InitMainScreen();
            break;
        case SETTINGS:
            InitSettingsScreen();
            break;
        case GAME:
            InitGameScreen();
            break;
#if defined (DEBUG)
        case POC:
            InitPocScreen();
            break;
#endif
    }
}

static void DeinitScreen(ScreenType screen) {
    switch (screen) {
        case NONE:
            break;
        case MAIN:
            DeinitMainScreen();
            break;
        case SETTINGS:
            DeinitSettingsScreen();
            break;
        case GAME:
            DeinitGameScreen();
            break;
#if defined (DEBUG)
        case POC:
            DeinitPocScreen();
            break;
#endif
    }
}

static void UpdateScreen(ScreenType screen, float dt) {
    ListenCommonEvents();

    if (IsInTransition()) {
        UpdateTransition();
        return;
    }

    switch (screen) {
        case NONE:
            break;
        case MAIN:
            UpdateMainScreen(dt);

            if (IsMainFinished()) {
                ScreenType to = MainNavigateToScreen();

                NavigateToScreen(MAIN, to, FADEIN_FADEOUT, NavigationStarted,
                                 NavigationFinished);
            }
            break;
        case SETTINGS:
            UpdateSettingsScreen();

            if (IsSettingsFinished()) {
                ScreenType to = SettingsNavigateToScreen();

                NavigateToScreen(SETTINGS, to, FADEIN_FADEOUT, NavigationStarted,
                                 NavigationFinished);
            }
            break;
        case GAME:
            UpdateGameScreen(dt);

            if (IsGameFinished()) {
                ScreenType to = PocNavigateToScreen();

                NavigateToScreen(
                    GAME,
                    to,
                    FADEIN_FADEOUT,
                    NavigationStarted,
                    NavigationFinished
                );
            }
#if defined (DEBUG)
        case POC:
            UpdatePocScreen(dt);

            if (IsPocFinished()) {
                ScreenType to = PocNavigateToScreen();

                NavigateToScreen(POC, to, FADEIN_FADEOUT, NavigationStarted,
                                 NavigationFinished);
            }
#endif
    }
}

static void ListenCommonEvents() {
#if defined (DEBUG)
    if (IsKeyPressed(KEY_B)) {
        isDebug = !isDebug;
    }
#endif
}

static void DrawScreen(ScreenType screen) {
    switch (screen) {
        case NONE:
            break;
        case MAIN:
            DrawMainScreen();
            break;
        case SETTINGS:
            DrawSettingsScreen();
            break;
        case GAME:
            DrawGameScreen();
            break;
#if defined (DEBUG)
        case POC:
            DrawPocScreen();
            break;
#endif
    }

    if (IsInTransition()) {
        DrawTransition();
    }
}

static void NavigationStarted(ScreenType from, ScreenType to) {
    currentScreen = to;
    InitScreen(to);
}

static void NavigationFinished(ScreenType from, ScreenType to) {
    DeinitScreen(from);
}
