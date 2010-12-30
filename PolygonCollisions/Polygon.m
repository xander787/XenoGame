//
//  Polygon.m
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

#import "Polygon.h"


@implementation Polygon

@synthesize edges, points;

- (id)init {
    if(self = [super init]){
        
    }
    
    return  self;
}

- (void)buildEdges {
    Vector2f p1, p2;
    for(int i = 0; i < lengthOfVec2fArray(points); i++){
        p1 = points[i];
        if(i + 1 >= lengthOfVec2fArray(points)){
            p2 = points[0];
        }
        else {
            p2 = points[i+1];
        }
        edges[i] = Vector2fSub(p2, p1);
    }
}

- (Vector2f)center {
    float totalX = 0;
    float totalY = 0;
    for(int i = 0; i < lengthOfVec2fArray(points); i++){
        totalX += points[i].x;
        totalY += points[i].y;
    }
    
    return Vector2fMake(totalX/(float)lengthOfVec2fArray(points), totalY/(float)lengthOfVec2fArray(points));
}

- (void)offset:(Vector2f)v {
    [self offset:v.x :v.y];
}

- (void)offset:(float)x :(float)y {
    for(int i = 0; i < lengthOfVec2fArray(points); i++){
        Vector2f p = points[i];
        points[i] = Vector2fMake(p.x + x, p.y + y);
    }
}

- (NSString *)toString {
    NSString *stringResult = [[NSString alloc] initWithFormat:@""];
    
    for(int i = 0; i < lengthOfVec2fArray(points); i++){
        if(stringResult != @""){
            [stringResult stringByAppendingFormat:@" "];
        }
        [stringResult stringByAppendingFormat:@"{ %i }", points[i]];
    }
    
    return stringResult;
}

@end
