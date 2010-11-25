//
//  BossShip.h
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
//	Last Updated - 11/6/2010 - Alexander
//	- Initial Class Creation

#import <Foundation/Foundation.h>
#import "AbstractShip.h"
#import "Image.h"
#import "Animation.h"
#import "SpriteSheet.h"

typedef enum _BossType {
    kBossType_Mini = 0,
    kBossType_Full
} BossType;

typedef enum _BossShipID {
    kBoss_NorthAmerika = 0,
    kBoss_SouthAmerika,
    kBoss_Africa,
    kBoss_Asia,
    kBoss_Australia,
    kBoss_Antarctica,
    kBoss_Europe,
    kBoss_Earth,
    kMiniBoss_LosAngeles,
    kMiniBoss_SanFrancisco,
    kMiniBoss_MtRushmore,
    kMiniBoss_Chicago,
    kMiniBoss_NewYork,
    kMiniBoss_MexicoCity,
    kMiniBoss_AmazonRiver,
    kMiniBoss_Santiago,
    kMiniBoss_BeunosAires,
    kMiniBoss_Sahara,
    kMiniBoss_Johannesburg,
    kMiniBoss_Cairo,
    kMiniBoss_Baghdad,
    kMiniBoss_NewDelhi,
    kMiniBoss_HongKong,
    kMiniBoss_Beijing,
    kMiniBoss_Tokyo,
    kMiniBoss_Jakarta,
    kMiniBoss_Outback,
    kMiniBoss_Melbourne,
    kMiniBoss_Sydney,
    kMiniBoss_AntarcticPeninsula,
    kMiniBoss_SouthPole,
    kMiniBoss_Moscow,
    kMiniBoss_Madrid,
    kMiniBoss_Berlin,
    kMiniBoss_Paris,
    kMiniBoss_London
} BossShipID;

typedef enum _WeaponType {
    kWeapon_Turret = 0,
    kWeapon_Cannon,
    kWeapon_Wave,
    kWeapon_Laser
} WeaponType;

typedef struct _WeaponObject {
    WeaponType  weaponType;
    Vector2f    *weaponCoord;
} WeaponObject;

typedef struct _ModularObject {
    WeaponObject    *weapons;
    BOOL            floating;
    int             positionFloatVariance;
    Vector2f        *thrusterPoints;
} ModularObject;


@interface BossShip : AbstractShip {

}

@end
