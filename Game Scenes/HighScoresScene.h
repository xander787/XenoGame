//
//  HighScoresScene.h
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

@interface HighScoresScene : AbstractScene {
	Image				*leaderboardsTitle;
	Image				*highscoresTable;
	Image				*todayButton;
	Image				*todayButtonGlow;
	Image				*thisWeekButton;
	Image				*thisWeekButtonGlow;
    Image               *allTimeButton;
    Image               *allTimeButtonGlow;
    Image               *backButton;
    Image               *previousButton;
    Image               *nextButton;
    
    int                 selectedButtonIndex;
}

@end
