//
//  ViewController.h
//  test
//
//  Created by zeng le on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedButtonAPI.h"
@interface ViewController : UIViewController<RedButtonAPIDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
