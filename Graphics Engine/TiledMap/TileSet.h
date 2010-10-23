//
//  TileSet.h
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

// Class used to hold tilesets that are defined within a tile map configuration file.  This class
// is responsible for holding the tileset sprite sheet as well as information about the global
// id's used within the tilset and details of the tilesets dimensions.
//
@interface TileSet : NSObject {
	// ID of tile set
	int tileSetID;
	// Name of the tile set
	NSString *name;
	// First global id for this tile set
	int firstGID;
	// last gloabl ID for this tile set
	int lastGID;
	// Width of the tiles in this tile set
	int tileWidth;
	// Height of the tiles in this tile set
	int tileHeight;
	// Tile spacing
	int spacing;
	// Spritesheet which holds the tiles for this tile set
	SpriteSheet *tiles;
	// Horizontal tiles
	int horizontalTiles;
	// Vertical tiles
	int verticalTiles;
}

@property(nonatomic, readonly)int tileSetID;
@property(nonatomic, readonly)NSString *name;
@property(nonatomic, readonly)int firstGID;
@property(nonatomic, readonly)int lastGID;
@property(nonatomic, readonly)int tileWidth;
@property(nonatomic, readonly)int tileHeight;
@property(nonatomic, readonly)int spacing;
@property(nonatomic, readonly)SpriteSheet *tiles;

// Designated selector used to initialize a new tileset instance.
- (id)initWithImageNamed:(NSString*)aImage name:(NSString*)aTileSetName tileSetID:(int)tileSetID firstGID:(int)aFirstGlobalID tileWidth:(int)aTileWidth tileHeight:(int)aTileHeight spacing:(int)aSpacing;

// Checks to see if the |aGlobalID| exists within this tileset and returns YES if it does
- (BOOL)containsGlobalID:(int)aGlobalID;

// Returns the Y location within the tilsset sprite sheet of a given tile given the tiles
// |aTileID|
- (int)getTileY:(int)aTileID;

// Returns the X location within the tilsset sprite sheet of a given tile given the tiles
// |aTileID|
- (int)getTileX:(int)aTileID;

@end
