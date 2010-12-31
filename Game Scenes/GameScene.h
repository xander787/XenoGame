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

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "Image.h"
#import "PlayerShip.h"
#import "EnemyShip.h"
#import "BossShip.h"
#import "Collisions.h"

@interface GameScene : AbstractScene {
    PlayerShip	*testShip;
    EnemyShip   *testEnemy;
    BossShip    *testBoss;
    
    NSSet       *enemySet;
    
    BOOL        touchOriginatedFromPlayerShip;
    
    NSMutableArray  *enemyPolygons;
    Polygon         *playerPolygon;
    Polygon         *testPolygon;
}

@end
