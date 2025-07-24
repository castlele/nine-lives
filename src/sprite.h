#ifndef SPRITE_H_
#define SPRITE_H_

#include <raylib.h>

typedef struct Sprite {
    Texture2D texture;
    Vector2 pos;
    Vector2 origin;
} Sprite;

void DeinitSprite(Sprite *sprite);

void DrawSprite(Sprite *sprite);

#endif
