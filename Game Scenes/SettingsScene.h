//
//  SettingsScene.h
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
//	Last Updated - 11/21/2010 @ 11AM - Alexander
//	- Added in testing code for the player ship in here

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "PlayerShip.h"
#import "EnemyShip.h"
#import "BossShip.h"


@interface SettingsScene : AbstractScene {
	PlayerShip	*testShip;
    EnemyShip   *testEnemy;
    BossShip    *testBoss;
    
    BOOL        touchOriginatedFromPlayerShip;
}

@end
