//
//  GameStatsScene.h
//  Xenophobe
//
//  Created by James Linnell on 7/26/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "AbstractScene.h"
#import "Common.h"
#import "MenuControl.h"
#import "AngelCodeFont.h"
#import "Image.h"

@interface GameStatsScene : AbstractScene {
    MenuControl     *mainMenuButton;
    MenuControl     *optionsButton;
    MenuControl     *continueGameButton;
    
    BOOL            continueGame;
}

@property(readwrite) BOOL continueGame;

@end
