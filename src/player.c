#include <raylib.h>

#include "player.h"
#include "types.h"

#define PLAYER_TEXTURE_PATH "res/cat.png"
#define PLAYER_SPEED 200
#define ANIM_TIME 0.18

#define COLS 3.0f
#define ROWS 3.0f

static unsigned int movingFrame = 0;
static float time;

void InitPlayer(Player *player, Vector2 pos) {
    player->texture = LoadTexture(PLAYER_TEXTURE_PATH);
    player->pos = pos;
    player->state = PlayerStateStandingRight;
}

void DeinitPlayer(Player *player) {
    UnloadTexture(player->texture);
}

void UpdatePlayer(Player *player, float dt) {
    BOOL isMoving = NO;
    PlayerState state;

    if (IsKeyDown(KEY_D)) {
        player->pos.x += PLAYER_SPEED * dt;
        isMoving = YES;
        state = PlayerStateMovingRight;
    }

    if (IsKeyDown(KEY_A)) {
        player->pos.x -= PLAYER_SPEED * dt;
        isMoving = YES;
        state = PlayerStateMovingLeft;
    }

    if (IsKeyDown(KEY_W)) {
        player->pos.y -= PLAYER_SPEED * dt;
        isMoving = YES;
        state = PlayerStateMovingTop;
    }

    if (IsKeyDown(KEY_S)) {
        isMoving = YES;
        player->pos.y += PLAYER_SPEED * dt;
    }

    if (isMoving) {
        if (player->state == state) {
            if (GetTime() - time >= ANIM_TIME) {
                movingFrame++;
                movingFrame %= (int)ROWS;
                time = GetTime();
            }

        } else {
            time = GetTime();
            movingFrame = 0;
        }

        player->state = state;
    } else {
        switch (player->state) {
        case PlayerStateStandingLeft:
        case PlayerStateMovingLeft:
            player->state = PlayerStateStandingLeft;
            break;
        case PlayerStateStandingRight:
        case PlayerStateMovingRight:
            player->state = PlayerStateStandingRight;
            break;
        case PlayerStateStandingTop:
        case PlayerStateMovingTop:
            player->state = PlayerStateStandingTop;
            break;
        }
    }
}

void DrawPlayer(Player *player) {
    float x;
    float y;
    float width;
    float height;

    switch (player->state) {
        case PlayerStateStandingTop:
            x = player->texture.width - player->texture.width / COLS;
            y = 0;
            width = player->texture.width / COLS;
            height = player->texture.height / ROWS;
            break;
        case PlayerStateStandingLeft:
            x = player->texture.width / COLS;
            y = 0;
            width = player->texture.width / COLS;
            height = player->texture.height / ROWS;
            break;
        case PlayerStateStandingRight:
            x = 0;
            y = 0;
            width = player->texture.width / COLS;
            height = player->texture.height / ROWS;
            break;
        case PlayerStateMovingLeft:
            x = player->texture.width / COLS;
            y = (movingFrame * player->texture.height) / ROWS;
            width = player->texture.width / COLS;
            height = player->texture.height / ROWS;
            break;
        case PlayerStateMovingRight:
            x = 0;
            y = (movingFrame * player->texture.height) / 3.0f;
            width = player->texture.width / COLS;
            height = player->texture.height / 3.0f;
            break;
        case PlayerStateMovingTop:
            x = player->texture.width - player->texture.width / COLS;
            y = (movingFrame * player->texture.height) / ROWS;
            width = player->texture.width / COLS;
            height = player->texture.height / 3.0f;
            break;
    }

    DrawTextureRec(
        player->texture,
        (Rectangle){x, y, width, height},
        player->pos,
        WHITE
    );
}
