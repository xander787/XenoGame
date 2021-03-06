//
//  BossShipEos.m
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

#import "BossShipEos.h"
#import "BossShip.h"


@implementation BossShipEos

- (id)initWithLocation:(CGPoint)aPoint andPlayershipRef:(PlayerShip *)playerRef {
    self = [super initWithBossID:kBoss_Eos initialLocation:aPoint andPlayerShipRef:playerRef];
    if(self){
        
        
    }
    return self;
}

- (void)update:(GLfloat)delta {
    
}

- (void)hitModule:(int)module withDamage:(int)damage {
    modularObjects[module].moduleHealth -= damage;
}

- (void)render {
    
}

- (void)dealloc {
    [super dealloc];
    [outerShieldEmitter release];
}

@end
