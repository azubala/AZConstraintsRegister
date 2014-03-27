//  
//  Copyright (c) 2014 Aleksander Zubala All rights reserved.
//  


#import "RootViewController.h"
#import "RootView.h"


@implementation RootViewController

#pragma mark - View life cycle

- (void)loadView {
    self.view = [RootView new];
}

@end