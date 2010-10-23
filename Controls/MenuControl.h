//
//  MenuControl.h
//  Xenophobe
//
//  Created by Alexander on 10/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractControl.h"
#import "Image.h"
#import "Common.h"


@interface MenuControl : AbstractControl {
	
	
}

- (id)initWithImageNamed:(NSString*)theImageName location:(Vector2f)theLocation centerOfImage:(BOOL)theCenter type:(uint)theType;
- (void)updateWithLocation:(NSString*)theTouchLocation;
- (void)updateWithDelta:(NSNumber*)theDelta;
- (void)render;

@end
