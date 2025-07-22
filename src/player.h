#ifndef PLAYER_H_
#define PLAYER_H_

#include <raylib.h>

typedef enum PlayerState {
    PlayerStateStandingLeft,
    PlayerStateStandingTop,
    PlayerStateStandingRight,

    PlayerStateMovingRight,
    PlayerStateMovingTop,
    PlayerStateMovingLeft,
} PlayerState;

typedef struct Player {
    Texture2D texture;
    Vector2 pos;
    PlayerState state;
} Player;

void InitPlayer(Player *player, Vector2 pos);
void DeinitPlayer(Player *player);

void UpdatePlayer(Player *player, float dt);
void DrawPlayer(Player *player);

#endif // PLAYER_H_
