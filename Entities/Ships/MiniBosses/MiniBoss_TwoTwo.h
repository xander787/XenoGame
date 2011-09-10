//
//  MiniBoss_TwoTwo.h
//  Xenophobe
//
//  Created by James Linnell on 9/9/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"

typedef enum _TwoTwoState{
    kTwoTwo_Entry = 0,
    kTwoTwo_Holding,
    kTwoTwo_Attacking,
    kTwoTwo_Death
} TwoTwoState;

@interface MiniBoss_TwoTwo : MiniBossGeneral {
    TwoTwoState         state;
    
    Vector2f            oldPointBeforeAttack;
    
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimation;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;

@end
