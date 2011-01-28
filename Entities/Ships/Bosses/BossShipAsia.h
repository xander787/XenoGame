//
//  BossShipAsia.h
//  Xenophobe
//
//  Created by Alexander on 10/20/10.
//  Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BossShip.h"
#import "ParticleEmitter.h"


@interface BossShipAsia : BossShip {    
    ModularObject   cannonLeft;
    ModularObject   cannonRight;
    ModularObject   turretLeft;
    ModularObject   turretRight;
    ModularObject   mainBody;
    
    ParticleEmitter *leftCannonEmitterJoint;
    ParticleEmitter *rightCannonEmitterJoint;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;
- (void)update:(GLfloat)delta;

@end
