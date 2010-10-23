//
//  AbstractControl.h
//  Xenophobe
//
//  Created by Alexander on 10/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Common.h"

@interface AbstractControl : NSObject {
	
	// Shared game state
	Director *sharedDirector;
	// Image for the control
	Image *image;
	// Location at which the control item should be rendered
	Vector2f location;
	// Should the image be rendered based on its center
	BOOL centered;
	// State of the control entity
	GLuint state;
	// Control Type
	uint type;
	// Control scale
	GLfloat scale;
	// Alpha
	GLfloat alpha;
}

@property (nonatomic, retain) Image *image;
@property (nonatomic, assign) Vector2f location;
@property (nonatomic, assign) BOOL centered;
@property (nonatomic, assign) GLuint state;
@property (nonatomic, readonly) uint type;
@property (nonatomic, assign) GLfloat scale;
@property (nonatomic, assign) GLfloat alpha;

- (void)updateWithLocation:(NSString*)theTouchLocation;
- (void)updateWithDelta:(NSNumber*)theDelta;
- (void)render;

@end
