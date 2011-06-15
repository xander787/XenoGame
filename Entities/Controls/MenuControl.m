//
//  MenuControl.m
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
//	Last Updated - 10/28/2010 @ 6:40PM - Alexander
//	- Made the button animation faster

#import "MenuControl.h"

@interface MenuControl (Private)
- (void)scaleImage:(GLfloat)delta;
@end


@implementation MenuControl

#define MAX_SCALE 2.0f
#define SCALE_DELTA 1.0f
#define ALPHA_DELTA 1.0f

- (id)initWithImageNamed:(NSString*)theImageName location:(Vector2f)theLocation centerOfImage:(BOOL)theCenter type:(uint)theType {
	self = [super init];
	if (self != nil) {
		sharedDirector = [Director sharedDirector];
		image = [(Image*)[Image alloc] initWithImage:theImageName filter:GL_LINEAR];
		location = theLocation;
		centered = theCenter;
		type = theType;
		state = kControl_Idle;
		scale = 1.0f;
		alpha = 1.0f;
	}
	return self;
}

- (void)updateWithLocation:(NSString*)theTouchLocation {
	
	CGRect controlBounds = CGRectMake(location.x - (([image imageWidth]*[image scale].x)/2), location.y - (([image imageHeight]*[image scale].y)/2), [image imageWidth]*[image scale].x, [image imageHeight]*[image scale].y);
	
	CGPoint touchPoint = CGPointFromString((NSString*)theTouchLocation);
	
	if(CGRectContainsPoint(controlBounds, touchPoint) && state != kControl_Scaling) {
		state = kControl_Scaling;
	}
}

- (void)updateWithDelta:(NSNumber*)theDelta {
	
	// Get the delta value which has been passed in
	GLfloat delta = [theDelta floatValue];
	
	if(state == kControl_Scaling) {		
		[self scaleImage:delta * 3];
	}
	if(state == kControl_Idle) {
		scale = 1.0f;
		alpha = 1.0f;
	}
}


- (void)scaleImage:(GLfloat)delta {
	scale += SCALE_DELTA * delta;
	alpha -= ALPHA_DELTA * delta;
	if(scale > MAX_SCALE) {
		scale = MAX_SCALE;
		state = kControl_Selected;
	}
}


- (void)render {
	[image setAlpha:alpha];
	[image setScale:Scale2fMake(scale, scale)];
	[image renderAtPoint:CGPointMake(location.x, location.y) centerOfImage:centered];	
}

@end
