//
//  GameScene.h
//  Xenophobe
//
//  Created by Alexander on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "Image.h"
#import "PlayerShip.h"

@interface GameScene : AbstractScene {
	CGPoint				_origin;
	Image				*image;
}

@end
