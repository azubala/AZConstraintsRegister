//  
//  Copyright (c) 2014 Aleksander Zubala. All rights reserved.
//  


#import <Foundation/Foundation.h>

@interface AZConstraintsRegister : NSObject
@property(nonatomic, readonly, weak) UIView *containerView;
@property(nonatomic, readonly) NSDictionary *subviewsForAutoLayout;
@property(nonatomic, readonly) NSDictionary *layoutMetrics;

@property(nonatomic, readonly, strong) NSArray *registeredConstraints;

@property(nonatomic) UIEdgeInsets contentInsets;
@property(nonatomic) CGFloat interItemSpacing;

+ (instancetype)registerWithContainerView:(UIView *)view;

- (void)registerContainerView:(UIView *)view;
- (void)unregisterContainerView;

- (void)registerSubview:(UIView *)view forLayoutKey:(NSString *)layoutKey; //by default it disables translatesAutoresizingMaskIntoConstraints of the view
- (void)registerSubview:(UIView *)view forLayoutKey:(NSString *)layoutKey disableAutoresizingMaskTranslation:(BOOL)disableTranslation;
- (void)registerMetric:(NSNumber *)metricValue forKey:(NSString *)metricKey;

- (void)beginUpdates;
- (void)endUpdates;

- (void)registerFormat:(NSString *)constraintsFormat;
- (void)registerFormat:(NSString *)constraintsFormat formatOptions:(NSLayoutFormatOptions)formatOptions;

- (void)registerFormats:(NSArray *)constraintsFormats;
- (void)registerFormats:(NSArray *)constraintsFormats formatOptions:(NSLayoutFormatOptions)formatOptions;

- (void)registerConstraint:(NSLayoutConstraint *)constraint;

- (void)registerSubviews:(NSDictionary *)subviewsMapping;
- (void)registerMetrics:(NSDictionary *)metricsMapping;
- (void)registerConstraints:(NSArray *)constraints;

- (void)registerSubviewsWithVariableBindings:(NSDictionary *)variableBindings;
- (void)registerMetricsWithVariableBindings:(NSDictionary *)metricsBindings;


@end

// Layout predefined keys, which can be used in VFL in constraints
extern NSString *const AZConstraintRegisterTopKey; //based on contentInsets.top,
extern NSString *const AZConstraintRegisterLeftKey; //based on contentInsets.left,
extern NSString *const AZConstraintRegisterBottomKey; //based on contentInsets.bottom
extern NSString *const AZConstraintRegisterRightKey; //based on contentInsets.right
extern NSString *const AZConstraintRegisterSpacingKey; //based on interItemSpacing
