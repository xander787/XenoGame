//
//  Layer.h
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

// Class which contains information about each layer defined within a tile map 
// configuration file.  This class is responsbile for storing information related
// to a layer in the tilemap and also for holding the tilemap data for each tile
// within the defined layer
//
#define MAX_MAP_WIDTH 100
#define MAX_MAP_HEIGHT 100

@interface Layer : NSObject {
	// The layers index
	int layerID;
	// The layers name
	NSString *layerName;
	// Tile data where the 3rd dimension is index 0 = tileset, index 1 = tile id, index 2 = global id
	// Currently hardcoded to a max of 1024x1024
	int layerData[MAX_MAP_WIDTH][MAX_MAP_HEIGHT][3];
	// The width of the layer
	int layerWidth;
	// The height of layer layer
	int layerHeight;
	// Layer properties
	NSMutableDictionary *layerProperties;
}

@property(nonatomic, readonly) int layerID;
@property(nonatomic, readonly) NSString *layerName;
@property(nonatomic, readonly) int layerWidth;
@property(nonatomic, readonly) int layerHeight;
@property(nonatomic, retain) NSMutableDictionary *layerProperties;

// Designated selector which creates a new instance of the Layer class.
- (id)initWithName:(NSString*)aName layerID:(int)aLayerID layerWidth:(int)aLayerWidth layerHeight:(int)aLayerHeight;

// Adds tile details to the layer at a specified location within the tile map
- (void)addTileAtX:(int)aLayerX y:(int)aLayerY tileSetID:(int)aTileSetID tileID:(int)aTileID globalID:(int)aGlobalID;

// Returns the tileset for a tile at a given location within this layer
- (int)getTileSetIDAtX:(int)aLayerX y:(int)aLayerY;

// Returns the Global Tile ID for a tile at a given location within this layer
- (int)getGlobalTileIDAtX:(int)aLayerX y:(int)aLayerY;

// Returns the tile id for a tile at a given location within this layer
- (int)getTileIDAtX:(int)aLayerX y:(int)aLayerY;

@end
