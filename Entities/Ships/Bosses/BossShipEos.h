//
//  BossShipEos.h
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
#import "ParticleEmitter.h"


@interface BossShipEos : BossShip {
    ModularObject   *floaterOne;
    ModularObject   *floaterTwo;
    ModularObject   *floaterThree;
    
    ParticleEmitter *outerShieldEmitter;
    
    AbstractProjectile  *topProjectile;
    AbstractProjectile  *bottomProjectile;
    AbstractProjectile  *leftProjectile;
    AbstractProjectile  *rightProjectile;
    AbstractProjectile  *floaterCenterProjectile;
    AbstractProjectile  *floaterLeftProjectile;
    AbstractProjectile  *floaterRightProjectile;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayershipRef:(PlayerShip *)playerRef;
- (void)update:(GLfloat)delta;

@end
