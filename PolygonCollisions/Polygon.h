//
//  Polygon.h
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
//	Last Updated - 12/30/2010 @ 4:20PM - James
//  - Changed both to readwrite
//
//  Last Updated - 12/30/2010 @ %PM - James
//  - Added pointCount, because no way of getting
//  count of dynamic array

#import <Foundation/Foundation.h>
#import "Common.h"


@interface Polygon : NSObject {

    Vector2f    *points;
    Vector2f    *edges;
    int         pointCount;  
    Vector2f    velocity;
    Vector2f    *originalPoints;
    
}

@property(readwrite)Vector2f    *edges;
@property(readwrite)Vector2f    *points;
@property(readwrite)int         pointCount;
@property(readwrite)Vector2f    velocity;
@property(readwrite)Vector2f    *originalPoints;

- (id)initWithPointCount:(int)count;

- (void)buildEdges;
- (Vector2f)center;

- (void)offset:(Vector2f)v;
- (void)offset:(float)x :(float)y;
- (void)setPos:(CGPoint)pt;

- (NSString *)toString;

@end
