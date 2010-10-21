//
//  Frame.m
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
//	Last Updated - 10/20/2010 @ 6PM - Alexander
//	- Initial Project Creation

#import "Frame.h"


@implementation Frame

@synthesize frameDelay;
@synthesize frameImage;

- (id)initWithImage:(Image*)image delay:(float)delay {
	self = [super init];
	if(self != nil) {
		frameImage = image;
		frameDelay = delay;
	}
	return self;
}


- (void)dealloc {
    [frameImage release];
	[super dealloc];
}

@end
