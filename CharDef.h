//
//  CharDef.h
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


#import <Foundation/Foundation.h>
#import "Image.h"

@interface CharDef : NSObject {
	// ID of the character
	int charID;
	// X location on the spritesheet
	int x;
	// Y location on the spritesheet
	int y;
	// Width of the character image
	int width;
	// Height of the character image
	int height;
	// The X amount the image should be offset when drawing the image
	int xOffset;
	// The Y amount the image should be offset when drawing the image
	int yOffset;
	// The amount to move the current position after drawing the character
	int xAdvance;
	// The image containing the character
	Image *image;
	// Scale to be used when rendering the character
	float scale;
}

@property(nonatomic, retain)Image *image;
@property(nonatomic)int charID;
@property(nonatomic)int x;
@property(nonatomic)int y;
@property(nonatomic)int width;
@property(nonatomic)int height;
@property(nonatomic)int xOffset;
@property(nonatomic)int yOffset;
@property(nonatomic)int xAdvance;
@property(nonatomic)float scale;

- (id)initCharDefWithFontImage:(Image*)image scale:(float)fontScale;
//- (void)drawAt:(CGPoint)point;
@end
