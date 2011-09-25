//
//  kMiniBoss_OneThree.h
//  Xenophobe
//
//  Created by James Linnell on 9/16/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"

typedef enum _OneThreeState{
    kOneThree_Entry = 0,
    kOneThree_Holding,
    kOneThree_Attacking,
    kOneThree_Death
} OneThreeState;

@interface MiniBoss_OneThree : MiniBossGeneral {
    OneThreeState       state;
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
    
    BulletProjectile    *doubleLeftBullet;
    BulletProjectile    *doubleRightBullet;
    MissileProjectile   *missileLeft;
    MissileProjectile   *missileRight;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;

@end
