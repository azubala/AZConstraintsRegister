//  
//  Copyright (c) 2014 Aleksander Zubala All rights reserved.
//  


#import "RootView.h"
#import "AZConstraintsRegister.h"

@interface RootView ()
@property(nonatomic, strong) AZConstraintsRegister *constraintsRegister;
@property(nonatomic, strong) UIView *subview;
@end


@implementation RootView

#pragma mark - Object life cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.subview = [UIView new];
        [self.subview setBackgroundColor:[UIColor purpleColor]];
        [self addSubview:self.subview];

        self.constraintsRegister = [AZConstraintsRegister registerWithContainerView:self];
        [self.constraintsRegister registerSubview:self.subview forLayoutKey:@"subview"];
        self.constraintsRegister.contentInsets = UIEdgeInsetsMake(100, 30, 50, 50);

        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Layout

- (void)updateConstraints {
    [self.constraintsRegister beginUpdates];
    [self.constraintsRegister registerConstraintWithFormat:@"|-(left)-[subview]-(right)-|"];
    [self.constraintsRegister registerConstraintWithFormat:@"V:|-(top)-[subview]-(bottom)-|"];
    [self.constraintsRegister endUpdates];
    [super updateConstraints];
}

@end