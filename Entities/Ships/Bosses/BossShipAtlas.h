//
//  BossShipAtlas.h
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
//	Last Updated - 1/28/2011 @10PM - Alexander
//  - Initial write, added a bunch of stuff including
//      • Cannon joint particle emitters
//      • Objects for all of the modules
//
//  Last Updated - 6/22/11 @5PM - Alexander & James
//  - Changed name of class to reflect new boss names

#import <Foundation/Foundation.h>
#import "BossShip.h"
#import "ParticleEmitter.h"


@interface BossShipAtlas : BossShip {    
    ModularObject   *cannonLeft;
    ModularObject   *cannonRight;
    ModularObject   *turretLeft;
    ModularObject   *turretRight;
    ModularObject   *mainBody;
    
    ParticleEmitter *leftCannonEmitterJoint;
    ParticleEmitter *rightCannonEmitterJoint;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;
- (void)update:(GLfloat)delta;

@end
