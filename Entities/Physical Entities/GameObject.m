//
//  GameObject.m
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

#import "GameObject.h"

@interface GameObject(Private)
- (BOOL)collideWith:(id<CollisionDetection>)object tolerance:(float)tolerance;
@end


@implementation GameObject

@synthesize _position, boundingBox, position;

- (BOOL)collideWith:(id<CollisionDetection>)object {
    return [self collideWith:object tolerance:kCollisionTolerance];
}

- (BOOL)collideWith:(id<CollisionDetection>)object tolerance:(float)tolerance {
    CGFloat dx, dy;
    Vector2f        box = self.boundingBox,
    objectBox = object.boundingBox;
    
    dx = ABS(object.position.x - _position.x);
    dy = ABS(object.position.y - _position.y);
    
    return (dx - (box.x/2. + objectBox.x/2.) < tolerance) && (dy - (box.y/2. + objectBox.y/2.) < tolerance);
}

@end
