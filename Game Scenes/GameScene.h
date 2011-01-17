//
//  GameScene.h
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
//  Last Updated - 12/31/2010 @11AM - Alexander
//  - Added projectilesSet and bossesSet NSSet's
//  to hold projectiles and bosses currently in play

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "Image.h"
#import "PlayerShip.h"
#import "EnemyShip.h"
#import "BossShip.h"
#import "Collisions.h"
#import "AngelCodeFont.h"
#import "AbstractProjectile.h"

@interface GameScene : AbstractScene {
    PlayerShip	*testShip;
    EnemyShip   *testEnemy;
    BossShip    *testBoss;
        
    AbstractProjectile *bulletTest;
    
    // Storing objects in play
    NSSet       *enemiesSet;
    NSSet       *projectilesSet;
    NSSet       *bossesSet;
    
    // Controlling the player ship
    BOOL        touchOriginatedFromPlayerShip;
    BOOL        touchFromSecondShip;
}

@end
