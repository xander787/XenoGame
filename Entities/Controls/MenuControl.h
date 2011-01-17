//
//  MenuControl.h
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
//	Last Updated - 10/26/2010 @ 12AM - Alexander
//	- Initial creation of the control

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
