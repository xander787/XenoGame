//
//  PowerUp.h
//  Xenophobe
//
//  Created by James Linnell on 7/23/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Image.h"
#import "PlayerShip.h"

typedef enum _DropType {
    kDropType_Credit = 0,
    kDropType_Shield,
    kDropType_DamageMultiplier,
    kDropType_ScoreMultiplier,
    kDropType_EnemyRepel,
    kDropType_DropsMagnet,
    kDropType_Slowmo,
    kDropType_ProximityDamage,
    kDropType_Health,
    kDropType_Nuke
} DropType;

@interface Drop : NSObject {
    DropType    dropType;
    GLfloat     timeAlive;
    Image       *dropImage;
    Vector2f    location;
    
    BOOL        magnetActivated;
    PlayerShip  *playerShipRef;
}

@property(readwrite) DropType dropType;
@property(readonly) GLfloat timeAlive;
@property(readwrite) BOOL magnetActivated;
@property(readonly) Vector2f location;

- (id)initWithDropType:(DropType)type position:(Vector2f)position andPlayerShipRef:(PlayerShip*)aPlayerShip;
- (void)update:(GLfloat)delta;
- (void)render;

@end
