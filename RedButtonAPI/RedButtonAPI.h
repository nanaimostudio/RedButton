//
//  RedButtonAPI.h
//  RedButtonAPI
//
//  Created by zeng le on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RedButtonAPIDelegate <NSObject>
@optional
- (void)receivedRawDataFromArduino:(NSString *)data;
- (void)receivedRawDataFromArduinoWithRedundantCheck:(NSString *)data;
- (void)buttonAPressed;
- (void)buttonBPressed;
- (void)buttonCPressed;
- (void)joystickDataofX:(NSString *)xData
                      Y:(NSString *)yData;
@end

@interface RedButtonAPI : NSObject

@property (nonatomic, weak) id<RedButtonAPIDelegate> delegate;
-(id)init;

@end
