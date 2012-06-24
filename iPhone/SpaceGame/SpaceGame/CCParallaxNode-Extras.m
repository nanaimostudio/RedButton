//
//  CCParallaxNode-Extras.m
//  SpaceGame
//
//  Created by Ray Wenderlich on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCParallaxNode-Extras.h"

@implementation CCParallaxNode(Extras)
@class CGPointObject;

-(void) incrementOffset:(CGPoint)offset forChild:(CCNode*)node 
{
	for( unsigned int i=0;i < parallaxArray_->num;i++) {
		CGPointObject *point = parallaxArray_->arr[i];
		if( [[point child] isEqual:node] ) {
			[point setOffset:ccpAdd([point offset], offset)];
			break;
		}
	}
}

@end
