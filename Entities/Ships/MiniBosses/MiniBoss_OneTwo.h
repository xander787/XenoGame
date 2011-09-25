//
//  MiniBoss_OneTwo.h
//  Xenophobe
//
//  Created by James Linnell on 9/16/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"

typedef enum _OneTwoState{
    kOneTwo_Entry = 0,
    kOneTwo_Holding,
    kOneTwo_Attacking,
    kOneTwo_Death
} OneTwoState;

@interface MiniBoss_OneTwo : MiniBossGeneral {
    OneTwoState       state;
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
    
    BulletProjectile    *bodyCenterBullet;
    BulletProjectile    *bodyLeftBullet;
    BulletProjectile    *bodyRightBullet;
    BulletProjectile    *floaterLeftBullet;
    BulletProjectile    *floaterRightBullet;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;
- (void)rotateModule:(int)mod aroundPositionWithOldrotation:(GLfloat)oldRot;

@end
