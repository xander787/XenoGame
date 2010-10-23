//
//  AbstractScene.m
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

#import "AbstractScene.h"


@implementation AbstractScene

@synthesize sceneState;
@synthesize sceneAlpha;

- (void)updateWithDelta:(GLfloat)aDelta {
}


- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration {
}

- (void)transitionToSceneWithKey:(NSString*)aKey {
}

- (void)render {
}

@end
