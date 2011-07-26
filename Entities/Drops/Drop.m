//
//  PowerUp.m
//  Xenophobe
//
//  Created by James Linnell on 7/23/11.
//  Copyright 2011 PDHS. All rights reserved.
//
//  Last Updated - 7/23/11 @6:10PM - James
//  - Adjusted magnet speed
//
//  Last Updated - 7/24/11 @2:15PM - James
//  - Accidentally forgot to set the dropType so correct type
//
//  Last Updated - 7/24/11 @3:15PM - James
//  - Made drops slowly move downwards to the bottom of
//  the screen, 50pixels per second
//
//  Last Updated - 7/24/11 @3:17PM - James
//  - Made sure magnet activated drops move at same speed
//
//  Last Updated - 7/24/11 @11PM - James
//  - Added more images and image loading

#import "Drop.h"

@implementation Drop

@synthesize dropType, timeAlive, magnetActivated, location;

- (id)initWithDropType:(DropType)type position:(Vector2f)position andPlayerShipRef:(PlayerShip *)aPlayerShip {
    
    self = [super init];
    if (self) {
        location = position;
        playerShipRef = aPlayerShip;
        dropType = type;
        
        switch (type) {
            case kDropType_Credit:
            {
                dropImage = [[Image alloc] initWithImage:@"Credit.png" scale:Scale2fOne];
                break;
            }
                
            case kDropType_Shield:
            {
                dropImage = [[Image alloc] initWithImage:@"Shield.png" scale:Scale2fOne];
                break;
            }
                
            case kDropType_DamageMultiplier:
            {
                dropImage = [[Image alloc] initWithImage:@"DamageMultiplier.png" scale:Scale2fOne];
                break;
            }
                
            case kDropType_ScoreMultiplier:
            {
                dropImage = [[Image alloc] initWithImage:@"ScoreMultiplier.png" scale:Scale2fOne];
                break;
            }
                
            case kDropType_EnemyRepel:
            {
                dropImage = [[Image alloc] initWithImage:@"EnemyRepel.png" scale:Scale2fOne];
                break;
            }
                
            case kDropType_DropsMagnet:
            {
                dropImage = [[Image alloc] initWithImage:@"Magnet.png" scale:Scale2fOne];
                break;
            }
                
            case kDropType_Slowmo:
            {
                dropImage = [[Image alloc] initWithImage:@"Slowmo.png" scale:Scale2fOne];
                break;
            }
                
            case kDropType_ProximityDamage:
            {
                dropImage = [[Image alloc] initWithImage:@"ProximityDamage.png" scale:Scale2fOne];
                break;
            }
                
            case kDropType_Health:
            {
                dropImage = [[Image alloc] initWithImage:@"Health.png" scale:Scale2fOne];
                break;
            }
                
            case kDropType_Nuke:
            {
                dropImage = [[Image alloc] initWithImage:@"Nuke.png" scale:Scale2fOne];
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
        location.x += ((playerShipRef.currentLocation.x - location.x) / 1) * (pow(1.584893192, 1)) * delta / 2;
        if(playerShipRef.currentLocation.y < location.y){
            location.y -= 50 * delta;
        }
        else {
            location.y += 50 * delta;
        }
    }
    else {
        location.y -= 50 * delta;
    }
    
    switch (dropType) {
        case kDropType_Credit:
        {
            break;
        }
        
        case kDropType_Shield:
        {
            break;
        }
            
        default:
            break;
    }
}

- (void)render {
    [dropImage renderAtPoint:CGPointMake(location.x, location.y) centerOfImage:YES];
}

@end
