//
//  BossShipAtlas.h
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
//	Last Updated - 1/28/2011 @10PM - Alexander
//  - Initial write, added a bunch of stuff including
//      • Cannon joint particle emitters
//      • Objects for all of the modules
//
//  Last Updated - 6/22/11 @5PM - Alexander & James
//  - Changed name of class to reflect new boss names

#import <Foundation/Foundation.h>
#import "BossShip.h"
#import "ParticleEmitter.h"
#import "ParticleProjectile.h"
#import "HeatSeekingMissile.h"

//The +- limits for how far away an enemy ship can
//stray from their respective holding points
#define HOLDING_LIMIT_X 5
#define HOLDING_LIMIT_Y 5

typedef enum _AtlasState {
    kAtlasState_StageOne = 0,
    kAtlasState_StageTwo,
    kAtlasState_StageThree,
    kAtlasState_StageFour
} AtlasState;

@interface BossShipAtlas : BossShip {    
    ModularObject   *cannonLeft;
    ModularObject   *cannonRight;
    ModularObject   *mainBody;
    ModularObject   *frontCenterTurret;
    ModularObject   *frontLeftTurret;
    ModularObject   *frontRightTurret;
    
    ParticleEmitter *leftCannonEmitterJoint;
    ParticleEmitter *rightCannonEmitterJoint;
    ParticleEmitter *backEngineEnergyEmitter;
    
    ParticleEmitter *mainBodyDeathEmitter;
    ParticleEmitter *leftCannonDeathEmitter;
    ParticleEmitter *rightCannonDeathEmitter;
    ParticleEmitter *frontCenterTurretDeathEmitter;
    ParticleEmitter *frontLeftTurretDeathEmitter;
    ParticleEmitter *frontRightTurretDeathEmitter;
    ParticleEmitter *leftCannonDeathSecondaryEmitter;
    ParticleEmitter *rightCannonDeathSecondaryEmitter;
    ParticleEmitter *frontCenterTurretDeathSecondaryEmitter;
    ParticleEmitter *frontLeftTurretDeathSecondaryEmitter;
    ParticleEmitter *frontRightTurretDeathSecondaryEmitter;

    BOOL            updateMainBodyDeathEmitter;
    
    BOOL            cannonRightFlewOff;
    BOOL            cannonLeftFlewOff;
    BOOL            frontCenterTurretFlewOff;
    BOOL            frontLeftTurretFlewOff;
    BOOL            frontRightTurretFlewOff;
    
    BOOL            currentStagePaused;
    float           stagePauseTimer;
    
    AtlasState      state;
    float           holdingTimer;
    
    
    AbstractProjectile  *frontCenterTurretProjectile;
    AbstractProjectile  *frontLeftTurretProjectile;
    AbstractProjectile  *frontRightTurretProjectile;
    ParticleProjectile  *cannonLeftProjectile;
    ParticleProjectile  *cannonRightProjectile;
    AbstractProjectile  *shipLeftProjectile;
    AbstractProjectile  *shipFarLeftProjectile;
    AbstractProjectile  *shipRightProjectile;
    AbstractProjectile  *shipFarRightProjectile;
    AbstractProjectile  *shipWingLeftProjectile;
    AbstractProjectile  *shipWingRightProjectile;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;
- (void)update:(GLfloat)delta;

@end
