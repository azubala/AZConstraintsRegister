//  
//  Copyright (c) 2014 Taptera Inc. All rights reserved.
//  


#import <Foundation/Foundation.h>

@interface ConstraintsRegister : NSObject
@property(nonatomic, readonly, weak) UIView *containerView;
@property(nonatomic, readonly) NSDictionary *subviewsForAutoLayout;
@property(nonatomic, readonly) NSDictionary *layoutMetrics;

@property(nonatomic, readonly, strong) NSArray *registeredConstraints;

@property(nonatomic) UIEdgeInsets contentInsets;
@property(nonatomic) CGFloat interItemSpacing;

- (void)registerContainerView:(UIView *)view;
- (void)unregisterContainerView;

- (void)registerSubviewForAutoLayout:(UIView *)view forLayoutKey:(NSString *)layoutKey;
- (void)registerMetric:(NSNumber *)metricValue forKey:(NSString *)metricKey;

- (void)beginUpdates;
- (void)endUpdates;

- (void)registerConstraintWithFormat:(NSString *)format;
- (void)registerConstraint:(NSLayoutConstraint *)constraint;
- (void)registerConstraintWithFormat:(NSString *)format formatOptions:(NSLayoutFormatOptions)formatOptions;


@end

// Layout predefined keys, which can be used in VFL in constraints
extern NSString *const ConstraintRegisterTopKey; //based on contentInsets.top,
extern NSString *const ConstraintRegisterLeftKey; //based on contentInsets.left,
extern NSString *const ConstraintRegisterBottomKey; //based on contentInsets.bottom
extern NSString *const ConstraintRegisterRightKey; //based on contentInsets.right
extern NSString *const ConstraintRegisterSpacingKey; //based on interItemSpacing
