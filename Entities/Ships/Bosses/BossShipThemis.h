//
//  BossShipThemis.h
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

#import <Foundation/Foundation.h>
#import "BossShip.h"

typedef enum _ThemisState {
    kThemisState_StageOne = 0,
    kThemisState_StageTwo,
} ThemisState;

@interface BossShipThemis : BossShip {
    ModularObject       *mainBody;
    ModularObject       *chainEndRight;
    ModularObject       *chainEndLeft;
    
    ThemisState         state;
    float               holdingTimer;
}

- (id)initWithLocation:(CGPoint)aPoint andPlayershipRef:(PlayerShip *)playerRef;
- (void)update:(GLfloat)delta;

@end
