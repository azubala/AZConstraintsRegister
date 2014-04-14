//  
//  Copyright (c) 2014 Aleksander Zubala All rights reserved.
//  


#import "TestView.h"


@implementation TestView

#pragma mark - Object life cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.subview = [UIView new];
        [self addSubview:self.subview];

        self.metric = @123;
    }

    return self;
}


@end