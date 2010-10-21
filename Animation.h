//
//  Animation.h
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
#import "SpriteSheet.h"
#import "Frame.h"

enum {
	kDirection_Forward = 1,
	kDirection_Backwards = -1
};

@interface Animation : NSObject {
	
	// Frames to be used within this animation
	NSMutableArray *frames;
	// Accumulates the time while a frame is displayed
	float frameTimer;
	// Holds the animation running state
	BOOL running;
	// Repeat the animation
	BOOL repeat;
	// Should the animation ping pong backwards and forwards
	BOOL pingPong;
	// Direction in which the animation is running
	int direction;
	// The current frame of animation
	int currentFrame;
}

@property(nonatomic)BOOL repeat;
@property(nonatomic)BOOL pingPong;
@property(nonatomic)BOOL running;
@property(nonatomic)int currentFrame;
@property(nonatomic)int direction;

- (void)addFrameWithImage:(Image*)image delay:(float)delay;
- (void)update:(float)delta;
- (void)renderAtPoint:(CGPoint)point;
- (Image*)getCurrentFrameImage;
- (GLuint)getAnimationFrameCount;
- (GLuint)getCurrentFrameNumber;
- (Frame*)getFrame:(GLuint)frameNumber;
- (void)flipAnimationVertically:(BOOL)flipVertically horizontally:(BOOL)flipHorizontally;

@end
