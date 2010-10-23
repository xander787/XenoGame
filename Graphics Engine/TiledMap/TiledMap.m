//
//  TiledMap.m
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

#import "TiledMap.h"

// Private methods
@interface TiledMap ()
- (void)parseMapFile:(NSString*)tiledXML;
@end

@implementation TiledMap

@synthesize tileSets;
@synthesize layers;
@synthesize mapWidth;
@synthesize mapHeight;
@synthesize tileWidth;
@synthesize tileHeight;

- (id)initWithTiledFile:(NSString*)aTiledFile fileExtension:(NSString*)aFileExtension {
	
	self = [super init];
	if (self != nil) {
		
		// Shared game state
		sharedDirector = [Director sharedDirector];
        
        // Set up the default colour filter
        colourFilter = Color4fInit;
		
		// Set up the arrays and default values for layers and tilesets
		tileSets = [[NSMutableArray alloc] init];
		layers = [[NSMutableArray alloc] init];
		
		// Get the path to the tiled config file and parse that file	
		NSString *tiledXML = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:aTiledFile ofType:aFileExtension]];
		[self parseMapFile:tiledXML];
		
		// Calculate the total number of tiles it would take to fill the visible screen.  The values below which define the screen
		// size would need to be changed based on the size of the area you need the tilemap to fill.  I am adding a couple of tiles
		// to the total to cover fractions of a tile which may have resulted in the calculation.  I am then multuplying the result
		// by two as there are two triangles per tile
		int totalTriangles = ((320 / tileWidth) + 2) * ((480 / tileHeight) + 2) * 12 ;
		if(DEBUG) NSLog(@"--> Initializing vertex arrays for '%d' triangles.", totalTriangles);
		
		// Set up the vertex arrays
		tileVerts = calloc(totalTriangles, sizeof(TileVert));
		
		// If one of the arrays cannot be allocated, then report a warning and return nil
		if(!tileVerts) {
			if(DEBUG) NSLog(@"WARNING: Tiled - Not enough memory to allocate vertex arrays");
			return nil;
		}
	}
	return self;
}


