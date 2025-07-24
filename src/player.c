#include <raylib.h>

#include "player.h"
#include "types.h"

extern BOOL isDebug;

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

    return 0;
}

void InitPlayer(Player *player, Vector2 pos, float scale) {
    Image img = LoadImage(PLAYER_TEXTURE_PATH);
    ImageResize(&img, img.width * scale, img.height * scale);

    player->texture = LoadTextureFromImage(img);

    UnloadImage(img);

    player->state = PlayerStateStandingRight;
    player->pos = pos;
}

void DeinitPlayer(Player *player) {
    UnloadTexture(player->texture);
}

int PlayerGetWidth(Player *player) {
    return player->texture.width / COLS;
}

int PlayerGetHeight(Player *player) {
    return player->texture.height / ROWS;
}

void AttachCameraToPlayer(Player *player, Camera2D *camera) {
    player->camera = camera;
}

void UpdatePlayer(Player *player, float dt) {
    BOOL isMoving = NO;
    PlayerState state;
    Collider *collider = player->collider;

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
        player->pos.y += PLAYER_SPEED * dt;
        isMoving = YES;
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

    if (player->camera) {
        player->camera->target = (Vector2){
            player->pos.x,
            player->pos.y,
        };
        player->camera->offset = (Vector2){ GetScreenWidth() / 2.0f, GetScreenHeight() / 2.0f };
    }

    if (collider) {
        collider->pos = player->pos;
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

    if (isDebug) {
        DrawRectangleLines(player->pos.x, player->pos.y, width, height, WHITE);
    }
}
