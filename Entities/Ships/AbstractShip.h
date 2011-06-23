//
//  AbstractShip.h
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
//	Last Updated - 11/21/2010 - Alexander
//	- Added in methods for touch handling
//
//  Last Updated - 6/13/2011 @ 4PM - James
//  - Added hitShipWithDamage method for universal damage 
//  detection, with subclasses defining the method.
//
//  Last Updated - 6/15/2011 @1:10PM - James
//  - Added global variables that were each being defined in all
//  the subclasses. Better organization.
//  Last updated - 6/23/2011 @ 3:45PM - James
//  - Synthesized the death emitter

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Animation.h"
#import "PhysicalObject.h"
#import "Polygon.h"
#import "ParticleEmitter.h"

@class GameScene;

@interface AbstractShip : PhysicalObject {
	Director                            *_sharedDirector;
	BOOL                                _gotScene;
    
    //Global variables for Player, Enemy, and Boss ships
    
    BOOL                                shipIsDead;
    int									shipHealth;
    int                                 shipMaxHealth;
    
	int									shipAttack;
	int									shipStamina;
	int									shipSpeed;
    
    int                                 shipWidth;
    int                                 shipHeight;
    CGPoint                             currentLocation;
    
    Polygon                             *collisionPolygon;
    Vector2f                            *collisionDetectionBoundingPoints;
    int                                 collisionPointsCount;
    
    Vector2f							*turretPoints;
    int                                 numTurrets;
    
	Vector2f                            *thrusterPoints;
    int                                 numThrusters;
    
    NSMutableArray                      *projectilesArray;
    
    ParticleEmitter                     *deathAnimationEmitter;

}

@property (readonly) BOOL shipIsDead;
@property (readonly) int shipHealth;
@property (readonly) int shipMaxHealth;
@property (readonly) int shipAttack;
@property (readonly) int shipStamina;
@property (readonly) int shipSpeed;
@property (readonly) int shipWidth;
@property (readonly) int shipHeight;
@property (nonatomic, retain) Polygon *collisionPolygon;
@property (nonatomic, retain) NSMutableArray *projectilesArray;
@property (readonly) CGPoint currentLocation;
@property (nonatomic, retain) ParticleEmitter *deathAnimationEmitter;

- (void)update:(GLfloat)delta;
- (void)render;
- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;

- (void)hitShipWithDamage:(int)damage;

@end
