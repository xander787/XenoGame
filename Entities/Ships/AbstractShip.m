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
//	Last Updated - 11/6/2010 - Alexander
//	- Initial Class Creation

#import "AbstractShip.h"


@implementation AbstractShip


- (id)init {
	self = [super init];
	if (self != nil) {
		_gotScene = NO;
	}
	
	return self;
}

- (void)update:(GLfloat)delta {
	
}

- (void)render {
	
}

@end
