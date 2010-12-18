//
//  PhysicalObject.m
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

#import "PhysicalObject.h"


@implementation PhysicalObject

@synthesize _velocity, _acceleration;

- (id)init {
    if(self = [super init]) {
        _velocity = _acceleration = Vector2fZero;
    }
    
    return self;
}

@end
