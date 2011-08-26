//
//  BossShipHyperion.h
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
#import "AbstractProjectile.h"
#import "HeatSeekingMissile.h"

typedef enum _HyperionState {
    kHyperionState_StageOne = 0,
    kHyperionState_StageTwo,
    kHyperionState_StageThree,
} HyperionState;

@interface BossShipHyperion : BossShip {
    ModularObject       *mainBody;
    ModularObject       *wingRight;
    ModularObject       *wingLeft;
    
    HyperionState       state;
    
    AbstractProjectile  *mainBodyLeftProjectile;
    AbstractProjectile  *mainBodyRightProjectile;
    AbstractProjectile  *mainBodyCenterProjectile;
    AbstractProjectile  *mainBodyTailProjectile;
    AbstractProjectile  *wingRightPointProjectile;
    AbstractProjectile  *wingRightTurretProjectile;
    AbstractProjectile  *wingLeftPointProjectile;
    AbstractProjectile  *wingLeftTurretProjectile;
    AbstractProjectile  *wingLeftHeatSeekingProjectile;
    AbstractProjectile  *wingRightHeatSeekingProjectile;
    AbstractProjectile  *mainBodyLeftHeatSeekingProjectile;
    AbstractProjectile  *mainBodyRightHeatSeekingProjectile;
    
    ParticleEmitter     *mainBodyDeathEmitter;
    ParticleEmitter     *wingLeftDeathEmitter;
    ParticleEmitter     *wingRightDeathEmitter;
    
    float               holdingTimer;
    float               bossRotationTimer;
    float               bossReRotationTimer;
    BOOL                bossRotated;
    
    float               wingFlyOffTimer;
    
    BOOL                updateMainBodyDeathEmitterBeforeDeath;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayershipRef:(PlayerShip *)playerRef;
- (void)update:(GLfloat)delta;

@end
