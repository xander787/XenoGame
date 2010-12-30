//
//  Collisions.m
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

#import "Collisions.h"


@implementation Collisions

- (PolygonCollisionResult) polygonCollision:(Polygon *)polygonA :(Polygon *)polygonB :(Vector2f)velocity {
    result.intersect = YES;
    result.willIntersect = YES;
    
    int edgeCountA = lengthOfVec2fArray(polygonA.edges);
    int edgeCountB = lengthOfVec2fArray(polygonB.edges);
    float  minIntervalDistance = DBL_MAX; // Should be infinity though
    Vector2f translationAxis = Vector2fZero;
    Vector2f edge;
    
    //Loop through all the edges of both polygons
    for(int edgeIndex = 0; edgeIndex < edgeCountA + edgeCountB; edgeIndex++){
        if(edgeIndex < edgeCountA){
            edge = polygonA.edges[edgeIndex];
        }
        else {
            edge = polygonB.edges[edgeIndex - edgeCountA];
        }
        
        // ==== 1. Find if the polygons are currently intersecting ====
        
        //Find the ais perpendicular the the current edge
        Vector2f axis = Vector2fMake(-edge.y, edge.x);
        Vector2fNormalize(axis);
        
        //Find the projection of the polygon on the current axis
        float minA = 0;
        float minB = 0;
        float maxA = 0;
        float maxB = 0;
        [self projectPolygon:axis :polygonA :&minA :&maxA];
        [self projectPolygon:axis :polygonB :&minB :&maxB];
        
        //Check if the polygon projections are currently intersecting
        if([self intervalDistance:minA :maxA :minB :maxB] > 0){
            result.intersect = NO;
        }
        
        // ==== 2. Now find if the polygons *will* intersect ====
        
        //Project the velocity i nthe current axis
        float velocityProjection = (float)Vector2fDot(axis, velocity);
        
        //Get the projection of polygonA during the movement
        if(velocityProjection < 0){
            minA += velocityProjection;
        }
        else {
            maxA += velocityProjection;
        }
        
        //Do the same test as above for the new projection
        float intervalDistance = [self intervalDistance:minA :maxA :minB :maxB];
        if(intervalDistance > 0){
            result.willIntersect = NO;
        }
        
        //If the polygons are not intersecting and won't intersect, exit the loop
        if(!result.intersect && !result.willIntersect) break;
        
        //Check if the current interval distance is the minumum opne. If so store
        //the interval distance and the current distance.
        //This will be used to calculate the minimum translation vector
        intervalDistance = abs(intervalDistance);
        if(intervalDistance < minIntervalDistance){
            minIntervalDistance = intervalDistance;
            translationAxis = axis;
            
            Vector2f d = Vector2fSub([polygonA center], [polygonB center]);
            if(Vector2fDot(d, translationAxis) < 0){
                translationAxis = Vector2fMake(-translationAxis.x, -translationAxis.y);
            }
        }
      
    }
    
    // The minimum translation vector can be used to push the polygons apart.
    //First moves the polygons by their velocity
    //then move the polygonA by minTranslationVector
    if(result.willIntersect){
        result.minimumTranslationVector = Vector2fMultiply(translationAxis, minIntervalDistance);
    }
    
    return result;
}

- (float)intervalDistance:(float)minA :(float)maxA :(float)minB :(float)maxB {
    if(minA < minB){
        return minB - maxA;
    }
    else {
        return minA - maxB;
    }
}

- (void)projectPolygon:(Vector2f)axis :(Polygon *)polygon :(float *)min :(float *)max {
    float d = (float)Vector2fDot(axis, polygon.points[0]);
    *min = d;
    *max = d;
    for(int i = 0; i < lengthOfVec2fArray(polygon.points); i++){
        d = Vector2fDot(polygon.points[i], axis);
        if(d < *min){
            *min = d;
        }
        else {
            if(d > *max){
                *max = d;
            }
        }
    }
}

@end
