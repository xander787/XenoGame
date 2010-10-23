//
//  CharDef.m
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


#import "CharDef.h"


@implementation CharDef

@synthesize image;
@synthesize charID;
@synthesize x;
@synthesize y;
@synthesize width;
@synthesize height;
@synthesize xOffset;
@synthesize yOffset;
@synthesize xAdvance;
@synthesize scale;

- (id)initCharDefWithFontImage:(Image*)fontImage scale:(float)fontScale{
	self = [super init];
	if (self != nil) {
		// Reference the image file which contains the spritemap for the characters
		image = fontImage;
		// Set the scale for this character
		scale = fontScale;
	}
	return self;
}


- (NSString *)description {
	// Log what we have created
	return [NSString stringWithFormat:@"CharDef = id:%d x:%d y:%d width:%d height:%d xoffset:%d yoffset:%d xadvance:%d", 
			charID, 
			x, 
			y, 
			width, 
			height, 
			xOffset, 
			yOffset, 
			xAdvance];
}


- (void)dealloc {
	[super dealloc];
}

@end
