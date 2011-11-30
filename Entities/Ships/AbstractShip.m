//
//  AbstractShip.m
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
//  Last Updated - 6/23/2011 - James
//  - Added killShip method

#import "AbstractShip.h"


@implementation AbstractShip

@synthesize shipIsDead, shipHealth, shipMaxHealth, shipAttack, shipStamina, shipSpeed, shipWidth, shipHeight;
@synthesize collisionPolygon, projectilesArray, currentLocation, deathAnimationEmitter, collisionPolygonArray;

- (id)init {
	self = [super init];
	if (self != nil) {
		_gotScene = NO;
        shipIsDead = FALSE;
	}
	
	return self;
}

- (void)hitShipWithDamage:(int)damage {
    
}

- (void)killShip {
    
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	
}

- (void)update:(GLfloat)delta {
	
}

- (void)render {
	
}

- (void)dealloc {
    [super dealloc];
    free(collisionPolygon);
    free(collisionDetectionBoundingPoints);
    free(turretPoints);
    free(thrusterPoints);
    [projectilesArray release];
    [deathAnimationEmitter release];
}

@end
