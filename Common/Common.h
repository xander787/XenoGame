/*
 *  Common.h
 *  Xenophobe
 *
 *  Created by Alexander on 10/20/10.
 *  Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
 *
 *	Team:
 *	Alexander Nabavi-Noori - Software Engineer, Game Architect
 *	James Linnell - Software Engineer, Creative Design, Art Producer
 *	Tyler Newcomb - Creative Design, Art Producer
 *
 *	Last Updated - 10/27/2010 @ 12AM - Alexander
 *	- Changed the particle structure to include delta size
 *	for the ability to set a finish particle size
 *
 *  Last Updated - 12/19/2010 @ 5:20PM - James
 *  - Added inline func for collisions. Takes 5 variables:
 *  object1's bounding box, it's position
 *  object2's boundingbox, it's position, and then the tolerance
 *
 *  Last Updated - 12/27/2010 @ 6:50PM - James
 *  - Added circular collision detection function
 *  using the positions and radiuses
 *
 *  Last Updated - 12/29/2010 @ 12:30AM - James
 *  - Added function to change NSArrays to
 *  regular C Arrays, mainly for use in Ship classes
 *  to shorten init functions.
 *
 *  Last Updated - 12/29/2010 @ 11:50PM - James
 *  - Added function to retrieve the number of
 *  objects in a array of Vector2f's, for
 *  use in the PolygonCollision.
 *
 */

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <math.h>

#pragma mark -
#pragma mark Debug

#define DEBUG 1

#pragma mark -
#pragma mark Macros

// Macro which returns a random value between -1 and 1
#define RANDOM_MINUS_1_TO_1() ((random() / (GLfloat)0x3fffffff )-1.0f)

// Macro which returns a random number between 0 and 1
#define RANDOM_0_TO_1() ((random() / (GLfloat)0x7fffffff ))

// Macro which converts degrees into radians
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

// Macro which converts coordinate rise / run to particle emitter angle
// ;#define SLOPE_TO_DEGREES(__SLOPE__) (DEGREES_TO_RADIANS(atan(__SLOPE__)))


#pragma mark -
#pragma mark Enumerations

enum {
	kControlType_NewGame,
	kControlType_Settings,
	kControlType_About,
	kControlType_HighScores,
	kControl_Idle,
	kControl_Scaling,
	kControl_Selected,
	kGameState_Running,
	kGameState_Paused,
	kGameState_Loading,
	kSceneState_Idle,
	kSceneState_TransitionIn,
	kSceneState_TransitionOut,
	kSceneState_Running,
	kSceneState_Paused
};


#pragma mark -
#pragma mark Types

typedef struct _TileVert {
	GLfloat v[2];
	GLfloat uv[2];
} TileVert;

typedef struct _Color4f {
	GLfloat red;
	GLfloat green;
	GLfloat blue;
	GLfloat alpha;
} Color4f;

typedef struct _Vector2f {
	GLfloat x;
	GLfloat y;
} Vector2f;

typedef struct _Quad2f {
	GLfloat bl_x, bl_y;
	GLfloat br_x, br_y;
	GLfloat tl_x, tl_y;
	GLfloat tr_x, tr_y;
} Quad2f;

typedef struct _Particle {
	Vector2f position;
	Vector2f direction;
	Color4f color;
	Color4f deltaColor;
	GLfloat particleSize;
	GLfloat timeToLive;
	GLfloat	deltaSize;
} Particle;


typedef struct _PointSprite {
	GLfloat x;
	GLfloat y;
	GLfloat size;
} PointSprite;

#pragma mark -
#pragma mark Inline Functions

static const Color4f Color4fInit = {1.0f, 1.0f, 1.0f, 1.0f};

static const Vector2f Vector2fZero = {0.0f, 0.0f};

static inline Vector2f Vector2fMake(GLfloat x, GLfloat y)
{
	return (Vector2f) {x, y};
}

static inline Color4f Color4fMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
{
	return (Color4f) {red, green, blue, alpha};
}

static inline Vector2f Vector2fMultiply(Vector2f v, GLfloat s)
{
	return (Vector2f) {v.x * s, v.y * s};
}

static inline Vector2f Vector2fAdd(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x + v2.x, v1.y + v2.y};
}

static inline Vector2f Vector2fSub(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x - v2.x, v1.y - v2.y};
}

static inline GLfloat Vector2fDot(Vector2f v1, Vector2f v2)
{
	return (GLfloat) v1.x * v2.x + v1.y * v2.y;
}

static inline GLfloat Vector2fLength(Vector2f v)
{
	return (GLfloat) sqrtf(Vector2fDot(v, v));
}

static inline Vector2f Vector2fNormalize(Vector2f v)
{
	return Vector2fMultiply(v, 1.0f/Vector2fLength(v));
}

static inline int lengthOfVec2fArray(Vector2f *v){
    return (sizeof(v) / sizeof(Vector2f));
}

static inline BOOL didCollideRectangular(Vector2f boundingBox1, Vector2f position1, Vector2f boundingBox2, Vector2f position2, GLfloat tolerance) {
    CGFloat dx, dy;
//    NSLog(@"%f, %f, %f, %f", position1.x, position1.y, position2.x, position2.y);
    dx = ABS(position2.x - position1.x);
    dy = ABS(position2.y - position1.y);
    
    return (dx - (boundingBox1.x/2. + boundingBox2.x/2.) < tolerance) && (dy - (boundingBox1.y/2. + boundingBox2.y/2.) < tolerance);
}

static inline BOOL didCollideCircular(Vector2f position1, int radius1, Vector2f position2, int radius2, int tolerance) {
    //Uses simple distance formula and checks the distance against the tolerance (in whole numbers, for pixels)
    return (sqrt(pow((position2.x - position1.x), 2) + pow((position2.y - position1.y), 2)) - (radius1 + radius2) <= tolerance);
}

static inline Vector2f * transferFromNSArrayToCArray(NSArray *recievedArray){
    //Mainly in use for shortening code in Ships classes
    Vector2f *targetArray = malloc(sizeof(Vector2f) * [recievedArray count]);
    bzero(targetArray, sizeof(Vector2f) * [recievedArray count]);
    
    for(int i = 0; i < [recievedArray count]; i++){
        NSArray *recievedArrayObject = [[NSArray alloc] initWithArray:[[recievedArray objectAtIndex:i] componentsSeparatedByString:@","]];
        @try {
            targetArray[i] = Vector2fMake([[recievedArrayObject objectAtIndex:0] intValue], [[recievedArrayObject objectAtIndex:1] intValue]);
        }
        @catch (NSException * e) {
            NSLog(@"Exception thrown: %@", e);
        }
        @finally {
            Vector2f vector = targetArray[i];
            NSLog(@"Added object: %f, %f", vector.x, vector.y);
        }
    }
    
    return targetArray;
}
