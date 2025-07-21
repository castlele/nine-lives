#include <raylib.h>
#include <stdio.h>

#include "screen.h"

#define POC_BG_IMAGE_PATH "res/1_level.png"
#define PLAYER_IMAGE_PATH "res/cat.png"

#if defined(PLATFORM_DESKTOP)
#define POST_PROCCESSOR_SHADER_PATH "res/shaders/glsl330/post_processing.fs"
#else
#define POST_PROCCESSOR_SHADER_PATH "res/shaders/glsl100/post_processing.fs"
#endif

#define PLAYER_SPEED 150

typedef struct Player {
    Texture2D texture;
    Vector2 pos;
} Player;

static Texture2D bgTexture;
static Player player = {0};
static Shader postProcessingShader;
static Camera2D camera = {0};

void InitPocScreen() {
    Image bgImage = LoadImage(POC_BG_IMAGE_PATH);
    bgTexture = LoadTextureFromImage(bgImage);
    UnloadImage(bgImage);

    Image playerImage = LoadImage(PLAYER_IMAGE_PATH);
    ImageResize(&playerImage, 102, 69);
    player.texture = LoadTextureFromImage(playerImage);
    UnloadImage(playerImage);

    postProcessingShader = LoadShader(NULL, POST_PROCCESSOR_SHADER_PATH);

    player.pos.x = (GetScreenWidth() - player.texture.width) / 2.0f;
    player.pos.y = GetScreenHeight() - player.texture.height;

    camera.rotation = 0.0f;
    camera.zoom = 1.3f;
}

void DeinitPocScreen() {
    UnloadTexture(bgTexture);
    UnloadTexture(player.texture);
    UnloadShader(postProcessingShader);
}

void UpdatePocScreen(float dt) {
    if (IsKeyDown(KEY_D)) {
        player.pos.x += PLAYER_SPEED * dt;
    }

    if (IsKeyDown(KEY_A)) {
        player.pos.x -= PLAYER_SPEED * dt;
    }

    if (IsKeyDown(KEY_W)) {
        player.pos.y -= PLAYER_SPEED * dt;
    }

    if (IsKeyDown(KEY_S)) {
        player.pos.y += PLAYER_SPEED * dt;
    }

    camera.target = (Vector2){ player.pos.x, player.pos.y };

    camera.offset = (Vector2){ GetScreenWidth() / 2.0f, GetScreenHeight() / 2.0f };

    // printf("camera.offset: %f:::player.pos: %f\n", camera.offset.x, player.pos.x);

    // if (camera.offset.x - player.pos.x - player.texture.width / 2.0f <= 0) {
    //     camera.offset.x = 0;
    // }
}

void DrawPocScreen() {
    BeginMode2D(camera);
        BeginShaderMode(postProcessingShader);
            DrawTexture(bgTexture, 0, 0, WHITE);
            DrawTexture(
                player.texture,
                player.pos.x,
                player.pos.y,
                WHITE
            );
        EndShaderMode();
    EndMode2D();
}

BOOL IsPocFinished() {
    return NO;
}

ScreenType PocNavigateToScreen() {
    return NONE;
}
