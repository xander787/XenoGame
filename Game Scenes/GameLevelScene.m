//
//  GameLevelScene.m
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
//  Last Updated - 1/31/20101 @8PM - Alexander
//  - Began implementing tasks necessary to load
//  level files. Moved other tasks from GameScene
//  to this class such as collisions and health


#import "GameLevelScene.h"


@implementation GameLevelScene

@synthesize delegate, playerShip;

- (id)initWithLevelFile:(NSString *)levelFile withDelegate:(id <GameLevelDelegate>)del {
    if((self = [super init])){		
        // Grab the bounds of the screen
		screenBounds = [[UIScreen mainScreen] bounds];
        
        settings = [NSUserDefaults standardUserDefaults];
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [[NSString alloc] initWithString:[bundle pathForResource:levelFile ofType:@"plist"]];
        levelDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [bundle release];
        [path release];
        
        if([[levelDictionary objectForKey:@"kLevelType"] isEqualToString:@"kMiniBossLevel"]) {
            levelType = kLevelType_MiniBoss;
        }
        else if([[levelDictionary objectForKey:@"kLevelType"] isEqualToString:@"kBossLevel"]) {
            levelType = kLevelType_Boss;
            if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kBossAtlas"]) {
                bossShip = [[BossShipAtlas alloc] initWithLocation:CGPointMake(0.0f, 0.0f) andPlayerShipRef:playerShip];
            }
        }
        else if([[levelDictionary objectForKey:@"kLevelType"] isEqualToString:@"kCutsceneLevel"]) {
            levelType = kLevelType_Cutscene;
        }
        
        playerShip = [[PlayerShip alloc] initWithShipID:kPlayerShip_Dev andInitialLocation:CGPointMake(155, 200)];
    }
    
    return self;
}

- (void)update:(GLfloat)aDelta {
    //Make sure that all of our ship objects get their update: called. Necessary.
    [playerShip update:aDelta];
}

- (void)updateCollisions {
    
    //So far we only check for collisions between the 1st ship and 2nd ship.
    //When dealing with more obejcts, such as Enemies, we will loop through the NSSet's of loaded enemies.
    
    //result is a struct, containing intersect, willIntersect, and minimumTranslationVector.
    //We will only be using intersect, as the other two are used for moving against polygons, not simple collisions.
    //PolygonCollisionResult result = [Collisions polygonCollision:testShip.collisionPolygon :testEnemy.collisionPolygon :Vector2fZero];
    
   // if(result.intersect) NSLog(@"First Ship: Intersected");
    
    
    //Collision for a single enemy, same as above.
    //result = [Collisions polygonCollision:testShip.collisionPolygon :testEnemy.collisionPolygon :Vector2fZero];
    
    //if(result.intersect) NSLog(@"Enemy hit");
}

- (void)updateWithTouchLocationBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
    
    
    //Gets a frame of the first player ship, adding a bit of width and
    //30 pixels worth of height on the bottom half for ease of selection
    CGRect shipFrame = CGRectMake(playerShip.currentLocation.x - ((playerShip.shipWidth * 1.4) / 2),
                                  playerShip.currentLocation.y - (playerShip.shipHeight / 2) - 30,
                                  playerShip.shipWidth * 1.4,
                                  playerShip.shipHeight + 30);
    
    
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
        if(location.x - ([playerShip shipWidth] / 2) < 0){
            location.x = [playerShip shipWidth] / 2;
        }
        if(location.x + ([playerShip shipWidth] / 2) > screenBounds.size.width){
            location.x = screenBounds.size.width - ([playerShip shipWidth] / 2);
        }
        
        if(location.y - ([playerShip shipHeight] / 2) < 0){
            location.y = [playerShip shipHeight] / 2;
        }
        if(location.y + ([playerShip shipHeight] / 2) > screenBounds.size.height){
            location.y = screenBounds.size.height - ([playerShip shipHeight] / 2);
        }
        [playerShip setDesiredLocation:location];
    }    
}

- (void)render {
    [playerShip render];
}

@end
    