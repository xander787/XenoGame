//
//  MiniBoss_TwoThree.h
//  Xenophobe
//
//  Created by James Linnell on 9/16/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"
#import "HeatSeekingMissile.h"

typedef enum _TwoThreeState{
    kTwoThree_Entry = 0,
    kTwoThree_Holding,
    kTwoThree_Attacking,
    kTwoThree_Death
} TwoThreeState;

@interface MiniBoss_TwoThree : MiniBossGeneral {
    TwoThreeState         state;
    
    Vector2f            oldPointBeforeAttack;
    
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimation;
    
    BulletProjectile    *bodyCenterDoubleBullet;
    HeatSeekingMissile  *bottomLeftHeatSeeker;
    HeatSeekingMissile  *bottomRightHeatSeeker;
    HeatSeekingMissile  *topLeftHeatSeeker;
    HeatSeekingMissile  *topRightHeatSeeker;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;


@end
