#ifndef PLAYER_H_
#define PLAYER_H_

#include <raylib.h>
#include "physics.h"

#define PLAYER_TEXTURE_PATH "res/cat.png"
#define PLAYER_SPEED 250
#define ANIM_TIME 0.18

#define COLS 4.0f
#define ROWS 3.0f

typedef enum PlayerState {
    PlayerStateStandingLeft,
    PlayerStateStandingTop,
    PlayerStateStandingRight,
    PlayerStateStandingBottom,

    PlayerStateMovingRight,
    PlayerStateMovingTop,
    PlayerStateMovingLeft,
    PlayerStateMovingBottom,
} PlayerState;

int StateGetColumn(PlayerState state);

typedef struct Player {
    Texture2D texture;
    Vector2 pos;
    PlayerState state;
    Camera2D *camera;
    Collider *collider;
} Player;

void InitPlayer(Player *player, Vector2 pos, float scale);
void DeinitPlayer(Player *player);

int PlayerGetWidth(Player *player);
int PlayerGetHeight(Player *player);
void AttachCameraToPlayer(Player *player, Camera2D *camera);

void UpdatePlayer(Player *player, float dt);
void DrawPlayer(Player *player);

#endif // PLAYER_H_
