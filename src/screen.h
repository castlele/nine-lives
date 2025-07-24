#ifndef SCREEN_H_
#define SCREEN_H_

#include "types.h"

typedef enum ScreenType {
    NONE = -1,
    MAIN = 0,
    SETTINGS,
    GAME,
#if defined (DEBUG)
    POC,
#endif
} ScreenType;

typedef enum NavigationType {
    FADEIN_FADEOUT,
} NavigationType;

typedef void(ScreensNavigationAction)(ScreenType from, ScreenType to);

void NavigateToScreen(ScreenType from, ScreenType to, NavigationType type,
                      ScreensNavigationAction *onStart,
                      ScreensNavigationAction *onFinish);
void UpdateTransition();
void DrawTransition();
BOOL IsInTransition();

void InitMainScreen();
void DeinitMainScreen();
void UpdateMainScreen(float dt);
void DrawMainScreen();
BOOL IsMainFinished();
ScreenType MainNavigateToScreen();

void InitSettingsScreen();
void DeinitSettingsScreen();
void UpdateSettingsScreen();
void DrawSettingsScreen();
BOOL IsSettingsFinished();
ScreenType SettingsNavigateToScreen();

#if defined (DEBUG)
void InitPocScreen();
void DeinitPocScreen();
void UpdatePocScreen(float dt);
void DrawPocScreen();
BOOL IsPocFinished();
ScreenType PocNavigateToScreen();
#endif

void InitGameScreen();
void DeinitGameScreen();
void UpdateGameScreen(float dt);
void DrawGameScreen();
BOOL IsGameFinished();
ScreenType GameNavigateToScreen();

#endif
