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
//	Last Updated - 11/6/2010 - Alexander
//	- Initial Class Creation

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Animation.h"

@class GameScene;

@interface AbstractShip : NSObject {
	Director	*_sharedDirector;
	BOOL		_gotScene;
}

- (void)update:(GLfloat)delta;
- (void)render;

@end
