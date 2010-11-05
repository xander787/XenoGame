//
//  AbstractShip.m
//  Xenophobe
//
//  Created by Alexander on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AbstractShip.h"


@implementation AbstractShip

@synthesize position;
@synthesize velocity;
@synthesize mainImage;

- (id)init {
	self = [super init];
	if (self != nil) {
		position = Vector2fMake(0.0, 0.0);
		velocity = Vector2fMake(0.0, 0.0);
		_gotScene = NO;
	}
}

- (void)update:(GLfloat)delta {
	
}

- (void)render {
	
}

@end
