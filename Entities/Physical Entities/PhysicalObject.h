//
//  PhysicalObject.h
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
//	Last Updated - 

#import <Foundation/Foundation.h>
#import "GameObject.h"


@interface PhysicalObject : GameObject {
    @protected
    Vector2f    _velocity, _acceleration;
}

@property Vector2f _velocity;
@property Vector2f _acceleration;

@end
