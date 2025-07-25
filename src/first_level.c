#include "levels.h"
#include "player.h"
#include "raylib.h"
#include "types.h"
#include "tiledmap.h"
#include "physics.h"
#include "utils.h"

#define FIRST_LEVEL_MAP_PATH "./res/level_1/map_level_1.json"
#define RES_PATH "./res/level_1"
#define LEVEL_SCALE 1.0f

extern BOOL isDebug;

static void ResolveCollision(Collider *lhs, Collider *rhs, CollisionSide side);
static void ParseObject(cute_tiled_object_t *object);

static PWorld *world;
static TiledMap map;
static Player player;
static Camera2D camera = {0};

void InitFirstLevel() {
    world = InitPWorld((Vector2) {0, 0});
    SetCollisionAction(world, ResolveCollision);

    map.objectParser = ParseObject;
    InitMap(&map, LEVEL_SCALE, FIRST_LEVEL_MAP_PATH, RES_PATH);

    InitPlayer(&player, map.spawn, map.scale);

    AttachCameraToPlayer(&player, &camera);
    camera.rotation = 0.0f;
    camera.zoom = LEVEL_SCALE;

    player.collider = InitColliderInWorld(
        world,
        player.pos,
        PlayerGetWidth(&player),
        PlayerGetHeight(&player),
        ColliderTypeDynamic,
        10
    );

    SetColliderMask(player.collider, "player");
}

void DeinitFirstLevel() {
    DeinitMap(&map);
    DeinitPlayer(&player);
    DeinitPWorld(world);
    world = NULL;
}

void UpdateFirstLevel(float dt) {
    UpdatePWorld(world, dt);
    UpdatePlayer(&player, dt);

    if (isDebug) {
        if (IsKeyDown(KEY_LEFT_SHIFT) && IsKeyPressed(KEY_EQUAL)) {
            camera.zoom += 0.1f;
        }

        if (IsKeyPressed(KEY_MINUS)) {
            camera.zoom -= 0.1f;
        }

        if (IsKeyPressed(KEY_EQUAL)) {
            camera.zoom = 1.0f;
        }
    }
}

void DrawFirstLevel() {
    BeginMode2D(camera);
        DrawMapFrom(&map, 0, 1);
        DrawPlayer(&player);
        DrawMapFrom(&map, 1, map.headSprite);

        DrawPWorld(world);
    EndMode2D();
}

// Private functions

static void ResolveCollision(
    Collider *lhs,
    Collider *rhs,
    CollisionSide side
) {
    Collider *other;

    if (STR_EQUALS(lhs->mask, "player")) {
        other = rhs;
    } else if (STR_EQUALS(rhs->mask, "player")) {
        other = lhs;
    }

    switch (side) {
        case CollisionSideBottom:
            player.pos.y = other->pos.y - PlayerGetHeight(&player);
            break;
        case CollisionSideTop:
            player.pos.y = other->pos.y + other->height;
            break;
        case CollisionSideLeft:
            player.pos.x = other->pos.x + other->width;
            break;
        case CollisionSideRight:
            player.pos.x = other->pos.x - PlayerGetWidth(&player);
            break;
    }
}

static void ParseObject(cute_tiled_object_t *object) {
    if (STR_EQUALS(object->name.ptr, "collider")) {
        InitColliderInWorld(
            world,
            (Vector2) {
                .x = object->x * map.scale,
                .y = object->y * map.scale,
            },
            object->width * map.scale,
            object->height * map.scale,
            ColliderTypeStatic,
            0.0f
        );
    }
}
