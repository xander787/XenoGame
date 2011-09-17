//
//  MiniBoss_SevenThree.h
//  Xenophobe
//
//  Created by James Linnell on 9/16/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"

typedef enum _SevenThreeState{
    kSevenThree_Entry = 0,
    kSevenThree_Holding,
    kSevenThree_Attacking,
    kSevenThree_Death
} SevenThreeState;

@interface MiniBoss_SevenThree : MiniBossGeneral {
    SevenThreeState       state;
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
    
    BOOL                floaterOneDeathAnimating;
    BOOL                floaterTwoDeathAnimating;
    BOOL                floaterThreeDeathAnimating;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;

@end
