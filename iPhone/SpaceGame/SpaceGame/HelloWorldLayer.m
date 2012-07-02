//
//  HelloWorldLayer.m
//  SpaceGame
//
//  Created by Ray Wenderlich on 5/15/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "CCParallaxNode-Extras.h"
#import "SimpleAudioEngine.h"

#define kNumAsteroids   15
#define kNumLasers      5

// HelloWorldLayer implementation
@implementation HelloWorldLayer
int tmpX=50;
int tmpY=49;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    if( (self=[super init])) {
        
        udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        uint16_t port = 1234;
        [udpSocket bindToPort:port error:nil];
        [udpSocket beginReceiving:nil];
        
        _batchNode = [CCSpriteBatchNode batchNodeWithFile:@"Sprites.pvr.ccz"]; // 1
        [self addChild:_batchNode]; // 2
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Sprites.plist"]; // 3
        
        _ship = [CCSprite spriteWithSpriteFrameName:@"SpaceFlier_sm_1.png"];  // 4
        CGSize winSize = [CCDirector sharedDirector].winSize; // 5
        _ship.position = ccp(winSize.width * 0.1, winSize.height * 0.5); // 6
        [_batchNode addChild:_ship z:1]; // 7
        
        // 1) Create the CCParallaxNode
        _backgroundNode = [CCParallaxNode node];
        [self addChild:_backgroundNode z:-1];
        
        // 2) Create the sprites we'll add to the CCParallaxNode
        _spacedust1 = [CCSprite spriteWithFile:@"bg_front_spacedust.png"];
        _spacedust2 = [CCSprite spriteWithFile:@"bg_front_spacedust.png"];
        _planetsunrise = [CCSprite spriteWithFile:@"bg_planetsunrise.png"];
        _galaxy = [CCSprite spriteWithFile:@"bg_galaxy.png"];
        _spacialanomaly = [CCSprite spriteWithFile:@"bg_spacialanomaly.png"];
        _spacialanomaly2 = [CCSprite spriteWithFile:@"bg_spacialanomaly2.png"];
        
        // 3) Determine relative movement speeds for space dust and background
        CGPoint dustSpeed = ccp(0.1, 0.1);
        CGPoint bgSpeed = ccp(0.05, 0.05);
        
        // 4) Add children to CCParallaxNode
        [_backgroundNode addChild:_spacedust1 z:0 parallaxRatio:dustSpeed positionOffset:ccp(0,winSize.height/2)];
        [_backgroundNode addChild:_spacedust2 z:0 parallaxRatio:dustSpeed positionOffset:ccp(_spacedust1.contentSize.width,winSize.height/2)];        
        [_backgroundNode addChild:_galaxy z:-1 parallaxRatio:bgSpeed positionOffset:ccp(0,winSize.height * 0.7)];
        [_backgroundNode addChild:_planetsunrise z:-1 parallaxRatio:bgSpeed positionOffset:ccp(600,winSize.height * 0)];        
        [_backgroundNode addChild:_spacialanomaly z:-1 parallaxRatio:bgSpeed positionOffset:ccp(900,winSize.height * 0.3)];        
        [_backgroundNode addChild:_spacialanomaly2 z:-1 parallaxRatio:bgSpeed positionOffset:ccp(1500,winSize.height * 0.9)];
        
        [self scheduleUpdate];
        
        NSArray *starsArray = [NSArray arrayWithObjects:@"Stars1.plist", @"Stars2.plist", @"Stars3.plist", nil];
        for(NSString *stars in starsArray) {        
            CCParticleSystemQuad *starsEffect = [CCParticleSystemQuad particleWithFile:stars];        
            [self addChild:starsEffect z:1];
        }
        
//        self.isAccelerometerEnabled = YES;
        
        _asteroids = [[CCArray alloc] initWithCapacity:kNumAsteroids];
        for(int i = 0; i < kNumAsteroids; ++i) {
            CCSprite *asteroid = [CCSprite spriteWithSpriteFrameName:@"asteroid.png"];
            asteroid.visible = NO;
            [_batchNode addChild:asteroid];
            [_asteroids addObject:asteroid];
        }

        _shipLasers = [[CCArray alloc] initWithCapacity:kNumLasers];
        for(int i = 0; i < kNumLasers; ++i) {
            CCSprite *shipLaser = [CCSprite spriteWithSpriteFrameName:@"laserbeam_blue.png"];
            shipLaser.visible = NO;
            [_batchNode addChild:shipLaser];
            [_shipLasers addObject:shipLaser];
        }
        
//        self.isTouchEnabled = YES;
        
        _lives = 3;
        double curTime = CACurrentMediaTime();
        _gameOverTime = curTime + 30.0;
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"SpaceGame.caf" loop:YES];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"explosion_large.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"laser_ship.caf"];
    
    }
    return self;
}

