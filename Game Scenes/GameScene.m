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
    
    //Setup the polygon for PlayerShip
    playerPolygon = [[Polygon alloc] init];    
    playerPolygon.points = malloc(sizeof(Vector2f) * [testShip collisionPointsCount]);
    
    //Gets points fro mthe ship
    for(int i = 0; i < [testShip collisionPointsCount]; i++){
        playerPolygon.points[i] = Vector2fMake(testShip.collisionDetectionBoundingPoints[i].x, testShip.collisionDetectionBoundingPoints[i].y);
    }
    
    //So we don't have to manually put them in
    [playerPolygon buildEdges];
    
    //Test poly for collision testing
    /*testPolygon = [[Polygon alloc] init];
    testPolygon.points[0] = Vector2fMake(50, 50);
    testPolygon.points[1] = Vector2fMake(100, 0);
    testPolygon.points[2] = Vector2fMake(150, 150);
    [testPolygon buildEdges];*/
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

- (void)updateWithTouchLocationMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
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
    
    //Draw lines over polygons
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    
    glPushMatrix();
    
    glTranslatef(testShip.currentLocation.x, testShip.currentLocation.y, 0.0f);
    
    const GLfloat line1[] = {
        testShip.collisionDetectionBoundingPoints[0].x, testShip.collisionDetectionBoundingPoints[0].y, //point A
        testShip.collisionDetectionBoundingPoints[1].x, testShip.collisionDetectionBoundingPoints[1].y, //point B
    };
    
    const GLfloat line2[] = {
        testShip.collisionDetectionBoundingPoints[1].x, testShip.collisionDetectionBoundingPoints[1].y, //point A
        testShip.collisionDetectionBoundingPoints[2].x, testShip.collisionDetectionBoundingPoints[2].y, //point B
    };
    
    const GLfloat line3[] = {
        testShip.collisionDetectionBoundingPoints[2].x, testShip.collisionDetectionBoundingPoints[2].y, //point A
        testShip.collisionDetectionBoundingPoints[3].x, testShip.collisionDetectionBoundingPoints[3].y, //point B
    };
    
    const GLfloat line4[] = {
        testShip.collisionDetectionBoundingPoints[3].x, testShip.collisionDetectionBoundingPoints[3].y, //point A
        testShip.collisionDetectionBoundingPoints[4].x, testShip.collisionDetectionBoundingPoints[4].y, //point B
    };
    
    glVertexPointer(2, GL_FLOAT, 0, line1);
    glEnableClientState(GL_VERTEX_ARRAY);
    glDrawArrays(GL_LINES, 0, 2);
    
    glVertexPointer(2, GL_FLOAT, 0, line2);
    glDrawArrays(GL_LINES, 0, 2);

    glVertexPointer(2, GL_FLOAT, 0, line3);
    glDrawArrays(GL_LINES, 0, 2);
    
    glVertexPointer(2, GL_FLOAT, 0, line4);
    glDrawArrays(GL_LINES, 0, 2);
    
    glPopMatrix();    
}

@end
