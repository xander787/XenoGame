//
//  AboutScene.h
//  Xenophobe
//
//  Created by Alexander on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "AngelCodeFont.h"

@interface AboutScene : AbstractScene {
    AngelCodeFont       *font;
    ParticleEmitter		*backgroundParticleEmitter;
}

@end
