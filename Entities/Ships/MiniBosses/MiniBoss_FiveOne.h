//
//  MiniBoss_FiveOne.h
//  Xenophobe
//
//  Created by James Linnell on 9/9/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"
#import "HeatSeekingMissile.h"

typedef enum _FiveOneState{
    kFiveOne_Entry = 0,
    kFiveOne_Holding,
    kFiveOne_Attacking,
    kFiveOne_Death
} FiveOneState;

@interface MiniBoss_FiveOne : MiniBossGeneral {
    FiveOneState       state;
    
    Vector2f            oldPointBeforeAttack;
    
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimation;
    ParticleEmitter     *middleDeathAnimation;
    ParticleEmitter     *outerDeathAnimation;
    
    BulletProjectile    *centerTripleBullet;
    WaveProjectile      *centerWaveLeft;
    WaveProjectile      *centerWaveRight;
    HeatSeekingMissile  *centerHeatSeekerLeft;
    HeatSeekingMissile  *centerHeatSeekerRight;
    
    WaveProjectile      *middleWaveBottom;
    WaveProjectile      *middleWaveTop;
    BulletProjectile    *middleTripleLeft;
    BulletProjectile    *middleTripleRight;
    
    WaveProjectile      *outerWaveLeft;
    WaveProjectile      *outerWaveRight;
    BulletProjectile    *outerTripleBottomLeft;
    BulletProjectile    *outerTripleTopRight;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;
- (void)rotateModule:(int)mod aroundPositionWithOldrotation:(GLfloat)oldRot;

@end
