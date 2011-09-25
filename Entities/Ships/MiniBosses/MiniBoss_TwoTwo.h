//
//  MiniBoss_TwoTwo.h
//  Xenophobe
//
//  Created by James Linnell on 9/9/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"
#import "HeatSeekingMissile.h"

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
    
    HeatSeekingMissile  *leftHeatSeeker;
    HeatSeekingMissile  *rightHeatSeeker;
    BulletProjectile    *leftDoubleBullet;
    BulletProjectile    *rightDoubleBullet;
    BulletProjectile    *leftSingleBullet;
    BulletProjectile    *rightSingleBullet;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;

@end