- (void)shootBlue{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *shipLaser = [_shipLasers objectAtIndex:_nextShipLaser];
    _nextShipLaser++;
    if (_nextShipLaser >= _shipLasers.count) _nextShipLaser = 0;
    
    shipLaser.position = ccpAdd(_ship.position, ccp(shipLaser.contentSize.width/2, 0));
    shipLaser.visible = YES;
    [shipLaser stopAllActions];
    [shipLaser runAction:[CCSequence actions:
                          [CCMoveBy actionWithDuration:0.5 position:ccp(winSize.width, 0)],
                          [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],
                          nil]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"laser_ship.caf"];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *array = [string componentsSeparatedByString:@","];
    tmpX = [(NSString *)[array objectAtIndex:0]intValue];
    tmpY = [(NSString *)[array objectAtIndex:1]intValue];
    if ([[array objectAtIndex:2] isEqualToString:@"1"]) {
        [self shootBlue];
    }

}

//- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    [[SimpleAudioEngine sharedEngine] playEffect:@"laser_ship.caf"];
//    
//    CGSize winSize = [CCDirector sharedDirector].winSize;
//    
//    CCSprite *shipLaser = [_shipLasers objectAtIndex:_nextShipLaser];
//    _nextShipLaser++;
//    if (_nextShipLaser >= _shipLasers.count) _nextShipLaser = 0;
//    
//    shipLaser.position = ccpAdd(_ship.position, ccp(shipLaser.contentSize.width/2, 0));
//    shipLaser.visible = YES;
//    [shipLaser stopAllActions];
//    [shipLaser runAction:[CCSequence actions:
//                          [CCMoveBy actionWithDuration:0.5 position:ccp(winSize.width, 0)],
//                          [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],
//                          nil]];
//    
//}

//- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
//    
//#define kFilteringFactor 0.1
//#define kRestAccelX -0.6
//#define kShipMaxPointsPerSec (winSize.height*0.5)        
//#define kMaxDiffX 0.2
//    
//    UIAccelerationValue rollingX, rollingY, rollingZ;
//    
//    rollingX = (acceleration.x * kFilteringFactor) + (rollingX * (1.0 - kFilteringFactor));    
//    rollingY = (acceleration.y * kFilteringFactor) + (rollingY * (1.0 - kFilteringFactor));    
//    rollingZ = (acceleration.z * kFilteringFactor) + (rollingZ * (1.0 - kFilteringFactor));
//    
//    float accelX = acceleration.x - rollingX;
//    float accelY = acceleration.y - rollingY;
//    float accelZ = acceleration.z - rollingZ;
//    
//    CGSize winSize = [CCDirector sharedDirector].winSize;
//    
//    float accelDiff = accelX - kRestAccelX;
//    float accelFraction = accelDiff / kMaxDiffX;
//    float pointsPerSec = kShipMaxPointsPerSec * accelFraction;
//    
//    _shipPointsPerSecY = pointsPerSec;
//    
//}

- (float)randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

- (void)restartTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];   
}

