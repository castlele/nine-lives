#ifndef TILEDMAP_H_
#define TILEDMAP_H_

#include <raylib.h>
#include "cute_tiled.h"
#include "sprite.h"

#define MAX_SPRITES 1000

typedef enum TiledLayerType {
    UNKNOWN,
    OBJECT_GROUP,
    IMAGE_LAYER,
    TILE_LAYER,
} TiledLayerType;

typedef void(ObjectParser)(cute_tiled_object_t *object);

typedef struct TiledMap {
    cute_tiled_map_t *internal;
    ObjectParser *objectParser;
    Vector2 spawn;
    float scale;
    // TODO: Make heap allocation?
    Sprite sprites[MAX_SPRITES];
    int headSprite;
} TiledMap;

void InitMap(
    TiledMap *map,
    float scale,
    const char *mapPath,
    const char *resPath
);
void DeinitMap(TiledMap *map);
void DrawMap(TiledMap *map);
void DrawMapFrom(TiledMap *map, int fromIndex, int toIndex);

#endif
