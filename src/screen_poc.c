#include <raylib.h>
#include <stdio.h>

#define CUTE_TILED_IMPLEMENTATION

#include "cute_tiled.h"

#include "screen.h"
#include "player.h"

#define MAP_TILE_JSON_PATH "./res/level_1.tmj"
#define MAP_TILES "./res/level_1.png"

#if defined(PLATFORM_DESKTOP)
#define POST_PROCCESSOR_SHADER_PATH "res/shaders/glsl330/post_processing.fs"
#else
#define POST_PROCCESSOR_SHADER_PATH "res/shaders/glsl100/post_processing.fs"
#endif

static void GetMapTextures();
static void DrawMap();

typedef struct Sprite {
    int x;
    int y;
    int w;
    int h;
} Sprite;

static cute_tiled_map_t *map;
static Texture2D bgTexture;
static Sprite *sprites;
static int count;
static Player player;
static Shader postProcessingShader;
static Camera2D camera = {0};

void InitPocScreen() {
    bgTexture = LoadTexture(MAP_TILES);
    map = cute_tiled_load_map_from_file(MAP_TILE_JSON_PATH, 0);

    GetMapTextures();

    postProcessingShader = LoadShader(NULL, POST_PROCCESSOR_SHADER_PATH);

    Vector2 initialPos = {
        .x = (GetScreenWidth() - player.texture.width) / 2.0f,
        .y = GetScreenHeight() - player.texture.height,
    };
    InitPlayer(&player, initialPos);

    camera.rotation = 0.0f;
    camera.zoom = 1.3f;
}

void DeinitPocScreen() {
    cute_tiled_free_map(map);
    UnloadTexture(bgTexture);
    DeinitPlayer(&player);
    UnloadShader(postProcessingShader);
}

void UpdatePocScreen(float dt) {
    UpdatePlayer(&player, dt);
    camera.target = (Vector2){ player.pos.x, player.pos.y };

    camera.offset = (Vector2){ GetScreenWidth() / 2.0f, GetScreenHeight() / 2.0f };
}

void DrawPocScreen() {
    BeginMode2D(camera);
        // BeginShaderMode(postProcessingShader);
            DrawMap();
            // DrawTexture(bgTexture, 0, 0, WHITE);
            DrawPlayer(&player);
        // EndShaderMode();
    EndMode2D();
}

BOOL IsPocFinished() {
    return NO;
}

ScreenType PocNavigateToScreen() {
    return NONE;
}

// Private methods

void GetMapTextures() {
    int w = map->width;
    int h = map->height;

    cute_tiled_layer_t *layer = map->layers;

    sprites = malloc(sizeof(Sprite) * w * h);
    count = layer->data_count;

    while (layer) {
        for (int i = 0; i < layer->data_count; i++) {
            sprites[i] = (Sprite) {
                .x = (i % w),
                .y = (h - i / w),
                .w = 32,
                .h = 32,
            };
        }

        layer = layer->next;
    }
}

void DrawMap() {
    cute_tiled_layer_t* layer = map->layers;
    cute_tiled_tileset_t* tileset = map->tilesets;

    int tilesetTileWidth = tileset->imagewidth;
    int tilesetTileHeight = tileset->imageheight;
    int tilesPerRow = bgTexture.width / tilesetTileWidth;

    while (layer) {
        for (int y = 0; y < layer->height; y++) {
            for (int x = 0; x < layer->width; x++) {
                int index = y * layer->width + x;
                int gid = layer->data[index];

                if (gid == 0) continue; // Empty tile

                int localID = gid - tileset->firstgid;

                int srcX = (localID % tilesPerRow) * tilesetTileWidth;
                int srcY = (localID / tilesPerRow) * tilesetTileHeight;

                Rectangle src = {
                    .x = (float)srcX,
                    .y = (float)srcY,
                    .width = (float)tilesetTileWidth,
                    .height = (float)tilesetTileHeight
                };
                float scale = 2;
                int drawTileWidth = 32;
                int drawTileHeight = 32;

                Rectangle dest = {
                    .x = x * drawTileWidth * scale,
                    .y = y * drawTileHeight * scale,
                    .width = drawTileWidth * scale,
                    .height = drawTileHeight * scale
                };

                DrawTexturePro(bgTexture, src, dest, (Vector2){0, 0}, 0.0f, WHITE);
            }
        }

        layer = layer->next;
    }
}
