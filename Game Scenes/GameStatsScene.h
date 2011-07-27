//
//  GameStatsScene.h
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
//	Last Updated - 7/26/2011 @ 11PM - Alexander
//  - Stats are now displayed

#import "AbstractScene.h"
#import "Common.h"
#import "MenuControl.h"
#import "AngelCodeFont.h"
#import "Image.h"

@interface GameStatsScene : AbstractScene {
    MenuControl     *mainMenuButton;
    MenuControl     *optionsButton;
    MenuControl     *continueGameButton;
    
    AngelCodeFont   *font;
    
    NSDictionary    *statsDictionary;
    
    BOOL            continueGame;
}

@property(readwrite) BOOL continueGame;
@property(nonatomic, retain) NSDictionary *statsDictionary;

@end
