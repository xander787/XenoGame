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

#import "GameScene.h"

//Macros form Cocos2D, used in example code
#define ccp(__X__,__Y__) CGPointMake(__X__,__Y__)
#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0f * (float)M_PI)

@interface GameScene(Private)
- (void)initChipmunk;
- (void)initGameScene;
- (void)initSound;

//Chipmunk
static int playerToEnemyCollision(cpArbiter *arb, cpSpace *space,  void *unused);
- (void)addBodiesToPlayerShip:(PlayerShip *)ship;
- (void)step:(GLfloat)delta;
static void eachShape(void *ptr, void* unused);
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
        [self initChipmunk];
        [self initGameScene];
        [self initSound];
        
        [self addBodiesToPlayerShip:testShip];
	}
	
	return self;
}

- (void)initChipmunk {
    // Window Size
    CGSize wins = CGSizeMake(100, 100);
	// Initialise Chipmunk
	cpInitChipmunk();
    
	// Create space.
	space = cpSpaceNew();
	cpSpaceResizeStaticHash(space, 400.0f, 40);
	cpSpaceResizeActiveHash(space, 100, 600);
	
	// Setup the gravity (Nil gravity)
	space->gravity = ccp(0, 0);
    
	//Update Chipmunk
    shouldStep = YES;
    
	
	// Initialize a static body with infinite mass and moment of inertia
	// to attach the static geometry to.
	cpBody * staticBody = cpBodyNew(INFINITY, INFINITY);
	cpShape *shape;
    
	// Create some segments around the edges of the screen.
	// bottom
	shape = cpSegmentShapeNew(staticBody, ccp(0,0), ccp(wins.width,0), 0.0f);
	shape->e = 1.0f; shape->u = 1.0f;
	cpSpaceAddStaticShape(space, shape);
	
	// top
	shape = cpSegmentShapeNew(staticBody, ccp(0,wins.height), ccp(wins.width,wins.height), 0.0f);
	shape->e = 1.0f; shape->u = 1.0f;
	cpSpaceAddStaticShape(space, shape);
	
	// left
	shape = cpSegmentShapeNew(staticBody, ccp(0,0), ccp(0,wins.height), 0.0f);
	shape->e = 1.0f; shape->u = 1.0f;
	cpSpaceAddStaticShape(space, shape);
	
	// right
	shape = cpSegmentShapeNew(staticBody, ccp(wins.width,0), ccp(wins.width,wins.height), 0.0f);
	shape->e = 1.0f; shape->u = 1.0f;
	cpSpaceAddStaticShape(space, shape);
	
	
	// Setup collisions
	// Collision between two sprites.
    //Hooks a function to the beginning of collisions, between players and enemies.
    cpSpaceAddCollisionHandler(space, 0, 1, (cpCollisionBeginFunc)playerToEnemyCollision, NULL, NULL, NULL, NULL);
}

- (void)initSound {
    
}

- (void)initGameScene {
    testShip = [[PlayerShip alloc] initWithShipID:kPlayerShip_Dev andInitialLocation:CGPointMake(155, 200)];
    testEnemy = [[EnemyShip alloc] initWithShipID:kEnemyShip_MissileBombShotLevelThree initialLocation:CGPointMake(255, 300) andPlayerShipRef:testShip];
//  testBoss = [[BossShip alloc] initWithBossID:kBoss_Asia initialLocation:CGPointMake(155, 330) andPlayerShipRef:testShip];
    enemySet = [[NSSet alloc] initWithObjects:testEnemy, nil];
}

/*** Chipmunk related functions ***/

static int playerToEnemyCollision(cpArbiter *arb, cpSpace *space,  void *unused)
{	
    cpShape *a, *b;
    cpArbiterGetShapes(arb, &a, &b);
    a->data = (PlayerShip *)a->data;
	NSLog(@"CP Collision detected: 1:%@\n2:%@", a->data, b->data);
	return 1;
}

- (void)addBodiesToPlayerShip:(PlayerShip *)ship {
    int num = 4;
	CGPoint verts[] = {
		ccp(-20,-20),
		ccp(-20, 20),
		ccp( 20, 20),
		ccp( 20,-20),
	};
	
	cpBody *body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, num, verts, CGPointZero));
	
	body->p = CGPointMake(ship.position.x, ship.position.y);
	cpSpaceAddBody(space, body);
	
	cpShape* shape = cpPolyShapeNew(body, num, verts, CGPointZero);
	shape->e = 0.5f; shape->u = 0.5f;
	shape->data = ship;
	shape->collision_type = 1;
	cpSpaceAddShape(space, shape);
}

static void eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	PlayerShip *sprite = shape->data;
	if( sprite ) {
		cpBody *body = shape->body;
		body->p = CGPointMake(sprite.position.x, sprite.position.y);
		cpBodySetAngle(body, -CC_DEGREES_TO_RADIANS(sprite.rotation));
	}
}

- (void)step:(GLfloat)delta {
	int steps = 2;
	cpFloat dt = delta/(cpFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
	cpSpaceHashEach(space->activeShapes, &eachShape, nil);
}

/*** End Chipmunk related functions ***/

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
    
    //For Chipmunk, refreshes hashes for updating
    if(shouldStep){
        [self step:aDelta];
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
}

@end
