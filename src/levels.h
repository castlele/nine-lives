#ifndef LEVELS_H_
#define LEVELS_H_

typedef enum Level {
    FIRST = 1,
} Level;

void InitFirstLevel();
void DeinitFirstLevel();
void UpdateFirstLevel(float dt);
void DrawFirstLevel();

#endif
