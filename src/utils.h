#ifndef UTILS_H_
#define UTILS_H_

#include <raylib.h>
#include <stdio.h>
#include <string.h>

static void printMessage(const char *prefix, const char *msg);

#define PRINTLN(msg) printf("%s\n", msg)

#define TODO(msg) \
    printMessage("[TODO]: ", msg); \
    exit(-1)

#define FATAL(msg) \
    printMessage("[FATAL]: ", msg); \
    exit(-1)

#define INFO(...) \
    TraceLog(LOG_INFO, __VA_ARGS__)

#define WARN(...) \
    TraceLog(LOG_WARNING, __VA_ARGS__)

#define STR_EQUALS(lhs, rhs) strcmp(lhs, rhs) == 0

static void printMessage(const char *prefix, const char *msg) {
    printf("%s%s\n", prefix, msg);
}

#endif
