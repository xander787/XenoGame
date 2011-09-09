//
//  MiniBossGeneral.h
//  Xenophobe
//
//  Created by Alexander on 10/20/10.
//  Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import "BossShip.h"
#import "BezierCurve.h"


@interface MiniBossGeneral : BossShip {
    
}

- (id)initWithBossID:(BossShipID)aBossID initialLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)aPlayerShip;
- (void)setDesiredLocation:(CGPoint)aPoint;
- (void)hitModule:(int)module withDamage:(int)damage;
- (void)stopAllProjectiles;
- (void)pauseAllProjectiles;
- (void)playAllProjectiles;

@end
