#include <raylib.h>

#include "player.h"
#include "types.h"

static unsigned int movingFrame = 0;
static float time;

int StateGetColumn(PlayerState state) {
    switch(state) {
    case PlayerStateStandingRight:
    case PlayerStateMovingRight:
        return 0;
    case PlayerStateStandingLeft:
    case PlayerStateMovingLeft:
        return 1;
    case PlayerStateStandingTop:
    case PlayerStateMovingTop:
        return 2;
    case PlayerStateStandingBottom:
    case PlayerStateMovingBottom:
        return 3;
    }
}

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
        isMoving = YES;
        player->pos.y -= PLAYER_SPEED * dt;
        state = PlayerStateMovingTop;
    }

    if (IsKeyDown(KEY_S)) {
        isMoving = YES;
        player->pos.y += PLAYER_SPEED * dt;
        state = PlayerStateMovingBottom;
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
        movingFrame = 0;

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
        case PlayerStateStandingBottom:
        case PlayerStateMovingBottom:
            player->state = PlayerStateStandingBottom;
            break;
        }
    }
}

void DrawPlayer(Player *player) {
    int currentCol = StateGetColumn(player->state);
    float x = (player->texture.width / COLS) * currentCol;
    float y = (movingFrame * player->texture.height) / ROWS;
    float width = player->texture.width / COLS;
    float height = player->texture.height / ROWS;

    DrawTextureRec(
        player->texture,
        (Rectangle){x, y, width, height},
        player->pos,
        WHITE
    );
}
