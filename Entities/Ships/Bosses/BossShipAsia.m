//
//  BossShipAsia.m
//  Xenophobe
//
//  Created by Alexander on 10/20/10.
//  Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
//  

#import "BossShipAsia.h"


@implementation BossShipAsia

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    if((self = [super initWithBossID:kBoss_Asia initialLocation:aPoint andPlayerShipRef:playerRef])){
        leftCannon = self.modularObjects[1];
        rightCannon = self.modularObjects[2];
    }
    return self;
}

- (void)update:(GLfloat)aDelta {
    
}

- (void)render {
    
}

- (void)dealloc {
    
    [super dealloc];
}

@end
