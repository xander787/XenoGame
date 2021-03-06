//
//  WaveProjectile.h
//  Xenophobe
//
//  Created by James Linnell on 8/5/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "AbstractProjectile.h"

@interface WaveProjectile : AbstractProjectile {
    GLfloat     secondWaveTimer;
    GLfloat     thirdWaveTimer;
}

- (id)initWithProjectileID:(ProjectileID)aProjID location:(Vector2f)aLocation andAngle:(GLfloat)aAngle;
- (void)update:(GLfloat)aDelta;
- (void)render;
- (void)pauseProjectile;
- (void)playProjectile;
- (void)stopProjectile;
- (ParticleEmitter *)newWaveEmitterWithAngle:(GLfloat)aAngle;
- (NSArray *)newArrayOfPolygonsWithCount:(int)count;


@end
