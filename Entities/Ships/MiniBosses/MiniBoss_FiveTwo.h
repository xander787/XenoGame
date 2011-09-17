//
//  MiniBoss_FiveTwo.h
//  Xenophobe
//
//  Created by James Linnell on 9/16/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"

typedef enum _FiveTwoState{
    kFiveTwo_Entry = 0,
    kFiveTwo_Holding,
    kFiveTwo_Attacking,
    kFiveTwo_Death
} FiveTwoState;

@interface MiniBoss_FiveTwo : MiniBossGeneral {
    FiveTwoState       state;
    KamikazeState       kamikazeState;
    GLfloat             kamikazeTimer;
    
    Vector2f            oldPointBeforeAttack;
    
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimation;
    ParticleEmitter     *floaterOneDeath;
    ParticleEmitter     *floaterTwoDeath;
    ParticleEmitter     *floaterThreeDeath;
    ParticleEmitter     *floaterFourDeath;
    
    BOOL                floaterOneDeathAnimating;
    BOOL                floaterTwoDeathAnimating;
    BOOL                floaterThreeDeathAnimating;
    BOOL                floaterFourDeathAnimating;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;

@end
