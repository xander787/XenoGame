//
//  MiniBoss_SixTwo.h
//  Xenophobe
//
//  Created by James Linnell on 9/11/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"
#import "HeatSeekingMissile.h"

typedef enum _SixTwoState{
    kSixTwo_Entry = 0,
    kSixTwo_Holding,
    kSixTwo_Attacking,
    kSixTwo_Death
} SixTwoState;

@interface MiniBoss_SixTwo : MiniBossGeneral {
    SixTwoState         state;
    
    ModularObject       *shield;
    
    Vector2f            oldPointBeforeAttack;
    
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimation;
    
    BulletProjectile    *doubleBulletLeft;
    BulletProjectile    *doubleBulletRight;
    WaveProjectile      *waveLeft;
    WaveProjectile      *waveRight;
    HeatSeekingMissile  *heatSeekerLeft;
    HeatSeekingMissile  *heatSeekerRight;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;

@end
