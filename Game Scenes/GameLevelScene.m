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
//  Last Updated - 6/21/11 @8PM - Alexander
//  - Began implementing tasks necessary to load
//  level files. Moved other tasks from GameScene
//  to this class such as collisions and health
//
//  Last Updated - 6/22/11 @8PM - Alexander
//  - Collision detection between playership and
//  the entities in the enemiesSet
//  - Preliminary wave-loading methods
//
//  Last Updated - 6/22/11 @10:30PM - Alexander
//  - Very early, buggy test of removing enemies from
//  the enemiesSet when the player collides into them
//  (Not realistic, but for testing purposes).
//
//  Last Updated - 6/23/2011 @ 3:30PM - James
//  - Added enemy bullet -> player collision and
//  player bullet -> enemy collision
//
//  Last Updated - 6/23/2011 @ 3:45PM - James
//  - MAde it so enemies are only removed when death animation emitters are completed
//
//  Last updated - 6/23/11 @ 5PM - Alexander
//  - Typo in the enemy enum converter. Also set the default
//  return value to -1 so that we can tell if a problem
//  like this occurs again.
//
//  Last Updated - 6/12/11 @ 6:45PM - Alexander
//  - Just added and removed some comments. Cleanup.
//
//  Last Updated - 6/23/2011 @ 7:45PM - James
//  - Moved particles, from projectiles, off screen
//  when hitting enemy/player ships


#import "GameLevelScene.h"


@implementation GameLevelScene

@synthesize delegate, playerShip;

- (id)initWithLevelFile:(NSString *)levelFile withDelegate:(id <GameLevelDelegate>)del {
    if((self = [super init])){		
        // Grab the bounds of the screen
		screenBounds = [[UIScreen mainScreen] bounds];
        
        settings = [NSUserDefaults standardUserDefaults];
        
        delegate = del;
        
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
        
        wavesArray = [levelDictionary objectForKey:@"kWaves"];
        numWaves = [wavesArray count];
        currentWave = 0;
        
        enemiesSet = [[NSMutableSet alloc] init];
        
        [self loadWave:currentWave];
        
        playerShip = [[PlayerShip alloc] initWithShipID:kPlayerShip_Dev andInitialLocation:CGPointMake(155, 40)];
    }
    
    return self;
}

- (EnemyShipID)convertToEnemyEnum:(NSString *)enemyString {
    if([enemyString isEqualToString:@"kShipOneShot_One"]) {
        return kEnemyShip_OneShotLevelOne;
    }
    else if([enemyString isEqualToString:@"kShipTwoShot_One"]) {
        return kEnemyShip_TwoShotLevelOne;
    }
    else if([enemyString isEqualToString:@"kEnemyMissileBombLevel_Three"]) {
        return kEnemyShip_MissileBombShotLevelThree;
    }
    
    return -1;
}

- (void)loadWave:(int)wave {
    for(int i = 0; i < [[wavesArray objectAtIndex:wave] count]; ++i) {
        EnemyShip *enemy = [[EnemyShip alloc] initWithShipID:[self convertToEnemyEnum:[[wavesArray objectAtIndex:wave] objectAtIndex:i]] initialLocation:CGPointMake(100.0f + (50 * RANDOM_MINUS_1_TO_1()), 300.0f + (50 * RANDOM_MINUS_1_TO_1())) andPlayerShipRef:playerShip];
        
        [enemiesSet addObject:enemy];
    }
}

- (void)update:(GLfloat)aDelta {
    //Make sure that all of our ship objects get their update: called. Necessary.
    [playerShip update:aDelta];
    
    // Loop through our enemies and remove those that have died and whose
    // destruction animations have completed
    NSMutableSet *discardedEnemies = [[NSMutableSet alloc] init];
    for(EnemyShip *enemyShip in enemiesSet){
        [enemyShip update:aDelta];
        
        if(enemyShip.shipIsDead && enemyShip.deathAnimationEmitter.particleCount == 0){
            [discardedEnemies addObject:enemyShip];
        }
    }
    [enemiesSet minusSet:discardedEnemies];
    [discardedEnemies release];
    
    [self updateCollisions];
    
    if([enemiesSet count] == 0) {
        if(currentWave != (numWaves - 1)) {
            currentWave++;
            [self loadWave:currentWave];
        }
        else {
            [delegate levelEnded];
        }
    }
}

- (void)updateCollisions {    
    // First check direct ship-ship collisions between the player and enemies
    EnemyShip *enemyShip;
    for (enemyShip in enemiesSet) {
        PolygonCollisionResult result = [Collisions polygonCollision:playerShip.collisionPolygon :enemyShip.collisionPolygon :Vector2fZero];
                
        if(result.intersect) {
            NSLog(@"Collision occured with enemy ship");
            [enemyShip killShip];
        }
        
        //Enemy bullet -> player ship collision
        for(AbstractProjectile *enemyProjectile in enemyShip.projectilesArray){
            Polygon *enemyBulletPoly;
            for(int i = 0; i < [enemyProjectile.polygonArray count]; i++){
                enemyBulletPoly = [enemyProjectile.polygonArray objectAtIndex:i];
                PolygonCollisionResult result2 = [Collisions polygonCollision:enemyBulletPoly :playerShip.collisionPolygon :Vector2fZero];
                
                if(result2.intersect){
                    NSLog(@"Collision occured between enemy bullet and player ship");
                    if(!playerShip.shipIsDead){
                        [playerShip hitShipWithDamage:50];
                        enemyProjectile.emitter.particles[i].position = Vector2fMake(500, 0);
                    }
                }
            }
        }
        
        //Player Bullets->Enemy ship collision
        for(AbstractProjectile *playerShipProjectile in playerShip.projectilesArray){
            Polygon *playerBulletPoly;
            for(int i = 0; i < [playerShipProjectile.polygonArray count]; i++){
                playerBulletPoly = [playerShipProjectile.polygonArray objectAtIndex:i];
                PolygonCollisionResult result = [Collisions polygonCollision:playerBulletPoly :enemyShip.collisionPolygon :Vector2fZero];
                    
                if(result.intersect){
                    NSLog(@"Collision occured between player bullet and enemy ship");
                    //Send damage to enemy ship
                    if(!enemyShip.shipIsDead){
                        [enemyShip hitShipWithDamage:50];
                        playerShipProjectile.emitter.particles[i].position = Vector2fMake(500, 50);
                    }
                }
            }
        }
    }
    [enemyShip release];
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
    for (EnemyShip *enemyShip in enemiesSet) {
        [enemyShip render];
    }
    
    // Must always be rendered last so that the player is foreground
    // to any other objects on the screen.
    [playerShip render];
}

@end
    