//
//  Animation.m
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
//
//  Last Updated - 12/23/10 @ 9:50PM - James
//  - Changed the rendering of the Frame to
//  render at the center. Helps with DidCollide
//  and other standards for this.
//
//  Last Updated - 6/23/11 @8PM - Alexander
//  - You can now add a color filter to the animation at any time

#import "Animation.h"


@implementation Animation

@synthesize running;
@synthesize currentFrame;
@synthesize direction;
@synthesize repeat;
@synthesize pingPong;
@synthesize colorFilter;

- (id)init {
	self = [super init];
	if(self != nil) {
		// Initialize the array which will hold our frames
		frames = [[NSMutableArray alloc] init];
		
		// Set the default values for important properties
		currentFrame = 0;
		frameTimer = 0;
		running = NO;
		repeat = NO;
		pingPong = NO;
		direction = kDirection_Forward;
        colorFilter = Color4fMake(1.0f, 1.0f, 1.0f, 1.0f);
	}
	return self;
}


- (void)addFrameWithImage:(Image*)image delay:(float)delay {
	
	// Create a new frame instance which will hold the frame image and delay for that image
	Frame *frame = [[Frame alloc] initWithImage:image delay:delay];
	
	// Add the frame to the array of frames in this animation
	[frames addObject:frame];
	
	// Release the frame instance created as having added it to the array will have put its
	// retain count up to 2 so the object we need will not be released until we are finished
	// with it
	[frame release];
	
}


- (void)update:(float)delta {
	// If the animation is not running then don't do anything
	if(!running) return;
	
	// Update the timer with the delta
	frameTimer += delta;
	
	// If the timer has exceed the delay for the current frame, move to the next frame.  If we are at
	// the end of the animation, check to see if we should repeat, pingpong or stop
	if(frameTimer > [[frames objectAtIndex:currentFrame] frameDelay]) {
		currentFrame += direction;
		frameTimer = 0;
		if(currentFrame > [frames count]-1 || currentFrame < 0) {
			
			// The following code was provided by akucsai (Antal) on the 71Squared blog
			if(!pingPong) {
				if(repeat)
					// If we should repeat without ping pong then just reset the current frame to 0 and carry on
					currentFrame = 0;
				else  {
					// If we are not repeating and no pingPing then set the current frame to 0 and stop the animation
					running = NO;
					currentFrame = 0;
				}
			} else {
				// If we are ping ponging then change the direction and move the current frame to the
				// next frame based on the direction
				direction = -direction;
				currentFrame += direction;
			}
		}
	}
}


- (Image*)getCurrentFrameImage {
	// Return the image which is being used for the current frame
	return [[frames objectAtIndex:currentFrame] frameImage];
}


- (GLuint)getAnimationFrameCount {
	// Return the total number of frames in this animation
	return [frames count];
}


- (GLuint)getCurrentFrameNumber {
	// Return the current frame within this animation
	return currentFrame;
}


- (Frame*)getFrame:(GLuint)frameNumber {
	
	// If a frame number is reuqested outside the range that exists, return nil
	// and log an error
	if(frameNumber > [frames count]) {
		if(DEBUG) NSLog(@"WARNING: Requested frame '%d' is out of bounds", frameNumber);
		return nil;
	}
	
	// Return the frame for the requested index
	return [frames objectAtIndex:frameNumber];
}


- (void)flipAnimationVertically:(BOOL)flipVertically horizontally:(BOOL)flipHorizontally {
	for(int index=0; index < [frames count]; index++) {
		[[[frames objectAtIndex:index] frameImage] setFlipVertically:flipVertically];
		[[[frames objectAtIndex:index] frameImage] setFlipHorizontally:flipHorizontally];
	}
}

- (void)renderAtPoint:(CGPoint)point {
	
	// Get the current frame for this animation
	Frame *frame = [frames objectAtIndex:currentFrame];
	
	// Take the image for this frame and render it at the point provided, but default
	// animations are rendered with their centre at the point provided
    [[frame frameImage] setColourFilterRed:colorFilter.red green:colorFilter.green blue:colorFilter.blue alpha:colorFilter.alpha];
	[[frame frameImage] renderAtPoint:point centerOfImage:YES];
}


- (void)dealloc {
	
	[frames release];
	[super dealloc];
}
@end
