//
//  AngelCodeFont.h
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
#import "CharDef.h"

@class Director;

#define kMaxCharsInMessage 256
#define kMaxCharsInFont 512

@interface AngelCodeFont : NSObject {
	
	// Game state
	Director *_director;
	// The image which contains the bitmap font
	Image		*image;
	// The characters building up the font
	CharDef		*charsArray[kMaxCharsInFont];
	// The height of a line
	GLuint		lineHeight;
	// Colour Filter = Red, Green, Blue, Alpha
	Color4f		colourFilter;
	// The scale to be used when rendering the font
	GLfloat		scale;
	// Should kerning be used if available
	BOOL		useKerning;
	// Kerning dictionary
	NSMutableDictionary *KerningDictionary;
	// Vertex arrays
	Quad2f *texCoords;
	Quad2f *vertices;
	GLushort *indices;
}

@property(nonatomic, assign)float scale;
@property(nonatomic, retain)Image *image;
@property(nonatomic, assign)BOOL useKerning;

- (id)initWithFontImageNamed:(NSString*)fontImage controlFile:(NSString*)controlFile scale:(float)fontScale filter:(GLenum)filter;
- (void)drawStringAt:(CGPoint)point text:(NSString*)text;
- (int)getWidthForString:(NSString*)string;
- (int)getHeightForString:(NSString*)string;
- (void)setColourFilterRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
- (void)setScale:(float)newScale;

@end
