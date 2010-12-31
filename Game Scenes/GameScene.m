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
//
//  Last Updated - 12/30/2010 @ 8PM - James
//  - Polygon successfuly moves with testShip, and a
//  test triangle is drawn and ready for collision testing
//
//  Last Updated - 12/30/2010 @ 9PM - James
//  - Added in a second ship for better collision testing,
//  everyhting seems A-okay :D, also took out the triangle

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
    testEnemy = [[EnemyShip alloc] initWithShipID:kEnemyShip_MissileBombShotLevelThree initialLocation:CGPointMake(255, 300) andPlayerShipRef:testShip];
//  testBoss = [[BossShip alloc] initWithBossID:kBoss_Asia initialLocation:CGPointMake(155, 330) andPlayerShipRef:testShip];
    enemySet = [[NSSet alloc] initWithObjects:testEnemy, nil];    
    
    //Setup the polygon for PlayerShip
    playerPolygon = [[Polygon alloc] initWithPoints:[testShip collisionDetectionBoundingPoints] andCount:[testShip collisionPointsCount] andShipPos:[testShip currentLocation]];
    
    //Second ship
    secondTestShip = [[PlayerShip alloc] initWithShipID:kPlayerShip_Dev andInitialLocation:CGPointMake(155, 270)];
    secondPlayerPoly = [[Polygon alloc] initWithPoints:[secondTestShip collisionDetectionBoundingPoints] andCount:[testShip collisionPointsCount] andShipPos:[testShip currentLocation]];
    
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
    [playerPolygon setPos:testShip.currentLocation];
    [secondPlayerPoly setPos:secondTestShip.currentLocation];
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
    
    vel = CGPointZero;
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
    location.y += 30;
    if(touchOriginatedFromPlayerShip){
        CGPoint oldShipPt = testShip.currentLocation;
        [testShip setDesiredLocation:location];
        CGPoint newShipPt = testShip.desiredPosition;
        vel = CGPointMake(newShipPt.x - oldShipPt.x, newShipPt.y - oldShipPt.y);    
    }
    if(touchFromSecondShip){
        CGPoint oldShipPt = secondTestShip.currentLocation;
        [secondTestShip setDesiredLocation:location];
        CGPoint newShipPt = secondTestShip.desiredPosition;
        vel2 = CGPointMake(newShipPt.x - oldShipPt.x, newShipPt.y - oldShipPt.y);    
    }
}

- (void)updateCollisions {
    //Collisions for 1st ship -> second ship
    PolygonCollisionResult result = [Collisions polygonCollision:playerPolygon :secondPlayerPoly :Vector2fMake(vel.x, vel.y)];
    
    if(result.willIntersect){
        vel = CGPointMake(vel.x + result.minimumTranslationVector.x, vel.y + result.minimumTranslationVector.y);
        NSLog(@"First Ship: Will Intersect");
    }
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
    
    
    
    //Draw lines over polygons
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    
    glPushMatrix();
    
    //Ship one
    const GLfloat line1[] = {
        playerPolygon.points[0].x, playerPolygon.points[0].y, //point A
        playerPolygon.points[1].x, playerPolygon.points[1].y, //point B
    };
    
    const GLfloat line2[] = {
        playerPolygon.points[1].x, playerPolygon.points[1].y, //point A
        playerPolygon.points[2].x, playerPolygon.points[2].y, //point B
    };
    
    const GLfloat line3[] = {
        playerPolygon.points[2].x, playerPolygon.points[2].y, //point A
        playerPolygon.points[3].x, playerPolygon.points[3].y, //point B
    };
    
    const GLfloat line4[] = {
        playerPolygon.points[3].x, playerPolygon.points[3].y, //point A
        playerPolygon.points[0].x, playerPolygon.points[0].y, //point B
    };
    
    
    //Second Ship
    const GLfloat line8[] = {
        secondPlayerPoly.points[0].x, secondPlayerPoly.points[0].y, //point A
        secondPlayerPoly.points[1].x, secondPlayerPoly.points[1].y, //point B
    };
    
    const GLfloat line9[] = {
        secondPlayerPoly.points[1].x, secondPlayerPoly.points[1].y, //point A
        secondPlayerPoly.points[2].x, secondPlayerPoly.points[2].y, //point B
    };
    
    const GLfloat line10[] = {
        secondPlayerPoly.points[2].x, secondPlayerPoly.points[2].y, //point A
        secondPlayerPoly.points[3].x, secondPlayerPoly.points[3].y, //point B
    };
    
    const GLfloat line11[] = {
        secondPlayerPoly.points[3].x, secondPlayerPoly.points[3].y, //point A
        secondPlayerPoly.points[0].x, secondPlayerPoly.points[0].y, //point B
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
    
    //Second ship
    glVertexPointer(2, GL_FLOAT, 0, line8);
    glDrawArrays(GL_LINES, 0, 2);
    glVertexPointer(2, GL_FLOAT, 0, line9);
    glDrawArrays(GL_LINES, 0, 2);
    glVertexPointer(2, GL_FLOAT, 0, line10);
    glDrawArrays(GL_LINES, 0, 2);
    glVertexPointer(2, GL_FLOAT, 0, line11);
    glDrawArrays(GL_LINES, 0, 2);
    
    
    glPopMatrix();    
}

@end