- (void)endScene:(EndReason)endReason {
    
    if (_gameOver) return;
    _gameOver = true;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    NSString *message;
    if (endReason == kEndReasonWin) {
        message = @"You win!";
    } else if (endReason == kEndReasonLose) {
        message = @"You lose!";
    }
    
    CCLabelBMFont *label;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial-hd.fnt"];
    } else {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial.fnt"];
    }
    label.scale = 0.1;
    label.position = ccp(winSize.width/2, winSize.height * 0.6);
    [self addChild:label];
    
    CCLabelBMFont *restartLabel;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial-hd.fnt"];    
    } else {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial.fnt"];    
    }
    
    CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restartLabel target:self selector:@selector(restartTapped:)];
    restartItem.scale = 0.1;
    restartItem.position = ccp(winSize.width/2, winSize.height * 0.4);
    
    CCMenu *menu = [CCMenu menuWithItems:restartItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu];
    
    [restartItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    [label runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    
}

- (void)update:(ccTime)dt {
    
    _ship.position = ccp(_ship.position.x + 3 * (tmpX-50.0)/50.0, _ship.position.y + 3 * (tmpY-49.0)/50.0);
    
    CGPoint backgroundScrollVel = ccp(-1000, 0);
    _backgroundNode.position = ccpAdd(_backgroundNode.position, ccpMult(backgroundScrollVel, dt));
    
    NSArray *spaceDusts = [NSArray arrayWithObjects:_spacedust1, _spacedust2, nil];
    for (CCSprite *spaceDust in spaceDusts) {
        if ([_backgroundNode convertToWorldSpace:spaceDust.position].x < -spaceDust.contentSize.width) {
            [_backgroundNode incrementOffset:ccp(2*spaceDust.contentSize.width,0) forChild:spaceDust];
        }
    }
    
    NSArray *backgrounds = [NSArray arrayWithObjects:_planetsunrise, _galaxy, _spacialanomaly, _spacialanomaly2, nil];
    for (CCSprite *background in backgrounds) {
        if ([_backgroundNode convertToWorldSpace:background.position].x < -background.contentSize.width) {
            [_backgroundNode incrementOffset:ccp(2000,0) forChild:background];
        }
    }
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
//    float maxY = winSize.height - _ship.contentSize.height/2;
//    float minY = _ship.contentSize.height/2;
//    
//    float newY = _ship.position.y + (_shipPointsPerSecY * dt);
//    newY = MIN(MAX(newY, minY), maxY);
//    _ship.position = ccp(_ship.position.x, newY);
    
    double curTime = CACurrentMediaTime();
    if (curTime > _nextAsteroidSpawn) {
        
        float randSecs = [self randomValueBetween:0.20 andValue:1.0];
        _nextAsteroidSpawn = randSecs + curTime;
        
        float randY = [self randomValueBetween:0.0 andValue:winSize.height];
        float randDuration = [self randomValueBetween:2.0 andValue:10.0];
        
        CCSprite *asteroid = [_asteroids objectAtIndex:_nextAsteroid];
        _nextAsteroid++;
        if (_nextAsteroid >= _asteroids.count) _nextAsteroid = 0;
        
        [asteroid stopAllActions];
        asteroid.position = ccp(winSize.width+asteroid.contentSize.width/2, randY);
        asteroid.visible = YES;
        [asteroid runAction:[CCSequence actions:
                             [CCMoveBy actionWithDuration:randDuration position:ccp(-winSize.width-asteroid.contentSize.width, 0)],
                             [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],
                             nil]];
        
    }
    
    for (CCSprite *asteroid in _asteroids) {        
        if (!asteroid.visible) continue;
        
        for (CCSprite *shipLaser in _shipLasers) {                        
            if (!shipLaser.visible) continue;
            
            if (CGRectIntersectsRect(shipLaser.boundingBox, asteroid.boundingBox)) {                
                [[SimpleAudioEngine sharedEngine] playEffect:@"explosion_large.caf"];
                shipLaser.visible = NO;
                asteroid.visible = NO;                
                continue;
            }
        }
        
        if (CGRectIntersectsRect(_ship.boundingBox, asteroid.boundingBox)) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"explosion_large.caf"];
            asteroid.visible = NO;
            [_ship runAction:[CCBlink actionWithDuration:1.0 blinks:9]];            
            _lives--;
        }
    }
    
    if (_lives <= 0) {
        [_ship stopAllActions];
        _ship.visible = FALSE;
        [self endScene:kEndReasonLose];
    } else if (curTime >= _gameOverTime) {
        [self endScene:kEndReasonWin];
    }
    
}

- (void)setInvisible:(CCNode *)node {
    node.visible = NO;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