- (void)parseMapFile:(NSString*)tiledXML {
	
	// Allocate and init the properties dictionary for the map
	mapProperties = [[NSMutableDictionary alloc] init];
	
	// theError will store any errors which are returned when using XML
	NSError *theError = nil;
	
	// Init the current layer, tileset and tile x and y
	currentLayerID = 0;
	currentTileSetID = 0;
	tileX = 0;
	tileY = 0;
	
	// Create a DDXMLDocument for the file which has been passed in
	DDXMLDocument *theXMLDocument = [[DDXMLElement alloc] initWithXMLString:tiledXML error:&theError];
	
	// Process the map element and read the attributes we need
	NSArray *mapElements = [theXMLDocument nodesForXPath:@"/map" error:&theError];
	DDXMLElement *mapElement = [mapElements objectAtIndex:0];
	mapWidth = [[[mapElement attributeForName:@"width"] stringValue] intValue];
	mapHeight = [[[mapElement attributeForName:@"height"] stringValue] intValue];
	tileWidth = [[[mapElement attributeForName:@"tilewidth"] stringValue] intValue];
	tileHeight = [[[mapElement attributeForName:@"tileheight"] stringValue] intValue];
	if(DEBUG) NSLog(@"Tiled: Tilemap map dimensions are %dx%d", mapWidth, mapHeight);
	if(DEBUG) NSLog(@"Tiled: Tilemap tile dimensions are %dx%d", tileWidth, tileHeight);
	
	// Process any map properties which may exist for this map
	NSArray *mp = [theXMLDocument nodesForXPath:@"/map/properties/property" error:&theError];
	for(DDXMLElement *property in mp) {
		NSString *name = [[property attributeForName:@"name"] stringValue];
		NSString *value = [[property attributeForName:@"value"] stringValue];
		[mapProperties setObject:value forKey:name];
		if(DEBUG) NSLog(@"Tiled: Tilemap property '%@' found with value '%@'", name, value);
	}
	
	// Process the tileset elements and read the attributes we need.
	tileSetProperties = [[NSMutableDictionary alloc] init];
	NSArray *tileSetElements = [theXMLDocument nodesForXPath:@"/map/tileset" error:nil];
	for(DDXMLElement *tileSetElement in tileSetElements) {
		tileSetName = [[tileSetElement attributeForName:@"name"] stringValue];
		tileSetWidth = [[[tileSetElement attributeForName:@"tilewidth"] stringValue] intValue];
		tileSetHeight = [[[tileSetElement attributeForName:@"tileheight"] stringValue] intValue];
		tileSetFirstGID = [[[tileSetElement attributeForName:@"firstgid"] stringValue] intValue];
		tileSetSpacing = [[[tileSetElement attributeForName:@"spacing"] stringValue] intValue];
		
		if(DEBUG) NSLog(@"--> TILESET found named: %@, width=%d, height=%d, firstgid=%d, spacing=%d, id=%d", tileSetName, tileSetWidth, tileSetHeight, tileSetFirstGID, tileSetSpacing, currentTileSetID);
		
		// Retrieve the image element
		NSArray *imageElements = [tileSetElement nodesForXPath:@"/tileset/image" error:nil];
		NSString *source = [[[imageElements objectAtIndex:0] attributeForName:@"source"] stringValue];
		if(DEBUG) NSLog(@"----> Found source for tileset called '%@'.", source);
		
		// Process any tileset properties
		NSArray *tileSetTiles = [tileSetElement nodesForXPath:@"/tileset/tile" error:&theError];
		for(DDXMLElement *tile in tileSetTiles) {
			int tileID = [[[tile attributeForName:@"id"] stringValue] intValue] + tileSetFirstGID;
			NSString *tileIDKey = [NSString stringWithFormat:@"%d", tileID];			
			
			NSMutableDictionary *tileProperties = [[NSMutableDictionary alloc] init];
			NSArray *tstp = [tile nodesForXPath:@"/tile/properties/property" error:nil];
			for(DDXMLElement *tileProperty in tstp) {
				NSString *name = [[tileProperty attributeForName:@"name"] stringValue];
				NSString *value = [[tileProperty attributeForName:@"value"] stringValue];
				if(DEBUG) NSLog(@"----> Property '%@' found with value '%@' for global tile id '%@'", name, value, tileIDKey);
				[tileProperties setObject:value forKey:name];
			}
			[tileSetProperties setObject:tileProperties forKey:tileIDKey];
			
			// Release the tileProperties now they have been added to tileSetProperties
			[tileProperties release];
		}
		
		// Create a tileset instance based on the retrieved information
		currentTileSet = [[TileSet alloc] initWithImageNamed:source 
														name:tileSetName 
												   tileSetID:currentTileSetID 
													firstGID:tileSetFirstGID 
												   tileWidth:tileSetWidth 
												  tileHeight:tileSetHeight 
													 spacing:tileSetSpacing];
		
		// Add the tileset instance we have just created to the array of tilesets
		[tileSets addObject:currentTileSet];
		
		// Release the current tileset instance as its been added to the array and we do not need it now
		[currentTileSet release];
		
		// Increment the current tileset id
		currentTileSetID++;
	}
	
	// Process the layer elements
	NSArray *layerElements = [theXMLDocument nodesForXPath:@"/map/layer" error:nil];
	for(DDXMLElement *layerElement in layerElements) {
		layerName = [[layerElement attributeForName:@"name"] stringValue];
		layerWidth = [[[layerElement attributeForName:@"width"] stringValue] intValue];
		layerHeight = [[[layerElement attributeForName:@"height"] stringValue] intValue];
		
		currentLayer = [[Layer alloc] initWithName:layerName layerID:currentLayerID layerWidth:layerWidth layerHeight:layerHeight];
		if(DEBUG) NSLog(@"--> LAYER found called: %@, width=%d, height=%d", layerName, layerWidth, layerHeight);
		
		// Process any layer properties
		NSMutableDictionary *layerProps = [[NSMutableDictionary alloc] init];
		NSArray *layerProperties = [layerElement nodesForXPath:@"/layer/properties/property" error:&theError];
		for(DDXMLElement *property in layerProperties) {
			NSString *name = [[property attributeForName:@"name"] stringValue];
			NSString *value = [[property attributeForName:@"value"] stringValue];
			[layerProps setObject:value forKey:name];
			if(DEBUG) NSLog(@"----> Property '%@' found with value '%@'", name, value);
		}
		[currentLayer setLayerProperties:layerProps];
		
		// Release layerprops as its been added to the current layer which will have a retain on it
		[layerProps release];
		
		// Process the data and tile elements
		NSArray *dataElements = [layerElement nodesForXPath:@"/layer/data" error:nil];
		
		// As we are starting the data element we need to make sure that the tileX and tileY ivars are
		// reset ready to process the tile elements
		tileX = 0;
		tileY = 0;
		
		// Process the tile elements
		NSArray *tileElements = [[dataElements objectAtIndex:0] nodesForXPath:@"/data/tile" error:nil];
		if(DEBUG) NSLog(@"----> Found '%d' tile elements", [tileElements count]);
		
		for(DDXMLElement *tileElement in tileElements) {
			int globalID = [[[tileElement attributeForName:@"gid"] stringValue] intValue];
			
			// If the globalID is 0 then this is an empty tile else populate the tile array with the 
			// retrieved tile information
			if(globalID == 0) {
				[currentLayer addTileAtX:tileX y:tileY tileSetID:-1 tileID:0 globalID:0];
			} else {
				TileSet *tileSet = [self findTileSetWithGlobalID:globalID];
				[currentLayer addTileAtX:tileX 
									   y:tileY 
							   tileSetID:[tileSet tileSetID] 
								  tileID:globalID - [tileSet firstGID] 
								globalID:globalID];
			}
			
			// Calculate the next coord within the tiledata array
			tileX++;
			if(tileX > layerWidth - 1) {
				tileX = 0;
				tileY++;
			}
		}
		
		// We have finished processing the layer element so add the current layer to the
		// layers array, release it and increment the current layer ID.
		[layers addObject:currentLayer];
		[currentLayer release];
		currentLayerID++;
	}
	
	// Release the XML Document
	[theXMLDocument release];
}


