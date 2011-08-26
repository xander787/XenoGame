//
//  HeatSeekingMissile.h
//  Xenophobe
//
//  Created by James Linnell on 8/25/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "AbstractProjectile.h"
#import "PlayerShip.h"

@interface HeatSeekingMissile : AbstractProjectile
{
    PlayerShip  *playerShipRef;
}

- (id)initWithProjectileID:(ProjectileID)aProjID location:(Vector2f)aLocation angle:(GLfloat)aAngle speed:(GLfloat)aSpeed rate:(GLfloat)aRate andPlayerShipRef:(PlayerShip *)aPlayerShipRef;
- (void)update:(GLfloat)aDelta;
- (void)render;
- (void)pauseProjectile;
- (void)playProjectile;
- (void)stopProjectile;

@end
