//
//  MiniBoss_FourTwo.h
//  Xenophobe
//
//  Created by James Linnell on 9/16/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"

typedef enum _FourTwoState{
    kFourTwo_Entry = 0,
    kFourTwo_Holding,
    kFourTwo_Attacking,
    kFourTwo_Death
} FourTwoState;

@interface MiniBoss_FourTwo : MiniBossGeneral {
    FourTwoState         state;
    
    Vector2f            oldPointBeforeAttack;
    
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimation;
    
    ParticleEmitter     *particle;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;

@end
