//
//  MiniBoss_SevenOne.h
//  Xenophobe
//
//  Created by James Linnell on 9/16/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"

typedef enum _SevenOneState{
    kSevenOne_Entry = 0,
    kSevenOne_Holding,
    kSevenOne_Attacking,
    kSevenOne_Death
} SevenOneState;

@interface MiniBoss_SevenOne : MiniBossGeneral {
    SevenOneState       state;
    
    Vector2f            oldPointBeforeAttack;
    
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimation;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;

@end