- (TileSet*)findTileSetWithGlobalID:(int)aGlobalID {
	// Loop through all the tile sets we have and check to see if the supplied global ID
	// is within one of those tile sets.  If the global ID is found then return the tile set
	// in which it was found
	for(TileSet *tileSet in tileSets) {
		if([tileSet containsGlobalID:aGlobalID]) {
			return tileSet;
		}
	}
	return nil;
}


- (void)renderAtPoint:(CGPoint)aRenderPoint mapX:(int)aMapTileX mapY:(int)aMapTileY width:(int)aTilesWide height:(int)aTilesHigh layer:(int)aLayerID useBlending:(BOOL)aUseBlending {
	
	Layer *layer = [layers objectAtIndex:aLayerID];
	int x = aRenderPoint.x;
	int y = aRenderPoint.y;
	int verticesCounter = 0;
	
	// Enable OGL settings for rendering the tilemap
	glEnable(GL_TEXTURE_2D);
	
	// If we should use blending then enable it
    if(aUseBlending) glEnable(GL_BLEND);
    
    // Set up the use of texture and vertex arrays
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	// Setup how the images are to be blended when rendered.  The setup below is the most common
	// config and handles transparency in images
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	// Loop through all the tile sets we have.  Moving through the map data and rendering all those
	// tiles which are from the current tile map will stop us switching between textures all the time
	for(TileSet *tileSet in tileSets) {
		
		// For the current tileset get the texture name and bind it as the texture we are going to render with
		GLuint textureName = [[[[tileSet tiles] image] texture] name];
		if(textureName != [sharedDirector currentlyBoundTexture]) {
			[sharedDirector setCurrentlyBoundTexture:textureName];
			glBindTexture(GL_TEXTURE_2D, textureName);
		}
		
		// Loop through the map row by row
		for(int mapTileY=aMapTileY; mapTileY < (aMapTileY + aTilesHigh); mapTileY++) {
			for(int mapTileX=aMapTileX; mapTileX < (aMapTileX + aTilesWide); mapTileX++) {
				
				// If outside the map boundary do nothing, otherwise render the tile
				if(mapTileX < 0 || mapTileY < 0 || mapTileX > mapWidth-1 || mapTileY > mapHeight-1) {
					// Do nothing
				} else {
					// Get the tileID and tilesetID for the current map location
					int tileID = [layer getTileIDAtX:mapTileX y:mapTileY];
					int tsid = [layer getTileSetIDAtX:mapTileX y:mapTileY];
					
					// If the tilesetID matches the tileset we are currently processing then add it to the vertex arrays
					// otherwise skip it and it will be drawn when its tileset is being processed
					if([tileSet tileSetID] == tsid) {
						// Calculate the texture coordinates and vertices for the current tile						
						Quad2f tex = [[tileSet tiles] getTextureCoordsForSpriteAtX:[tileSet getTileX:tileID] 
																				 y:[tileSet getTileY:tileID]];
						
						Quad2f vert = *[[tileSet tiles] getVerticesForSpriteAtX:mapTileX 
																			  y:mapTileY 
																		  point:CGPointMake(x, y) 
																  centerOfImage:NO];
						
						// We are going to use glDrawArrays to draw the tile map which will use GL_TRIANGLES and
						// not GL_TRIANGLE_STRIP, so we need to use the info we have got back for the vertex and
						// texture to populate our tileVertices array with triangle information for each tile.  The
						// code below creates two triangles for each tile and loads their info into our array
						TileVert *tile = &tileVerts[verticesCounter];
						tile->v[0] = vert.tl_x;
						tile->v[1] = vert.tl_y;
						tile->uv[0] = tex.tl_x;
						tile->uv[1] = tex.tl_y;
						
						verticesCounter++;
						tile = &tileVerts[verticesCounter];
						tile->v[0] = vert.tr_x;
						tile->v[1] = vert.tr_y;
						tile->uv[0] = tex.tr_x;
						tile->uv[1] = tex.tr_y;
						
						verticesCounter++;
						tile = &tileVerts[verticesCounter];
						tile->v[0] = vert.bl_x;
						tile->v[1] = vert.bl_y;
						tile->uv[0] = tex.bl_x;
						tile->uv[1] = tex.bl_y;
						
						verticesCounter++;
						tile = &tileVerts[verticesCounter];
						tile->v[0] = vert.tr_x;
						tile->v[1] = vert.tr_y;
						tile->uv[0] = tex.tr_x;
						tile->uv[1] = tex.tr_y;
						
						verticesCounter++;
						tile = &tileVerts[verticesCounter];
						tile->v[0] = vert.bl_x;
						tile->v[1] = vert.bl_y;
						tile->uv[0] = tex.bl_x;
						tile->uv[1] = tex.bl_y;
						
						verticesCounter++;
						tile = &tileVerts[verticesCounter];
						tile->v[0] = vert.br_x;
						tile->v[1] = vert.br_y;
						tile->uv[0] = tex.br_x;
						tile->uv[1] = tex.br_y;
						
						verticesCounter++;
					}
					
				}
				// Increment the x location for the next tile to be rendered
				x += tileWidth;			
			}
			// Now we have finished so move to the next row of tiles and reset x
			y -= tileHeight;
			x = aRenderPoint.x;
		}
		
		// Finished processing the current tileset so render the results.  We use the same interlaced
		// tileVertices array for both the vertices and the texture information and then draw the contents
		// using glDrawArrays
		glColor4f(colourFilter.red, colourFilter.green, colourFilter.blue, colourFilter.alpha * [sharedDirector globalAlpha]);
		glVertexPointer(2, GL_FLOAT, sizeof(TileVert), &tileVerts[0].v);
		glTexCoordPointer(2, GL_FLOAT, sizeof(TileVert), &tileVerts[0].uv);
		glDrawArrays(GL_TRIANGLES, 0, verticesCounter);
		
		// Get ready to loop through any other tilesets we have on this layer
		x = aRenderPoint.x;
		y = aRenderPoint.y;
		verticesCounter = 0;
	}
	
	// Disable OpenGL settings we no longer need to use
	glDisable(GL_TEXTURE_2D);
	
	// Only disable blending if it was enabled
    if(aUseBlending) glDisable(GL_BLEND);
    
    // Disbable the client states we were using so that we leave the OpenGL state in a known state
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);
}


