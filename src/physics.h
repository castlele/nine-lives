#ifndef PHYSICS_H_
#define PHYSICS_H_

#include <raylib.h>
#include <raymath.h>

#include "arena.h"
#include "types.h"

#define MAX_COLLIDES 1000
#define COLLIDER_MASK_SIZE 16
#define MAX_RULES 32
#define MAX_ACTIONS 16

typedef enum ColliderType {
    ColliderTypeStatic,
    ColliderTypeDynamic,
} ColliderType;

typedef enum CollisionSide {
    CollisionSideTop,
    CollisionSideBottom,
    CollisionSideLeft,
    CollisionSideRight,
} CollisionSide;

typedef struct Collider {
    Vector2 pos;
    Vector2 vel;
    Vector2 force;
    ColliderType type;
    char mask[COLLIDER_MASK_SIZE];
    float width;
    float height;
    float mass;
    BOOL active;
} Collider;

void SetColliderMask(Collider *c, char *mask);
BOOL CheckCollision(Collider *lhs, Collider *rhs);
CollisionSide GetCollisionSide(BOOL isCollided, Collider *lhs, Collider *rhs);

typedef BOOL(CollisionRule)(Collider *lhs, Collider *rhs);
typedef void(CollisionAction)(Collider *lhs, Collider *rhs, CollisionSide side);

typedef struct PWorld {
    Vector2 gravity;
    Collider **colliders;
    CollisionRule *rules[MAX_RULES];
    CollisionAction *actions[MAX_ACTIONS];
    int topCollider;
    int maxCollidersCapacity;
    int topRule;
    int topAction;
} PWorld;

PWorld *InitPWorld(Vector2 gravity);
PWorld *InitPWorldOnArena(Arena *a, Vector2 gravity);

Collider *InitColliderInWorld(PWorld *w, Vector2 pos, float width, float height,
                              ColliderType type, float mass);

void SetCollisionRule(PWorld *w, CollisionRule *rule);
void SetCollisionAction(PWorld *w, CollisionAction *action);

void UpdatePWorld(PWorld *w, float dt);
void DrawPWorld(PWorld *w);

void DeinitPWorld(PWorld *w);

#endif // PHYSICS_H_
