//
//  GameObject.h
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
//	Last Updated - 12/17/10 @6PM - James
//  -Changed the boundingBox form readonly
//  to readwrite so PlayerShip and EnemyShip
//  classes could assign correct measurements.

#import <Foundation/Foundation.h>
#import "Image.h"

#define kCollisionTolerance 0.1


@protocol CollisionDetection
@required
- (BOOL)collideWith:(id<CollisionDetection>)object;

@property(readwrite) Vector2f position;
@property(readwrite) Vector2f boundingBox;
@end


@interface GameObject : Image <CollisionDetection> {
    @protected
    Vector2f    _position;
}

@property Vector2f  _position;

@end
