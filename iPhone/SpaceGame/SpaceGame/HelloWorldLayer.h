//
//  HelloWorldLayer.h
//  SpaceGame
//
//  Created by Ray Wenderlich on 5/15/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"

typedef enum {
    kEndReasonWin,
    kEndReasonLose
} EndReason;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer<GCDAsyncUdpSocketDelegate>
{
    CCSpriteBatchNode *_batchNode;
    CCSprite *_ship;
    
    CCParallaxNode *_backgroundNode;
    CCSprite *_spacedust1;
    CCSprite *_spacedust2;
    CCSprite *_planetsunrise;
    CCSprite *_galaxy;
    CCSprite *_spacialanomaly;
    CCSprite *_spacialanomaly2;
    
    float _shipPointsPerSecY;
    
    CCArray *_asteroids;
    int _nextAsteroid;
    double _nextAsteroidSpawn;
    
    CCArray *_shipLasers;
    int _nextShipLaser;
    
    int _lives;
    
    double _gameOverTime;
    bool _gameOver;
    
    GCDAsyncUdpSocket *udpSocket;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
