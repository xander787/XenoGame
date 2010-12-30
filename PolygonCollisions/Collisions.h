//
//  Collisions.h
//  Xenophobe
//
//  Created by Alexander on 10/20/10.
//  Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
//  
//  Team:
//  Alexander Nabavi-Noori - Software Engineer, Game Architect
//	James Linnell - Software Engineer, Creative Design, Art Producer
//	Tyler Newcomb - Creative Design, Art Producer
//
//	Last Updated - 

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Polygon.h"

typedef struct {
    BOOL willIntersect;
    BOOL intersect;
    Vector2f minimumTranslationVector;
} PolygonCollisionResult;

@interface Collisions : NSObject {
    
    PolygonCollisionResult  result;
    
}

- (PolygonCollisionResult) polygonCollision:(Polygon *)polygonA :(Polygon *)polygonB :(Vector2f)velocity;
- (float)intervalDistance:(float)minA :(float)maxA :(float)minB :(float)maxB;
- (void)projectPolygon:(Vector2f)axis :(Polygon *)polygon :(float *)min :(float *)max;

@end
