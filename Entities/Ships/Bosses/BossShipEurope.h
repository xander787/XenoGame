//
//  BossShipEurope.h
//  Xenophobe
//
//  Created by Alexander on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BossShip.h"


@interface BossShipEurope : BossShip {
    
}

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef;
- (void)update:(GLfloat)delta;

@end
