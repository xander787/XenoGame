//
//  BossShipHelios.h
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

typedef enum _HeliosState {
    kHeliosState_StageOne = 0,
    kHeliosState_StageTwo,
    kHeliosState_StageThree,
    kHeliosState_StageFour
} HeliosState;

@interface BossShipHelios : BossShip {
    ModularObject       *mainBody;
    ModularObject       *tail;
    ModularObject       *rightWing;
    ModularObject       *leftWing;
    
    HeliosState         state;
    
    ParticleEmitter     *mainBodyDeathEmitter;
    ParticleEmitter     *wingShipDeathEmitter;
    ParticleEmitter     *rightWingDeathSecondaryEmitter;
    ParticleEmitter     *leftWingDeathSecondaryEmitter;
    
    BOOL                stageAnimating;
    float               holdingTimer;
    BOOL                currentStagePaused;
    
    BOOL                wingRightFlewOff;
    BOOL                wingLeftFlewOff;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;
- (void)update:(GLfloat)delta;

@end
