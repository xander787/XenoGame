//
//  MiniBoss_SixOne.h
//  Xenophobe
//
//  Created by James Linnell on 9/16/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"
#import "HeatSeekingMissile.h"

typedef enum _SixOneState{
    kSixOne_Entry = 0,
    kSixOne_Holding,
    kSixOne_Attacking,
    kSixOne_Death
} SixOneState;

@interface MiniBoss_SixOne : MiniBossGeneral {
    SixOneState       state;
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
    
    BOOL                floaterOneDeathAnimating;
    BOOL                floaterTwoDeathAnimating;
    
    BulletProjectile    *tripleBulletLeft;
    BulletProjectile    *tripleBulletRight;
    HeatSeekingMissile  *heatSeekerBottomLeft;
    HeatSeekingMissile  *heatSeekerBottomRight;
    HeatSeekingMissile  *heatSeekerTopLeft;
    HeatSeekingMissile  *heatSeekerTopRight;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;

@end
