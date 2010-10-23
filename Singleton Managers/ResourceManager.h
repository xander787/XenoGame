//
//  ResourceManager.h
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

@class Texture2D;

// Class that is responsible for texture resources witihn the game.  This class should be
// used to load any texture.  The class will check to see if an instance of that Texture
// already exists and will return a reference to it if it does.  If not instance already
// exists then it will create a new instance and pass a reference back to this new instance.
// The filename of the texture is used as the key within this class.
//
@interface ResourceManager : NSObject {
    NSMutableDictionary     *_cachedTextures;
}

+ (ResourceManager *)sharedResourceManager;

// Selector returns a Texture2D which has a ket of |aTextureName|.  If a texture cannot be
// found with that key then a new Texture2D is created and added to the cache and a 
// reference to this new Texture2D instance is returned.
- (Texture2D*)getTextureWithName:(NSString*)aTextureName;

// Selector that releases a cached texture which has a matching key to |aTextureName|.
- (BOOL)releaseTextureWithName:(NSString*)aTextureName;

// Selector that releases all cached textures.
- (void)releaseAllTextures;

@end
