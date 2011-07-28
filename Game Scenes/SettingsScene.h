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
//	Last Updated - 11/21/2010 @ 11AM - Alexander
//	- Added in testing code for the player ship in here
//
//  Last Updated - 6/17/11 @7:30PM - Alexander
//  - Added some placeholder strings for the settings
//  categories.

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "AngelCodeFont.h"

@interface SettingsScene : AbstractScene {
    AngelCodeFont   *font;
    NSString        *controlsSettingString;
    NSString        *settingsTitleString;
    NSString        *soundSettingString;
    NSString        *musicSettingString;
    Image           *backButton;
    NSUserDefaults  *settingsDB;
    
    Image           *sliderImage;
    Image           *sliderBarImage;
    Image           *volumeLowImage;
    Image           *volumeHighImage;
    BOOL            soundBarTouched;
    BOOL            musicBarTouched;
    float           soundVolume;
    float           musicVolume;
}

@end
