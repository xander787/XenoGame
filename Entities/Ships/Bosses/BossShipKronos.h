//
//  BossShipKronos.h
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

#import <Foundation/Foundation.h>
#import "BossShip.h"
#import "ParticleProjectile.h"

typedef enum _KronosState {
    kKronosState_StageOne = 0,
    kKronosState_StageTwo
} KronosState;

@interface BossShipKronos : BossShip {
    KronosState         state;
    
    ModularObject       *mainBody;
    ModularObject       *head;
    ModularObject       *bottomLeftTurret;
    ModularObject       *middleLeftTurret;
    ModularObject       *middleLeftWing;
    ModularObject       *topLeftCannon;
    ModularObject       *topLeftTurret;
    ModularObject       *bottomRightTurret;
    ModularObject       *middleRightTurret;
    ModularObject       *middleRightWing;
    ModularObject       *topRightCannon;
    ModularObject       *topRightTurret;
    ModularObject       *tail;
    
//    ParticleEmitter     *mainBodyDeathEmitter;
    ParticleEmitter     *headDeathEmitter;
    ParticleEmitter     *bottomLeftTurretDeathEmitter;
    ParticleEmitter     *middleLeftTurretDeathEmitter;
    ParticleEmitter     *middleLeftWingDeathEmitter;
    ParticleEmitter     *topLeftCannonDeathEmitter;
    ParticleEmitter     *topLeftTurretDeathEmitter;
    ParticleEmitter     *bottomRightTurretDeathEmitter;
    ParticleEmitter     *middleRightTurretDeathEmitter;
    ParticleEmitter     *middleRightWingDeathEmitter;
    ParticleEmitter     *topRightCannonDeathEmitter;
    ParticleEmitter     *topRightTurretDeathEmitter;
    ParticleEmitter     *tailDeathEmitter;
    
//    AbstractProjectile  *mainBodyProjectile;
    AbstractProjectile  *headProjectileLeft;
    AbstractProjectile  *headProjectileRight;
    AbstractProjectile  *bottomLeftTurretProjectile;
    AbstractProjectile  *middleLeftTurretProjectile;
    AbstractProjectile  *middleLeftWingProjectile;
    AbstractProjectile  *topLeftCannonProjectile;
    AbstractProjectile  *topLeftTurretProjectile;
    AbstractProjectile  *bottomRightTurretProjectile;
    AbstractProjectile  *middleRightTurretProjectile;
    AbstractProjectile  *middleRightWingProjectile;
    AbstractProjectile  *topRightCannonProjectile;
    AbstractProjectile  *topRightTurretProjectile;
    AbstractProjectile  *tailProjectile;
    
    GLfloat             stageTwoTimer;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;
- (void)update:(GLfloat)delta;
- (void)render;
- (void)hitModule:(int)module withDamage:(int)damage;
- (void)rotateModule:(int)mod aroundPositionWithOldrotation:(GLfloat)oldRot;
- (ParticleEmitter *)newDeathAnimationEmitter;

@end
