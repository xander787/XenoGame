//
//  MiniBossTemplate.h
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
typedef enum _TemplateState{
    kTemplate_Entry = 0,
    kTemplate_Holding,
    kTemplate_Attacking,
    kTemplate_Death
} TemplateState;

@interface MiniBossTemplate : MiniBossGeneral {
    
    //Common variables for the mostly used activities for MiniBosses
    TemplateState       state;
    
    Vector2f            oldPointBeforeAttack;
    
    BezierCurve         *attackingPath;
    
    GLfloat             holdingTimer;
    GLfloat             attackTimer;
    GLfloat             attackPathtimer;
    
    ParticleEmitter     *deathAnimation;
    //
    
    //All weapons
    BulletProjectile    *bulletCenter;
    
}

@end
