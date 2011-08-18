//
//  BossShipOceanus.h
//  Xenophobe
//
//  Created by Alexander on 10/20/10.
//  Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
//  
//  Team:
//  Alexander Nabavi-Noori - Software Engineer, Game Architect
//	James Linnell - Software Engineer, Creative Design, Art Producer
//	Tyler Newcomb - Creative Design, Art Producer
//

#import <Foundation/Foundation.h>
#import "BossShip.h"

typedef enum _OceanusState{
    kOceanusState_Stage1 = 0,
    kOceanusState_Spinning,
    kOceanusState_Stage2,
    kOceanusState_Death
} OceanusState;

@interface BossShipOceanus : BossShip {
    ModularObject   *mainbody;
    ModularObject   *harpoon;
    ModularObject   *leftTurret;
    ModularObject   *rightTurret;
    ModularObject   *leftBulge;
    ModularObject   *rightBulge;
    
    OceanusState    state;
    
    ParticleEmitter *mainBodyEmitter;
    
    GLfloat         holdingTimer;
    GLfloat         spinningTimer;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;
- (void)update:(GLfloat)delta;
- (void)render;
- (void)floatPositionWithDelta:(GLfloat)delta andTime:(GLfloat)aTime;
- (void)rotateModule:(int)mod aroundPositionWithOldrotation:(GLfloat)oldRot;

@end
