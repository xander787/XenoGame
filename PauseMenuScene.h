//
//  PauseMenuScene.h
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
//  Last Updated -


#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "Common.h"
#import "Image.h"
#import "AngelCodeFont.h"
#import "ParticleEmitter.h"
#import "MenuControl.h"

@interface PauseMenuScene : AbstractScene {    
    MenuControl     *mainMenuButton;
    MenuControl     *returnToGameButton;
    MenuControl     *settingsMenuButton;
    
    BOOL            returnToGame;
}
@property(readwrite) BOOL returnToGame;

- (id)init;

@end
