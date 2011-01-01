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
//
//  Last Updated - 12/29/2010 @ 5PM - James
//  - Fixed bug with the player not moving, misnamed
//  update method. And after a lot of messy code, basic
//  collision detection.
//
//  Last Updated - 12/30/2010 @ 3:PM - James
//  - Removed old and nasty Chipmunk code, started use 
//  of new Polygon code, small bug in trying to draw 
//  the polygons though.
//
//  Last Upated - 12/30/2010 @ 5PM - James
//  - Cleaned up a bit, started using [testShip collisionPointsCount]
//
//  Last Updated - 12/30/2010 @ 8PM - James
//  - Polygon successfuly moves with testShip, and a
//  test triangle is drawn and ready for collision testing
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
//  Last Updated - 12/31/2010 @7:30PM - Alexander
//  - Memory management: added dealloc method and use it
//  to deallocate our objects

#import "GameScene.h"

@interface GameScene(Private)
- (void)initGameScene;
- (void)initSound;
- (void)updateCollisions;
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
    testEnemy = [[EnemyShip alloc] initWithShipID:kEnemyShip_WaveShotLevelFour initialLocation:CGPointMake(255, 300) andPlayerShipRef:testShip];
//  testBoss = [[BossShip alloc] initWithBossID:kBoss_Asia initialLocation:CGPointMake(155, 330) andPlayerShipRef:testShip];
    enemiesSet = [[NSSet alloc] initWithObjects:testEnemy, nil];    
    
    //Setup the polygon for PlayerShip
    testShip.collisionPolygon = [[Polygon alloc] initWithPoints:[testShip collisionDetectionBoundingPoints] andCount:[testShip collisionPointsCount] andShipPos:[testShip currentLocation]];
    
    //Second ship
    secondTestShip = [[PlayerShip alloc] initWithShipID:kPlayerShip_Dev andInitialLocation:CGPointMake(155, 270)];
    secondTestShip.collisionPolygon = [[Polygon alloc] initWithPoints:[secondTestShip collisionDetectionBoundingPoints] andCount:[testShip collisionPointsCount] andShipPos:[testShip currentLocation]];
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
    [secondTestShip update:aDelta];
    
    [self updateCollisions];
    [testShip.collisionPolygon setPos:testShip.currentLocation];
    [secondTestShip.collisionPolygon setPos:secondTestShip.currentLocation];
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
    if(CGRectContainsPoint(CGRectMake(secondTestShip.currentLocation.x - ((secondTestShip.boundingBox.x * 1.4) / 2),
                                      secondTestShip.currentLocation.y - (secondTestShip.boundingBox.y / 2),
                                      secondTestShip.boundingBox.x * 1.4,
                                      secondTestShip.boundingBox.y),
                           location)){
        NSLog(@"Touched on Ship :D");
        touchFromSecondShip = YES;
    }
    else {
        touchFromSecondShip = NO;
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
        [testShip setDesiredLocation:location];
    }
    if(touchFromSecondShip){
        [secondTestShip setDesiredLocation:location];
    }
}

- (void)updateCollisions {
    //Collisions for 1st ship -> second ship
    PolygonCollisionResult result = [Collisions polygonCollision:testShip.collisionPolygon :secondTestShip.collisionPolygon :Vector2fZero];
    
    if(result.intersect){
        NSLog(@"First Ship: Intersected");
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
    [secondTestShip render];
}

- (void)dealloc {
    [testShip release];
    [testEnemy release];
    [testBoss release];
    [secondTestShip release];
    [enemiesSet release];
    [projectilesSet release];
    [bossesSet release];
    [super dealloc];
}

@end
