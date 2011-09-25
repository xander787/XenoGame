//
//  MiniBoss_ThreeThree.h
//  Xenophobe
//
//  Created by James Linnell on 9/10/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"
#import "ParticleProjectile.h"
#import "HeatSeekingMissile.h"

typedef enum _ThreeThreeState{
    kThreeThree_Entry = 0,
    kThreeThree_Holding,
    kThreeThree_Attacking,
    kThreeThree_Death
} ThreeThreeState;

@interface MiniBoss_ThreeThree : MiniBossGeneral {
    ThreeThreeState       state;
    
    Vector2f            oldPointBeforeAttack;
    
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimation;
    
    ParticleProjectile  *particleProjectile;
    BulletProjectile    *doubleBulletLeft;
    BulletProjectile    *doubleBulletRight;
    HeatSeekingMissile  *heatSeekerLeft;
    HeatSeekingMissile  *heatSeekerRight;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;

@end
