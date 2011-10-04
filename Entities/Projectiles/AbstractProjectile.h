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
//
//  Last Updated - 6/23/2011 @ 7:45PM - James
//  - Synthesized emitter for use in collision detection

#import <Foundation/Foundation.h>
#import "PhysicalObject.h"
#import "ParticleEmitter.h"
#import "Polygon.h"

typedef enum _ProjectileID {
    kPlayerProjectile_BulletLevelOne_Single = 0,
    kPlayerProjectile_BulletLevelTwo_Double,
    kPlayerProjectile_BulletLevelThree_Double,
    kPlayerProjectile_BulletLevelFour_Triple,
    kPlayerProjectile_BulletLevelFive_Triple,
    kPlayerProjectile_BulletLevelSix_Quadruple,
    kPlayerProjectile_BulletLevelSeven_Quadruple,
    kPlayerProjectile_BulletLevelEight_Quintuple,
    kPlayerProjectile_BulletLevelNine_Quintuple,
    kPlayerProjectile_BulletLevelTen_Septuple,
    
    kPlayerProjectile_WaveLevelOne_SingleSmall,
    kPlayerProjectile_WaveLevelTwo_DoubleSmall,
    kPlayerProjectile_WaveLevelThree_DoubleSmall,
    kPlayerProjectile_WaveLevelFour_SingleBig,
    kPlayerProjectile_WaveLevelFive_SingleBig,
    kPlayerProjectile_WaveLevelSix_DoubleMedium,
    kPlayerProjectile_WaveLevelSeven_DoubleMedium,
    kPlayerProjectile_WaveLevelEight_DoubleBig,
    kPlayerProjectile_WaveLevelNine_DoubleBig,
    kPlayerProjectile_WaveLevelTen_TripleBig,
    
    kPlayerProjectile_MissileLevelOne_Single,
    kPlayerProjectile_MissileLevelTwo_Double,
    kPlayerProjectile_MissileLevelThree_Double,
    kPlayerProjectile_MissileLevelFour_Triple,
    kPlayerProjectile_MissileLevelFive_Triple,
    kPlayerProjectile_MissileLevelSix_Quadruple,
    kPlayerProjectile_MissileLevelSeven_Quadruple,
    kPlayerProjectile_MissileLevelEight_Quintuple,
    kPlayerProjectile_MissileLevelNine_Quintuple,
    kPlayerProjectile_MissileLevelTen_Sextuple,
    
    kEnemyProjectile_BulletLevelOne_Single,
    kEnemyProjectile_BulletLevelTwo_Double,
    kEnemyProjectile_BulletLevelThree_Double,
    kEnemyProjectile_BulletLevelFour_Triple,
    kEnemyProjectile_BulletLevelFive_Triple,
    kEnemyProjectile_BulletLevelSix_Quadruple,
    kEnemyProjectile_BulletLevelSeven_Quadruple,
    kEnemyProjectile_BulletLevelEight_Quintuple,
    kEnemyProjectile_BulletLevelNine_Quintuple,
    kEnemyProjectile_BulletLevelTen_Septuple,
    
    kEnemyProjectile_WaveLevelOne_SingleSmall,
    kEnemyProjectile_WaveLevelTwo_DoubleSmall,
    kEnemyProjectile_WaveLevelThree_DoubleSmall,
    kEnemyProjectile_WaveLevelFour_SingleBig,
    kEnemyProjectile_WaveLevelFive_SingleBig,
    kEnemyProjectile_WaveLevelSix_DoubleMedium,
    kEnemyProjectile_WaveLevelSeven_DoubleMedium,
    kEnemyProjectile_WaveLevelEight_DoubleBig,
    kEnemyProjectile_WaveLevelNine_DoubleBig,
    kEnemyProjectile_WaveLevelTen_TripleBig,
    
    kEnemyProjectile_MissileLevelOne_Single,
    kEnemyProjectile_MissileLevelTwo_Double,
    kEnemyProjectile_MissileLevelThree_Double,
    kEnemyProjectile_MissileLevelFour_Triple,
    kEnemyProjectile_MissileLevelFive_Triple,
    kEnemyProjectile_MissileLevelSix_Quadruple,
    kEnemyProjectile_MissileLevelSeven_Quadruple,
    kEnemyProjectile_MissileLevelEight_Quintuple,
    kEnemyProjectile_MissileLevelNine_Quintuple,
    kEnemyProjectile_MissileLevelTen_Sextuple,
    
    kPlayerProjectile_HeatSeekingMissile,
    kEnemyProjectile_HeatSeekingMissile,
    
    kPlayerParticle_Single,
    kPlayerParticle_Double,
    kPlayerParticle_Triple,
    
    kEnemyParticle_Single,
    kEnemyParticle_Double,
    kEnemyParticle_Triple,
} ProjectileID;

@interface AbstractProjectile : PhysicalObject {
    ProjectileID    projectileID;
    GLfloat         angle;
    Vector2f        location;
    
    NSMutableArray  *polygons;
    NSMutableArray  *emitters;
    
    BOOL            isActive;
    BOOL            isAlive;
    BOOL            isStopped;
    
    GLfloat         elapsedTime;
    
    GLfloat         speed;
    GLfloat         rate;
    
    int             collisionPointCount;
    Vector2f        *collisionPoints;

}
@property(readonly) ProjectileID projectileID;
@property(readwrite) GLfloat angle;
@property(readwrite) Vector2f location;
@property(nonatomic, readonly) NSMutableArray *polygons;
@property(nonatomic, retain) NSMutableArray *emitters;

- (id)initWithProjectileID:(ProjectileID)aProjID location:(Vector2f)aLocation andAngle:(GLfloat)aAngle;
- (void)update:(GLfloat)aDelta;
- (void)render;
- (void)pauseProjectile;
- (void)playProjectile;
- (void)stopProjectile;

@end
