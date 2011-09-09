//
//  MiniBossGeneral.m
//  Xenophobe
//
//  Created by Alexander on 10/20/10.
//  Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
//  

#import "MiniBossGeneral.h"


@implementation MiniBossGeneral

- (id)initWithBossID:(BossShipID)aBossID initialLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)aPlayerShip {
    self = [super initWithBossID:aBossID initialLocation:aPoint andPlayerShipRef:aPlayerShip];
    if(self){
        
    }
    return self;
}

- (void)update:(GLfloat)delta {
    [super update:delta];
}

- (void)setDesiredLocation:(CGPoint)aPoint {
    [super setDesiredLocation:aPoint];
}

- (void)hitModule:(int)module withDamage:(int)damage {
    [super hitModule:module withDamage:damage];
}

- (void)playAllProjectiles {
    [super playAllProjectiles];
}

- (void)pauseAllProjectiles {
    [super pauseAllProjectiles];
}

- (void)stopAllProjectiles {
    [super stopAllProjectiles];
}

- (void)render {
    [super render];
}

@end
