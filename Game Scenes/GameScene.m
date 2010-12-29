//
//  GameScene.m
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
//	Last Updated - 11/28/2010 @ 8PM - Alexander
//	- Added in a few methods that we'll need later
//
//	Last Updated - 11/21/2010 @ 11AM - Alexander
//	- Added in testing code for the player ship in here
//
//	Last Updated - 11/22/2010 @12AM - Alexander
//	- Added in first test code for moving the ship
//  by passing it coords from the touches received on this
//  scene
//
//  Last Updated - 11/23/2010 @2:15PM - James
//  - Fixed small bug with change from changing the player
//  ship reference in Enemy to a single pointer, initialization
//  was still using &testShip.
//
//  Last Updated - 12/17/10 @6PM - James
//  - Added restriction of only being able to move the
//  Player ship if the user touched in the bounds of
//  the Player ship initially.
//
//  Last Updated - 12/23/10 @ 9:15PM - James
//  - Added an NSSet for enemies loaded into memory,
//  started basic use of DidCollide (form Common.h)
//  to detect player vs. enemy collision
//
//	Last Updated - 12/29/2010 @ 12PM - Alexander
//	- Moved test ship and other rendering here from
//  the settings scene so we can begin setting up
//  the class to handle the actual game.

#import "GameScene.h"

@interface GameScene(Private)
- (void)initGameScene;
- (void)initSound;
@end

@implementation GameScene

- (id)init {
	if (self = [super init]) {
        // Get an instance of the singleton classes
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
		
        // Grab the bounds of the screen
		_screenBounds = [[UIScreen mainScreen] bounds];
        
        _sceneFadeSpeed = 1.0f;
        
        // Init sound
        [self initGameScene];
        [self initSound];
	}
	
	return self;
}

- (void)initSound {
    
}

- (void)initGameScene {
    testShip = [[PlayerShip alloc] initWithShipID:kPlayerShip_Dev andInitialLocation:CGPointMake(155, 200)];
    testEnemy = [[EnemyShip alloc] initWithShipID:kEnemyShip_MissileBombShotLevelThree initialLocation:CGPointMake(255, 300) andPlayerShipRef:testShip];
//  testBoss = [[BossShip alloc] initWithBossID:kBoss_Asia initialLocation:CGPointMake(155, 330) andPlayerShipRef:testShip];
    enemySet = [[NSSet alloc] initWithObjects:testEnemy, nil];
}

- (void)updateWithDelta:(GLfloat)aDelta {
	switch (sceneState) {
        case kSceneState_Running:
            break;
        case kSceneState_TransitionIn:
            sceneAlpha += _sceneFadeSpeed * aDelta;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
            if(sceneAlpha >= 1.0f) {
                sceneAlpha = 1.0f;
                sceneState = kSceneState_Running;
            }
            break;
        default:
            break;
    }
    
    [testShip update:aDelta];
    [testEnemy update:aDelta];
//  [testBoss update:aDelta];
    
    //Collision Detection Loop
    for(EnemyShip* enemy in enemySet){
        if(didCollideRectangular(testShip.boundingBox, testShip.position, enemy.boundingBox, enemy.position, 0.1)){
            NSLog(@"Collided Rectangular");
        }
        if(didCollideCircular(testShip.position, testShip.imageWidth, enemy.position, enemy.imageWidth, 2)){
            NSLog(@"Collided Circular");
        }
    }
}

- (void)setSceneState:(uint)theState {
	sceneState = theState;
	if(sceneState == kSceneState_TransitionOut)
		sceneAlpha = 1.0f;
	if(sceneState == kSceneState_TransitionIn)
		sceneAlpha = 0.0f;
}

- (void)updateWithTouchLocationBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
    
    if(CGRectContainsPoint(CGRectMake(testShip.currentLocation.x - ((testShip.boundingBox.x * 1.4) / 2),
                                      testShip.currentLocation.y - (testShip.boundingBox.y / 2),
                                      testShip.boundingBox.x * 1.4,
                                      testShip.boundingBox.y),
                           location)){
        NSLog(@"Touched on Ship :D");
        touchOriginatedFromPlayerShip = YES;
    }
    else {
        touchOriginatedFromPlayerShip = NO;
    }
}

- (void)updateWithMovedLocation:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
    if(touchOriginatedFromPlayerShip){
        location.y += 30;
        [testShip setDesiredLocation:location];
    }
}

- (void)updateWithAccelerometer:(UIAcceleration *)aAcceleration {
    
}

- (void)transitionToSceneWithKey:(NSString *)aKey {
	sceneState = kSceneState_TransitionOut;
}

- (void)render {
    [testShip render];
    [testEnemy render];
//  [testBoss render];
}

@end
