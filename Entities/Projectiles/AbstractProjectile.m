//
//  AbstractProjectile.m
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
//	Last Updated - 1/26/2011 @ 5:20PM - Alexander
//  - Added ability to change location, and also added properties for
//  public vars
//
//  Last Updated - 1/18/2011 @10PM - Alexander
//  - Changed player bullet to fade and get smaller as the projectile
//  moves across the screen
//
//  Last Updated - 6/13/2011 @ 5:40PM - James
//  - Stopped rendering of all objects when projectile is
//  set to inactive.
//
//  Last Updated - 6/15/2011 @12:40PM - James
//  - Removed setFiring: method, added pauseProj, playProj, and stopProj
//  to differentiate between needs, play/pause for pause screen, stop for
//  not rendering projectile.
//
//	Last Updated - 6/15/2011 @ 3:30PM - Alexander
//	- Support for new Scale2f vector scaling system
//
//  Last updated - 6/22/2011 @ 11PM - James
//  - Deprecated missilePolygon and particlePolyon. Replaced with 
//  using the first(0th) polygon object in the polygonsArray
//
//  Last Updated - 6/23/2011 @ 3:30PM - James
//  - Forgot to allocate polygons for missiles and particles :\
//
//  Last Updated - 7/20/11 @5:40PM - James
//  - Adjusted size/speed of Player/Enemy bullets, enabled blend
//  additive, for bullets the emitter renders twice to get the blend additive
//  to look nice and bright.
//
//  Last Updated - 7/22/11 @5PM - James
//  - Made sure to move emitter bullets off screen when stopping projectile
//
//  Last updated - 7/26/11 @2PM - James
//  - Adjusted stopProjectile to stop them efficiently-er

#import "AbstractProjectile.h"


@implementation AbstractProjectile

@synthesize projectileID, angle, location, polygons, emitters;

- (id)initWithProjectileID:(ProjectileID)aProjID location:(Vector2f)aLocation andAngle:(GLfloat)aAngle {
    if((self = [super init])){
        
        projectileID = aProjID;
        location = aLocation;
        angle = aAngle;
        
        polygons = [[NSMutableArray alloc] init];
        emitters = [[NSMutableArray alloc] init];
        
        isActive = YES;
    }
    
    return self;
}

- (void)update:(CGFloat)aDelta {
    if(isActive == NO) return;
    elapsedTime += aDelta;    
}

- (void)pauseProjectile {
    //This merely tells the class to stop updating the projectiles, mainly for use on pause screen
    
    isActive = NO;
    
}

- (void)playProjectile {
    //Reverses the ffect of pauseProjectile, mainly for when pause screen goes away
    
    isActive = YES;
    for(ParticleEmitter *emitter in emitters){
        emitter.active = YES;
    }
    isStopped = NO;
}

- (void)stopProjectile {
    //Used when we want to stop updating AND rendering our projectile.
    //The owner of the class uses this so it doesn't have to deallocate the projectile on ship death
    isStopped = YES;
    for(ParticleEmitter *emitter in emitters){
        [emitter stopParticleEmitter];
    }
}

- (void)render {
    
}

- (void)dealloc {
    [super dealloc];
}

@end