- (int)getLayerIndexWithName:(NSString*)aLayerName {
	
	// Loop through the names of the layers and pass back the index if found
	for(Layer *layer in layers) {
		if([[layer layerName] isEqualToString:aLayerName]) {
			return [layer layerID];
		}
	}
	
	// If we reach here then no layer with a matching name was found
	return -1;
}


- (NSString*)getMapPropertyForKey:(NSString*)aKey defaultValue:(NSString*)aDefaultValue {
	NSString *value = [mapProperties valueForKey:aKey];
	if(!value)
		return aDefaultValue;
	return value;
}


- (NSString*)getLayerPropertyForKey:(NSString*)aKey layerID:(int)aLayerID defaultValue:(NSString*)aDefaultValue {
	if(aLayerID < 0 || aLayerID > [layers count] -1) {
		if(DEBUG) NSLog(@"TILED ERROR: Request for a property on a layer which is out of range.");
		return nil;
	}
	NSString *value = [[[layers objectAtIndex:aLayerID] layerProperties] valueForKey:aKey];
	if(!value)
		return aDefaultValue;
	return value;
}


- (NSString*)getTilePropertyForGlobalTileID:(int)aGlobalTileID key:(NSString*)aKey defaultValue:(NSString*)aDefaultValue {
	NSString *value = [[tileSetProperties valueForKey:[NSString stringWithFormat:@"%d", aGlobalTileID]] valueForKey:aKey];
	if(!value)
		return aDefaultValue;
	return value;
}


- (void)dealloc {
	free(tileVerts);
	[tileSets release];
	[layers release];
	[mapProperties release];
	[super dealloc];
}

@end
