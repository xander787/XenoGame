//
//  PowerUp.m
//  Xenophobe
//
//  Created by James Linnell on 7/23/11.
//  Copyright 2011 PDHS. All rights reserved.
//
//  Last Updated - 7/23/11 @6:10PM - James
//  - Adjusted magnet speed

#import "Drop.h"

@implementation Drop

@synthesize dropType, timeAlive, magnetActivated, location;

- (id)initWithDropType:(DropType)type position:(Vector2f)position andPlayerShipRef:(PlayerShip *)aPlayerShip {
    
    self = [super init];
    if (self) {
        location = position;
        playerShipRef = aPlayerShip;
        
        switch (type) {
            case kDropType_Credit:
            {
                dropImage = [[Image alloc] initWithImage:@"Credit.png" scale:Scale2fMake(1, 1)];
                break;
            }
                
            case kDropType_Shield:
            {
                break;
            }
                
            case kDropType_DamageMultiplier:
            {
                break;
            }
                
            case kDropType_ScoreMultiplier:
            {
                break;
            }
                
            case kDropType_EnemyRepel:
            {
                break;
            }
                
            case kDropType_DropsMagnet:
            {
                break;
            }
                
            case kDropType_Slowmo:
            {
                break;
            }
                
            case kDropType_ProximityDamage:
            {
                break;
            }
                
            case kDropType_Health:
            {
                break;
            }
                
            case kDropType_Nuke:
            {
                break;
            }
                
            default:
                break;
        }
    }
    
    return self;
}

- (void)update:(GLfloat)delta {
    timeAlive += delta;
    if(magnetActivated){
        location.x += ((playerShipRef.currentLocation.x - location.x) / 3) * (pow(1.584893192, 1)) * delta / 2;
        location.y += ((playerShipRef.currentLocation.y - location.y) / 3) * (pow(1.584893192, 1)) * delta / 2;
    }
}

- (void)render {
    [dropImage renderAtPoint:CGPointMake(location.x, location.y) centerOfImage:YES];
}

@end
