#include <stdlib.h>

#include "arena.h"
#include "raylib.h"
#include "utils.h"
#include "physics.h"

extern BOOL isDebug;

static void SetProperties(PWorld *w, Vector2 gravity);

PWorld *InitPWorld(Vector2 gravity) {
    PWorld *w = malloc(sizeof(PWorld));

    SetProperties(w, gravity);

    return w;
}

PWorld *InitPWorldOnArena(Arena *a, Vector2 gravity) {
    PWorld *w = ArenaAlloc(a, sizeof(PWorld));

    SetProperties(w, gravity);

    return w;
}

Collider *InitColliderInWorld(PWorld *w, Vector2 pos, float width, float height,
                              ColliderType type, float mass) {
    if (w->topCollider == w->maxCollidersCapacity) {
        TODO("PWorld CAN'T EXPAND OR REUSE ITS SPACE, THIS FEATURE NOT YET IMPLEMENTED!");
    }

    Collider *c = ArenaAlloc(w->arena, sizeof(Collider));
    c->pos = pos;
    c->width = width;
    c->height = height;
    c->type = type;
    c->mass = mass;

    w->colliders[w->topCollider++] = c;

    return c;
}

void UpdatePWorld(PWorld *w, float dt) {
    for (int i = 0; i < w->topCollider; i++) {
        Collider *lhs = w->colliders[i];

        if (lhs->type == ColliderTypeStatic)
            continue;

        for (int j = 0; j < w->topCollider; j++) {
            if (i == j)
                continue;

            Collider *rhs = w->colliders[j];
            BOOL pass = NO;

            for (int ruleIndex = 0; ruleIndex < w->topRule; ruleIndex++) {
                CollisionRule *rule = w->rules[ruleIndex];


                pass = !rule(lhs, rhs);
            }

            BOOL collided = CheckCollision(lhs, rhs);

            if (!collided || pass)
                continue;

            CollisionSide side = GetCollisionSide(collided, lhs, rhs);

            switch (side) {
                case CollisionSideBottom:
                    INFO("Got bottom collision");
                    break;
                case CollisionSideTop:
                    INFO("Got top collision");
                    break;
                case CollisionSideLeft:
                    INFO("Got left collision");
                    break;
                case CollisionSideRight:
                    INFO("Got right collision");
                    break;
            }

            for (int actionIndex = 0; actionIndex < w->topAction; actionIndex++) {
                CollisionAction *action = w->actions[actionIndex];

                action(lhs, rhs, side);
            }
        }

        lhs->force =
            Vector2Add(lhs->force, Vector2Scale(w->gravity, lhs->mass));

        Vector2 a = {
            .x = lhs->force.x / lhs->mass,
            .y = lhs->force.y / lhs->mass,
        };

        lhs->vel = Vector2Add(lhs->vel, Vector2Scale(a, dt));
        lhs->pos = Vector2Add(lhs->pos, Vector2Scale(lhs->vel, dt));

        lhs->force.x = 0;
        lhs->force.y = 0;
    }
}

void SetCollisionRule(PWorld *w, CollisionRule *rule) {
    w->rules[w->topRule++] = rule;
}

void SetCollisionAction(PWorld *w, CollisionAction *action) {
    w->actions[w->topAction++] = action;
}

void DrawPWorld(PWorld *w) {
    if (!isDebug) return;

    for (int i = 0; i < w->topCollider; i++) {
        Collider *c = w->colliders[i];

        DrawRectangleLines(c->pos.x, c->pos.y, c->width, c->height, RED);
    }
}

void DeinitPWorld(PWorld *w) {
    DeinitArena(w->arena);
    free(w);
}

void DeinitPWorldOnArena(PWorld *w) {
    DeinitArena(w->arena);
}

// Private methods

static void SetProperties(PWorld *w, Vector2 gravity) {
    w->gravity = gravity;
    w->topCollider = 0;
    w->topRule = 0;
    w->topAction = 0;
    w->maxCollidersCapacity = 50;
    w->arena = malloc(sizeof(Arena));

    InitArena(w->arena);

    w->colliders =
        ArenaAlloc(w->arena, sizeof(Collider *) * w->maxCollidersCapacity);
}
