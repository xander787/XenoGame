//
//  EAGLView.m
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

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <mach/mach.h>
#import <mach/mach_time.h>

#import "EAGLView.h"

#define USE_DEPTH_BUFFER 0

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;
- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;
- (void) drawView;
@end


@implementation EAGLView

@synthesize context;

- (void)dealloc {
    
	[gameController release];
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
    [super dealloc];
}

// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        
        _sharedDirector = [Director sharedDirector];
        
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
		
		// Init the gameController
		gameController = [[XenophobeGameController alloc] init];
		
		lastTime = CFAbsoluteTimeGetCurrent();
		
		// Configure and start accelerometer delegating the game controller to take the input
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 100)];
		[[UIAccelerometer sharedAccelerometer] setDelegate:gameController];
    }
    return self;
}


#pragma mark -
#pragma mark Main game loop

- (void)mainGameLoop {
	// Create variables to hold the current time and calculated delta
	CFTimeInterval		time;
	float				delta;
	
	// This is the heart of the game loop and will keep on looping until it is told otherwise
    while(true) {
		
        // Create an autorelease pool which can be used within this tight loop.  This is a memory
        // leak when using NSString stringWithFormat in the renderScene method.  Adding a specific
        // autorelease pool stops the memory leak
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        // I found this trick on iDevGames.com.  The command below pumps events which take place
        // such as screen touches etc so they are handled and then runs our code.  This means
        // that we are always in sync with VBL rather than an NSTimer and VBL being out of sync
        while(CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.002, TRUE) == kCFRunLoopRunHandledSource);
        
        // Get the current time and calculate the delta between the lasttime and now
        time = CFAbsoluteTimeGetCurrent();
        delta = (time - lastTime);
        
        // Go and update the game logic and then render the scene
        [gameController updateScene:delta];
        [self drawView];
        
        // Calculate the FPS
        _FPSCounter += delta;
        if(_FPSCounter > 0.25f) {
            _FPSCounter = 0;
            float _fps = (1.0f / (time - lastTime));
            // Set the FPS in the director
            [_sharedDirector setFramesPerSecond:_fps];
        }
		
        // Set the lasttime to the current time ready for the next pass
        lastTime = time;
        
        // Release the autorelease pool so that it is drained
        [pool release];
    }
}


- (void)drawView {
    
	// Set the current EAGLContext and bind to the framebuffer.  This will direct all OGL commands to the
	// framebuffer and the associated renderbuffer attachment which is where our scene will be rendered
	[EAGLContext setCurrentContext:context];
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    
	// Get the game controller to render our scene
	[gameController renderScene];
	
	// Bind to the renderbuffer and then present this image to the current context
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

#pragma mark -
#pragma mark Touches

// Pass on all touch events to the game controller including a reference to this view so we can get data
// about this view if necessary
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	[gameController touchesBegan:touches withEvent:event view:self];
}


- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	[gameController touchesMoved:touches withEvent:event view:self];
}


- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	[gameController touchesEnded:touches withEvent:event view:self];
}


- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        if(DEBUG) NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

@end
