//
//  MiniBoss_TwoOne.h
//  Xenophobe
//
//  Created by James Linnell on 6/18/12.
//  Copyright 2012 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"
#import "HeatSeekingMissile.h"
#import "BulletProjectile.h"

//The state in which a MiniBoss will be in at any given moment, very similar to Enemies
//because they are either sitting still or making a swooping attack every several seconds
typedef enum _TwoOneState{
    kTwoOne_Entry = 0,
    kTwoOne_Holding,
    kTwoOne_Attacking,
    kTwoOne_Death
} TwoOneState;

@interface MiniBoss_TwoOne : MiniBossGeneral {
    
    //Common variables for the mostly used activities for MiniBosses
    TwoOneState         state;
    
    Vector2f            oldPointBeforeAttack;
    
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimationOne;
    ParticleEmitter     *deathAnimationTwo;
    BOOL                deathOneIsAnimating;
    BOOL                deathTwoIsAnimating;
    //
    
    ModularObject       *mainBodyOne;
    ModularObject       *mainBodyTwo;
    GLfloat             mainBodyOneCurrentAngle;
    GLfloat             mainBodyTwoCurrentAngle;
    
    //All weapons
    BulletProjectile    *bodyOneBulletOne;
    BulletProjectile    *bodyOneBulletTwo;
    BulletProjectile    *bodyOneBulletThree;
    BulletProjectile    *bodyOneBulletFour;
    BulletProjectile    *bodyOneBulletFive;
    BulletProjectile    *bodyOneBulletSix;
    BulletProjectile    *bodyOneBulletSeven;
    BulletProjectile    *bodyOneBulletEight;
    
    BulletProjectile    *bodyTwoBulletOne;
    BulletProjectile    *bodyTwoBulletTwo;
    BulletProjectile    *bodyTwoBulletThree;
    BulletProjectile    *bodyTwoBulletFour;
    BulletProjectile    *bodyTwoBulletFive;
    BulletProjectile    *bodyTwoBulletSix;
    BulletProjectile    *bodyTwoBulletSeven;
    BulletProjectile    *bodyTwoBulletEight;
    
}

@end
