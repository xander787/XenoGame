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
//  Last Updated - 12/30/2010 @ 9PM - James
//  - Added in a second ship for better collision testing,
//  everyhting seems A-okay :D, also took out the triangle
//
//  Last Updated - 12/31/2010 @ 10AM - Alexander
//  - Removed a lot of uncessary crap, moved the polygon
//  init stuff out of here, also removed the line drawing
//  code out.
//
//  Last Updated - 12/31/2010 @ 7:30PM - Alexander
//  - Memory management: added dealloc method and use it
//  to deallocate our objects
//
//  Last Updated - 1/1/11 @ 9:50PM - James
//  - Made the testShip follow the bounds of the screen
//  and made selecting the bottom part of the testShip easier
//
//  Last Updated - 1/3/11 @5PM - Alexander
//  - Moved a lot of external code to the polygon and internalized
//  it into the class of the ships to make it more organized.
//
//  Last Updatd - 1/5/11 @12:30AM - Alexander
//  - Added really quick code to the render function that will
//  print the game's framerate if DEBUG is set to on, thus helping
//  us track performance later in development.
//
//  Last Updated - 5/29/11 @ 4PM - James
//  - Changed the usage of testShip.boundingBox to .shipWidth/Height
//  Note: boudingBox should be deprecated
//
//  Last Updated - 6/13/11 @3PM - Alexander
//  - Added starry background, and score string. Both are currently
//  rendering
//

#import "GameScene.h"

@interface GameScene(Private)
- (void)initGameScene;
- (void)initSound;
- (void)updateCollisions;
@end

@implementation GameScene

- (id)init {
	if ((self = [super init])) {
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
    testEnemy = [[EnemyShip alloc] initWithShipID:kEnemyShip_WaveShotLevelFour initialLocation:CGPointMake(255, 300) andPlayerShipRef:testShip];
    testBoss = [[BossShipAsia alloc] initWithLocation:CGPointMake(160, 330) andPlayerShipRef:testShip];
    enemiesSet = [[NSSet alloc] initWithObjects:testEnemy, nil];    
    
    //Testing bullet
    bulletTest = [[AbstractProjectile alloc] initWithProjectileID:kPlayerProjectile_Wave fromTurretPosition:Vector2fMake(250, 200) andAngle:90 emissionRate:2];
    
    // In-game graphics
    font = [[AngelCodeFont alloc] initWithFontImageNamed:@"xenophobefont.png" controlFile:@"xenophobefont" scale:(1.0/3.0) filter:GL_LINEAR];
    
    backgroundParticleEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																				  position:Vector2fMake(160.0, 259.76)
																	sourcePositionVariance:Vector2fMake(373.5, 240.0)
																					 speed:0.1
																			 speedVariance:0.01
																		  particleLifeSpan:5.0
																  particleLifespanVariance:2.0
																					 angle:200.0
																			 angleVariance:0.0
																				   gravity:Vector2fMake(0.0, 0.0)
																				startColor:Color4fMake(1.0, 1.0, 1.0, 0.58)
																		startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
																			   finishColor:Color4fMake(0.5, 0.5, 0.5, 0.34)
																	   finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
																			  maxParticles:2000
																			  particleSize:3.0
																		finishParticleSize:3.0
																	  particleSizeVariance:1.3
																				  duration:-1
																			 blendAdditive:NO];
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
    
    // In-game graphics updating
    [backgroundParticleEmitter update:aDelta];
    playerScore = [NSString stringWithFormat:@"%09d", playerScoreNum];
    
    
    //Make sure that all of our ship objects get their update: called. Necessary.
    [testShip update:aDelta];
    [testEnemy update:aDelta];
    [testBoss update:aDelta];
    [bulletTest update:aDelta];
    
    //Our method to check all collisions between the main
    //player ship and all other objects with polygons
    [self updateCollisions];
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

    
    //Gets a frame of the first player ship, adding a bit of width and
    //30 pixels worth of height on the bottom half for ease of selection
    CGRect shipFrame = CGRectMake(testShip.currentLocation.x - ((testShip.shipWidth * 1.4) / 2),
                                  testShip.currentLocation.y - (testShip.shipHeight / 2) - 30,
                                  testShip.shipWidth * 1.4,
                                  testShip.shipHeight + 30);
    
    
    //If the ship was actually selected, set a Bool for the
    //updateWithTouchLocationMoved: method to allow the ship to move
    if(CGRectContainsPoint(shipFrame, location)){
        NSLog(@"Touched on Ship :D");
        touchOriginatedFromPlayerShip = YES;
    }
    else {
        touchOriginatedFromPlayerShip = NO;
    }
}

- (void)updateWithTouchLocationMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
        
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
    location.y += 30;
    if(touchOriginatedFromPlayerShip){
        //Checks the edges of the ship against the edges of the screen.
        //Note: we check one edge at a time because if we simply use CGRectContainsRect,
        //the ship would not be able to move along an edge once exiting
        if(location.x - ([testShip shipWidth] / 2) < 0){
            location.x = [testShip shipWidth] / 2;
        }
        if(location.x + ([testShip shipWidth] / 2) > _screenBounds.size.width){
            location.x = _screenBounds.size.width - ([testShip shipWidth] / 2);
        }
        
        if(location.y - ([testShip shipHeight] / 2) < 0){
            location.y = [testShip shipHeight] / 2;
        }
        if(location.y + ([testShip shipHeight] / 2) > _screenBounds.size.height){
            location.y = _screenBounds.size.height - ([testShip shipHeight] / 2);
        }
        [testShip setDesiredLocation:location];
    }
    
}

- (void)updateCollisions {
    
    //So far we only check for collisions between the 1st ship and 2nd ship.
    //When dealing with more obejcts, such as Enemies, we will loop through the NSSet's of loaded enemies.
    
    //result is a struct, containing intersect, willIntersect, and minimumTranslationVector.
    //We will only be using intersect, as the other two are used for moving against polygons, not simple collisions.
    PolygonCollisionResult result = [Collisions polygonCollision:testShip.collisionPolygon :testEnemy.collisionPolygon :Vector2fZero];
    
    if(result.intersect) NSLog(@"First Ship: Intersected");
    
    
    //Collision for a single enemy, same as above.
    result = [Collisions polygonCollision:testShip.collisionPolygon :testEnemy.collisionPolygon :Vector2fZero];
    
    if(result.intersect) NSLog(@"Enemy hit");
}

- (void)updateWithAccelerometer:(UIAcceleration *)aAcceleration {
    
}

- (void)transitionToSceneWithKey:(NSString *)aKey {
	sceneState = kSceneState_TransitionOut;
}

- (void)render {
    // In-game graphics rendered first
    [backgroundParticleEmitter renderParticles];
    [font drawStringAt:CGPointMake(10.0, 465.0) text:playerScore];
    
    [testBoss render];
    [testEnemy render];
    [testShip render];
    
    if(DEBUG) {
        
        //Draw some text at the bottom-left corner indicating the current FPS.
        [font drawStringAt:CGPointMake(15.0, 15.0) text:[NSString stringWithFormat:@"%.1f", [_sharedDirector framesPerSecond]]];
    }
}

- (void)dealloc {
    [testShip release];
    [testEnemy release];
    [testBoss release];
    [font release];
    //[bulletTest release];
    [enemiesSet release];
    [projectilesSet release];
    [bossesSet release];
    [super dealloc];
}

@end
