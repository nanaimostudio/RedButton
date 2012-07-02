//
//  ViewController.m
//  test
//
//  Created by zeng le on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){

}

@end

@implementation ViewController
@synthesize label;
@synthesize textView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    RedButtonAPI *red = [[RedButtonAPI alloc] init];
    red.delegate = self;
    self.textView.text = @"";
}


- (void)viewDidUnload
{
    [self setLabel:nil];
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)receivedRawDataFromArduino:(NSString *)data{
    self.textView.text = [self.textView.text stringByAppendingFormat:data];
}

- (void)buttonAPressed{
    NSLog(@"buttonA pressed");
}

- (void)buttonBPressed{
    NSLog(@"buttonB pressed");
}

- (void)buttonCPressed{
    NSLog(@"buttonC pressed");
}

- (void)joystickDataofX:(NSString *)xData Y:(NSString *)yData{
    NSLog(@"joyStickX = %@, joyStickY = %@",xData,yData);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
