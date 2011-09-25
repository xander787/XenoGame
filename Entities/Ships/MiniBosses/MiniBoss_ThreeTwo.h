//
//  MiniBoss_ThreeTwo.h
//  Xenophobe
//
//  Created by James Linnell on 9/10/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"

typedef enum _ThreeTwoState{
    kThreeTwo_Entry = 0,
    kThreeTwo_Holding,
    kThreeTwo_Attacking,
    kThreeTwo_Death
} ThreeTwoState;

@interface MiniBoss_ThreeTwo : MiniBossGeneral  {
    ThreeTwoState       state;
    
    Vector2f            oldPointBeforeAttack;
    
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimation;
    
    BulletProjectile    *singleTopBullet;
    BulletProjectile    *singleLeftBullet;
    BulletProjectile    *singleRightBullet;
    BulletProjectile    *doubleTopBullet;
    BulletProjectile    *doubleLeftBullet;
    BulletProjectile    *doubleRightBullet;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;
- (void)rotateModule:(int)mod aroundPositionWithOldrotation:(GLfloat)oldRot;

@end
