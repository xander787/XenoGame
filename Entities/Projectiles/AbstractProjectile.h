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

#define BULLET_INTERVAL 1
#define MISSILE_INETERVAL 2000
#define WAVE_INTERVAL 1500

typedef enum _ProjectileID {
    kEnemyProjectile_Bullet = 0,
    kEnemyProjectile_Missile,
    kEnemyProjectile_Wave,
    kPlayerProjectile_Bullet,
    kPlayerProjectile_Missile,
    kPlayerProjectile_Wave
} ProjectileID;

typedef enum _ParticleID {
    kEnemyParticle = 0,
    kPlayerParticle
} ParticleID;

@interface AbstractProjectile : PhysicalObject {
    ParticleEmitter *emitter;
    Image           *image;
    
    NSMutableArray  *polygonArray;
    Vector2f        *collisionPoints;
    int             collisionPointCount;

    int             projectileAngle;
    int             projectileSpeed;
    ProjectileID    projectileID;
    
    CGPoint         turretPosition;
    CGPoint         currentLocation;
    CGPoint         desiredLocation;
    
    GLfloat         elapsedTime;
    
    BOOL            isActive;
}

- (id)initWithProjectileID:(ProjectileID)aProjectileID fromTurretPosition:(CGPoint)aPosition andAngle:(int)aAngle;
- (id)initWithParticleID:(ParticleID)aParticleID fromTurretPosition:(CGPoint)aPosition andAngle:(int)aAngle;
- (void)update:(CGFloat)aDelta;
- (void)render;
- (void)setFiring:(BOOL)aFire;
- (void)fireProjectile;

@end
