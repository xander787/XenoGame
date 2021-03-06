//
//  MiniBoss_ThreeOne.h
//  Xenophobe
//
//  Created by James Linnell on 9/9/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"
#import "HeatSeekingMissile.h"
#import "ParticleProjectile.h"

typedef enum _ThreeOneState{
    kThreeOne_Entry = 0,
    kThreeOne_Holding,
    kThreeOne_Attacking,
    kThreeOne_Death
} ThreeOneState;

@interface MiniBoss_ThreeOne : MiniBossGeneral {
    ThreeOneState       state;
    
    Vector2f            oldPointBeforeAttack;
    
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimation;
    
    WaveProjectile      *waveProjectile;
    HeatSeekingMissile  *heatSeekerLeft;
    HeatSeekingMissile  *heatSeekerRight;
    ParticleProjectile  *particleCannonLeft;
    ParticleProjectile  *particleCannonRight;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;

@end
