//
//  Frame.h
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


#import <Foundation/Foundation.h>
#import "Image.h"

@interface Frame : NSObject {
	
	// The image this frame of animation will display
	Image *frameImage;
	// How long the frame should be displayed for
	float frameDelay;
	
}

@property(nonatomic, assign)float frameDelay;
@property(nonatomic, retain)Image *frameImage;

- (id)initWithImage:(Image*)image delay:(float)delay;

@end
