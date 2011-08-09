//
//  ParticleProjectile.h
//  Xenophobe
//
//  Created by James Linnell on 8/5/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "AbstractProjectile.h"

@interface ParticleProjectile : AbstractProjectile {
    int             radius;
    CGPoint         particleVector0;
    CGPoint         particleVector1;
    CGPoint         particleVector2;
}

- (id)initWithProjectileID:(ProjectileID)aProjID location:(Vector2f)aLocation angle:(GLfloat)aAngle radius:(float)aRadius andFireRate:(GLfloat)aRate;
- (void)update:(GLfloat)aDelta;
- (void)render;
- (void)pauseProjectile;
- (void)playProjectile;
- (void)stopProjectile;
- (ParticleEmitter *)newParticleEmitter;
- (NSArray *)newArrayWithPolygon;

@end