#include <raylib.h>
#include <stdio.h>

#include "screen.h"
#include "player.h"

#define POC_BG_IMAGE_PATH "res/1_level.png"

#if defined(PLATFORM_DESKTOP)
#define POST_PROCCESSOR_SHADER_PATH "res/shaders/glsl330/post_processing.fs"
#else
#define POST_PROCCESSOR_SHADER_PATH "res/shaders/glsl100/post_processing.fs"
#endif

static Texture2D bgTexture;
static Player player;
static Shader postProcessingShader;
static Camera2D camera = {0};

void InitPocScreen() {
    Image bgImage = LoadImage(POC_BG_IMAGE_PATH);
    bgTexture = LoadTextureFromImage(bgImage);
    UnloadImage(bgImage);

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
    UnloadTexture(bgTexture);
    DeinitPlayer(&player);
    UnloadShader(postProcessingShader);
}

void UpdatePocScreen(float dt) {
    UpdatePlayer(&player, dt);
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
            DrawPlayer(&player);
        EndShaderMode();
    EndMode2D();
}

BOOL IsPocFinished() {
    return NO;
}

ScreenType PocNavigateToScreen() {
    return NONE;
}
