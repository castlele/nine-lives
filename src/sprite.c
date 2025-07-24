#include "sprite.h"
#include "raylib.h"
#include "types.h"

extern BOOL isDebug;

void DeinitSprite(Sprite *sprite) {
    UnloadTexture(sprite->texture);
}

void DrawSprite(Sprite *sprite) {
    Rectangle src = {
        .x = 0,
        .y = 0,
        .width = sprite->texture.width,
        .height = sprite->texture.height,
    };
    Rectangle dest = src;
    dest.x = sprite->pos.x;
    dest.y = sprite->pos.y;

    DrawTexturePro(
        sprite->texture,
        src,
        dest,
        sprite->origin,
        0.0f,
        WHITE
    );

    if (isDebug) {
        DrawRectangleLines(
            dest.x - sprite->origin.x,
            dest.y - sprite->origin.y,
            dest.width,
            dest.height,
            WHITE
        );
    }
}
