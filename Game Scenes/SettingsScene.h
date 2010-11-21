//
//  SettingsScene.h
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
//	- Initial creation of the scene

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "PlayerShip.h"


@interface SettingsScene : AbstractScene {
	Image		*playerShip;
	PlayerShip	*testShip;
}

@end
