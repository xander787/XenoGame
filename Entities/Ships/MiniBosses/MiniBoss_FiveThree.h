//
//  MiniBossFiveThree.h
//  Xenophobe
//
//  Created by James Linnell on 6/18/12.
//  Copyright 2012 PDHS. All rights reserved.
//

#import "MiniBossGeneral.h"
#import "HeatSeekingMissile.h"
#import "BulletProjectile.h"
#import "BossShip.h"

//The state in which a MiniBoss will be in at any given moment, very similar to Enemies
//because they are either sitting still or making a swooping attack every several seconds
typedef enum _FiveThreeState{
    kFiveThree_Entry = 0,
    kFiveThree_Holding,
    kFiveThree_Attacking,
    kFiveThree_Death
} FiveThreeState;

typedef enum _RotatingState{
    kRotating_StepOneForward = 0,
    kRotating_StepOneReturn,
    kRotating_StepTwoForward,
    kRotating_StepTwoReturn
} RotatingState;

@interface MiniBoss_FiveThree : MiniBossGeneral {
    
    //Common variables for the mostly used activities for MiniBosses
    FiveThreeState       state;
    
    Vector2f            oldPointBeforeAttack;
    
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimation;
    //
    
    //All weapons
    BulletProjectile    *bulletCenter;
    
    ModularObject       *front;
    ModularObject       *bodyOne;
    ModularObject       *bodyTwo;
    ModularObject       *bodyThree;
    ModularObject       *back;
    
    ParticleEmitter     *orbFrontVBodyOne;
    ParticleEmitter     *orbBodyOneVBodyTwo;
    ParticleEmitter     *orbBodyTwoVBodyThree;
    ParticleEmitter     *orbBodyThreeVBack;
    
    RotatingState       rotatingState;
}

- (void)hitModule:(int)module withDamage:(int)damage;
- (Vector2f)rotatePoint:(Vector2f)initialPoint aroundAngle:(GLfloat)angle;
- (void)syncCollisionPolygonWithRotation:(GLfloat)oldRot :(GLfloat)oldRot2 :(GLfloat)oldRot3;

@end
