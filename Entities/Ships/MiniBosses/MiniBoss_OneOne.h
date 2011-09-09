//
//  MiniBoss_OneOne.h
//  Xenophobe
//
//  Created by James Linnell on 9/8/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"

typedef enum _OneOneState{
    kOneOne_Entry = 0,
    kOneOne_Holding,
    kOneOne_Attacking,
    kOneOne_Death
} OneOneState;

@interface MiniBoss_OneOne : MiniBossGeneral {
    OneOneState         state;
    
    Vector2f            oldPointBeforeAttack;
        
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimation;
    
    BulletProjectile    *leftBullet;
    BulletProjectile    *rightBullet;
    MissileProjectile   *leftMissile;
    MissileProjectile   *rightMissile;
}

@end
