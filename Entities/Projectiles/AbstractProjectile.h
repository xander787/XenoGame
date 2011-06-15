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
//	Last Updated - 1/26/2011 @ 5:20PM - Alexander
//  - Added ability to change location, and also added properties for
//  public vars

#import <Foundation/Foundation.h>
#import "PhysicalObject.h"
#import "ParticleEmitter.h"
#import "Polygon.h"

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
    int             projectileAngle;
    int             projectileSpeed;
    ProjectileID    projectileID;
    ParticleID      particleID;
    NSString        *idType;
    
    Vector2f        turretPosition;
    Vector2f        currentLocation;
    Vector2f        desiredLocation;
    
    BOOL            isActive;
    BOOL            isDead;
    
    NSString        *nameOfImage;
    
    
@private
    Vector2f        *collisionPoints;
    int             collisionPointCount;
    int             rateOfFire;
    int             particleRadius;
    
    //Particle Emitter specific variables
    ParticleEmitter *emitter;
    NSMutableArray  *polygonArray;
    Polygon         *particlePolygon;
    
    //Image specific variables
    Image           *image;
    Polygon         *missilePolygon;
    GLfloat         elapsedTime;
    BOOL            isAlive;
}

@property (nonatomic)   Vector2f        turretPosition;
@property (readonly)    Vector2f        currentLocation;
@property (nonatomic)   Vector2f        desiredLocation;
@property (nonatomic)   BOOL            isActive;
@property (nonatomic)   int             projectileAngle;
@property (nonatomic)   int             projectileSpeed;
@property (nonatomic)   ProjectileID    projectileID;


- (id)initWithProjectileID:(ProjectileID)aProjectileID fromTurretPosition:(Vector2f)aPosition andAngle:(int)aAngle emissionRate:(int)aRate;
- (id)initWithParticleID:(ParticleID)aParticleID fromTurretPosition:(Vector2f)aPosition radius:(int)aRadius rateOfFire:(int)aRate andAngle:(int)aAngle;
- (void)update:(CGFloat)aDelta;
- (void)render;
- (void)pauseProjectile;
- (void)playProjectile;
- (void)stopProjectile;

@end
