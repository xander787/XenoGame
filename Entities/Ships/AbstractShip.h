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
// Last Updated - 6/13/2011 @ 4PM - James
//  - Added hitShipWithDamage method for universal damage 
//  detection, with subclasses defining the method.

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Animation.h"
#import "PhysicalObject.h"

@class GameScene;

@interface AbstractShip : PhysicalObject {
	Director	*_sharedDirector;
	BOOL		_gotScene;
    
    BOOL        shipIsDead;
}

@property (readonly) BOOL shipIsDead;

- (void)update:(GLfloat)delta;
- (void)render;
- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;

- (void)hitShipWithDamage:(int)damage;

@end
