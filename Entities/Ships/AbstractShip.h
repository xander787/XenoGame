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
//	Last Updated - 

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Animation.h"

@class GameScene;

@interface AbstractShip : NSObject {
	Image		*mainImage;
	Vector2f	position;
	Vector2f	velocity;
	BOOL		_gotScene;
}

@property (nonatomic, readonly) Image *mainImage;
@property (nonatomic, assign) Vector2f position;
@property (nonatomic, assign) Vector2f velocity;

- (void)update:(GLfloat)delta;
- (void)render;

@end
