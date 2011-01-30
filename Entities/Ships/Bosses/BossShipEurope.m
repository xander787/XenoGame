//
//  BossShipEurope.m
//  Xenophobe
//
//  Created by Alexander on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BossShipEurope.h"


@implementation BossShipEurope

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    if((self = [super initWithBossID:kBoss_Europe initialLocation:aPoint andPlayerShipRef:playerRef])) {
        
    }
    
    return self;
}

- (void)update:(GLfloat)delta {
    
}

@end
