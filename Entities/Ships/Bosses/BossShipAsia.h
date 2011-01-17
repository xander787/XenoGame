//
//  BossShipAsia.h
//  Xenophobe
//
//  Created by Alexander on 10/20/10.
//  Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BossShip.h"


@interface BossShipAsia : BossShip {    
    ModularObject    leftCannon;
    ModularObject    rightCannon;
    
    
    float       angleFromLeftCannon;
    float       angleFromRightCannon;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;
- (void)update:(GLfloat)aDelta;

@end
