//
//  CCParallaxNode-Extras.h
//  SpaceGame
//
//  Created by Ray Wenderlich on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface CCParallaxNode (Extras) 

-(void) incrementOffset:(CGPoint)offset forChild:(CCNode*)node;

@end
