#define CUTE_TILED_IMPLEMENTATION

#include <raylib.h>
#include <string.h>

#include "cute_tiled.h"
#include "tiledmap.h"
#include "utils.h"

#define LAYER_TYPE_OBJECTGROUP "objectgroup"
#define LAYER_TYPE_IMAGELAYER "imagelayer"
#define LAYER_TYPE_TILELAYER "tilelayer"

#define COMMON_OBJ_NAME_SPAWN "spawn"

static void ParseInternalMap(TiledMap *map);
static TiledLayerType GetLayerType(cute_tiled_layer_t *layer);
static void ParseObjects(TiledMap *map, cute_tiled_object_t *objects);
static void ParseImage(TiledMap *map, cute_tiled_layer_t *layer);
static void ParseTile(TiledMap *map, cute_tiled_layer_t *layer);

static char *resDir;

void InitMap(
    TiledMap *map,
    float scale,
    const char *mapPath,
    const char *resPath
) {
    resDir = malloc(sizeof(char) * strlen(resPath));
    strcpy(resDir, resPath);

    map->headSprite = 0;
    map->scale = scale;
    map->internal = cute_tiled_load_map_from_file(mapPath, 0);

    ParseInternalMap(map);
}

void DeinitMap(TiledMap *map) {
    cute_tiled_free_map(map->internal);

    for (int i = 0; i < map->headSprite; i++) {
        DeinitSprite(&map->sprites[i]);
    }

    free(resDir);
}

void DrawMap(TiledMap *map) {
    DrawMapFrom(map, 0, map->headSprite);
}

void DrawMapFrom(TiledMap *map, int fromIndex, int toIndex) {
    for (int i = fromIndex; i < toIndex; i++) {
        DrawSprite(&map->sprites[i]);
    }
}

// Private functions

static void ParseInternalMap(TiledMap *map) {
    INFO("Started parsing TiledMap");

    cute_tiled_layer_t *layer = map->internal->layers;

    if (!layer) {
        FATAL("NO LAYER FOUND ON MAP!");
    }

    for (; layer; layer = layer->next) {
        INFO("Parsing layer of type '%s': %s", layer->type.ptr,
             layer->name.ptr);
        TiledLayerType layerType = GetLayerType(layer);

        if (!layer->visible) {
            INFO("Layer is invisible, aborting...");
            continue;
        }

        switch (layerType) {
            case OBJECT_GROUP:
                ParseObjects(map, layer->objects);
                break;
            case IMAGE_LAYER:
                ParseImage(map, layer);
                break;
            case TILE_LAYER:
                ParseTile(map, layer);
                break;
            case UNKNOWN:
                INFO("Got unknown layer type");
                break;
        }
    }

    INFO("Finished parsing TiledMap");
}

static TiledLayerType GetLayerType(cute_tiled_layer_t *layer) {
    const char *layerType = layer->type.ptr;
    TiledLayerType type = UNKNOWN;

    if (STR_EQUALS(layerType, LAYER_TYPE_OBJECTGROUP)) {
        type = OBJECT_GROUP;
    }

    if (STR_EQUALS(layerType, LAYER_TYPE_IMAGELAYER)) {
        type = IMAGE_LAYER;
    }

    if (STR_EQUALS(layerType, LAYER_TYPE_TILELAYER)) {
        type = TILE_LAYER;
    }

    return type;
}

static void ParseObjects(TiledMap *map, cute_tiled_object_t *objects) {
    if (!objects) {
        WARN("No head found while parsing objects");
        return;
    }

    for (; objects; objects = objects->next) {
        INFO("Started parsing object %s", objects->name.ptr);

        if (STR_EQUALS(objects->name.ptr, COMMON_OBJ_NAME_SPAWN)) {
            map->spawn = (Vector2){
                .x = objects->x * map->scale,
                .y = objects->y * map->scale,
            };
        }

        if (map->objectParser) {
            map->objectParser(objects);
        }

        INFO("Finished parsing object");
    }
}

static void ParseImage(TiledMap *map, cute_tiled_layer_t *layer) {
    if (!layer) {
        WARN("Parsing image layer with NULL layer");
        return;
    }

    const char *imageName = layer->image.ptr;

    INFO("Started parsing image layer: %s", imageName);

    Image image = LoadImage(TextFormat("%s/%s", resDir, imageName));

    ImageResize(&image, image.width * map->scale, image.height * map->scale);

    Texture2D texture = LoadTextureFromImage(image);

    Sprite sprite = {
        .texture = texture,
        .origin = (Vector2) { 0 , 0 },
        .pos = (Vector2) {
            .x = (layer->x + layer->offsetx) * map->scale,
            .y = (layer->y + layer->offsety) * map->scale,
        },
    };

    map->sprites[map->headSprite++] = sprite;

    UnloadImage(image);

    INFO("FINISHED parsing image layer");
}

cute_tiled_tileset_t* FindTilesetForGID(cute_tiled_map_t* map, int gid) {
    cute_tiled_tileset_t* ts = map->tilesets;
    cute_tiled_tileset_t* next = ts ? ts->next : NULL;

    while (ts) {
        if (!next || gid < next->firstgid) {
            return ts;
        }
        ts = next;
        next = ts ? ts->next : NULL;
    }

    return NULL; // Should never happen if gid is valid
}

static void ParseTile(TiledMap *map, cute_tiled_layer_t *layer) {
    int tilesPerRow = map->internal->width; // * map->internal->tilewidth / tilesetTileWidth;

    for (int y = 0; y < layer->height; y++) {
        for (int x = 0; x < layer->width; x++) {
            int index = y * layer->width + x;
            int gid = layer->data[index];

            if (gid == 0) continue; // Empty tile

            cute_tiled_tileset_t *tileset = FindTilesetForGID(map->internal, gid);
            int tilesetTileWidth = tileset->tilewidth;
            int tilesetTileHeight = tileset->tileheight;

            int localID = gid - tileset->firstgid;
            int srcX = (localID % tilesPerRow) * tilesetTileWidth;
            int srcY = (localID / tilesPerRow) * tilesetTileHeight;

            Rectangle src = {
                .x = srcX,
                .y = srcY,
                .width = tilesetTileWidth,
                .height = tilesetTileHeight
            };

            Image image = LoadImage(TextFormat("%s/%s", resDir, tileset->image.ptr));

            ImageCrop(&image, src);
            ImageResize(&image, tilesetTileWidth * map->scale, tilesetTileHeight * map->scale);

            Texture2D texture = LoadTextureFromImage(image);

            Sprite sprite = {
                .texture = texture,
                .origin = (Vector2) {
                    .x = 0,
                    .y = texture.height - map->internal->tileheight * map->scale,
                },
                .pos = (Vector2) {
                    .x = x * map->internal->tilewidth * map->scale,
                    .y = y * map->internal->tileheight * map->scale,
                },
            };


            map->sprites[map->headSprite++] = sprite;

            UnloadImage(image);
        }
    }
}

