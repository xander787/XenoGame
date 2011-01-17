//
//  Layer.m
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

#import "Layer.h"


@implementation Layer

@synthesize layerID;
@synthesize layerName;
@synthesize layerWidth;
@synthesize layerHeight;
@synthesize layerProperties;

- (id)initWithName:(NSString*)aName layerID:(int)aLayerID layerWidth:(int)aLayerWidth layerHeight:(int)aLayerHeight {
	if(self != nil) {
		layerName = aName;
		layerID = aLayerID;
		layerWidth = aLayerWidth;
		layerHeight = aLayerHeight;
	}
	return self;
}


- (int)getTileIDAtX:(int)aLayerX y:(int)aLayerY {
	return layerData[aLayerX][aLayerY][1];
}


- (int)getGlobalTileIDAtX:(int)aLayerX y:(int)aLayerY {
	return layerData[aLayerX][aLayerY][2];
}


- (int)getTileSetIDAtX:(int)aLayerX y:(int)aLayerY {
	return layerData[aLayerX][aLayerY][0];
}


- (void)addTileAtX:(int)aLayerX y:(int)aLayerY tileSetID:(int)aTileSetID tileID:(int)aTileID globalID:(int)aGlobalID {
	layerData[aLayerX][aLayerY][0] = aTileSetID;
	layerData[aLayerX][aLayerY][1] = aTileID;
	layerData[aLayerX][aLayerY][2] = aGlobalID;
}

@end
