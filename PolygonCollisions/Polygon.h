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
//	Last Updated - 

#import <Foundation/Foundation.h>
#import "Common.h"


@interface Polygon : NSObject {

    Vector2f     *points;
    Vector2f     *edges;
    
}

@property(readonly)Vector2f      *edges;
@property(readonly)Vector2f      *points;

- (void)buildEdges;
- (Vector2f)center;

- (void)offset:(Vector2f)v;
- (void)offset:(float)x :(float)y;

- (NSString *)toString;

@end
