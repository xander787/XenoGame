//
//  AbstractProjectile.h
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
#import "PhysicalObject.h"
#import "ParticleEmitter.h"
#import "Polygon.h"

typedef enum _BulletID {
    kBulletID_Normal = 0,
    kBulletID_Missile,
    kBulletID_Wave
} BulletID;

@interface AbstractProjectile : PhysicalObject {
    Polygon *polygon;
    Vector2f *collisionPoints;

    int bulletAngle;
    int bulletSpeed;
    BulletID mainBulletID;
    
    
    CGPoint turretPosition;
    
    CGPoint currentLocation;
    CGPoint desiredLocation;
    
    ParticleEmitter *emitter;
}

- (id)initWithBulletID:(BulletID)aBulletID fromTurretPosition:(CGPoint)aPosition andAngle:(int)aAngle;
- (void)update:(CGFloat)aDelta;
- (void)render;

@end
