//  
//  Copyright (c) 2014 Aleksander Zubala. All rights reserved.
//  


#import "AZConstraintsRegister.h"


@interface AZConstraintsRegister ()
@property(nonatomic, weak) UIView *containerView;
@property(nonatomic, strong) NSMutableDictionary *subviewsForAutoLayoutMutable;
@property(nonatomic, strong) NSMutableDictionary *layoutMetricsMutable;
@property(nonatomic, strong) NSMutableArray *registeredConstraintsMutable;
@end


@implementation AZConstraintsRegister

#pragma mark - Constants

NSString *const AZConstraintRegisterTopKey = @"top";
NSString *const AZConstraintRegisterLeftKey = @"left";
NSString *const AZConstraintRegisterBottomKey = @"bottom";
NSString *const AZConstraintRegisterRightKey = @"right";
NSString *const AZConstraintRegisterSpacingKey = @"spacing";

#pragma mark - Object life cycle

- (id)init {
    self = [super init];
    if (self) {
        self.subviewsForAutoLayoutMutable = [NSMutableDictionary new];
        self.registeredConstraintsMutable = [NSMutableArray new];
        [self initializeDefaultLayoutMetrics];
    }
    return self;
}

- (void)initializeDefaultLayoutMetrics {
    self.layoutMetricsMutable = [NSMutableDictionary new];
    [self registerContentInsetsMetric:self.contentInsets];
    [self registerMetric:@(self.interItemSpacing) forKey:AZConstraintRegisterSpacingKey];
}

#pragma mark - Dynamic accessors

- (NSDictionary *)subviewsForAutoLayout {
    return self.subviewsForAutoLayoutMutable;
}

- (NSDictionary *)layoutMetrics {
    return self.layoutMetricsMutable;
}

- (NSArray *)registeredConstraints {
    return self.registeredConstraintsMutable;
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(_contentInsets, contentInsets)) {
        _contentInsets = contentInsets;
        [self registerContentInsetsMetric:contentInsets];
    }
}

- (void)setInterItemSpacing:(CGFloat)interItemSpacing {
    if (_interItemSpacing != interItemSpacing) {
        _interItemSpacing = interItemSpacing;
        [self registerMetric:@(interItemSpacing) forKey:AZConstraintRegisterSpacingKey];
    }
}

#pragma mark - Public methods

- (void)registerContainerView:(UIView *)view {
    self.containerView = view;
}

- (void)unregisterContainerView {
    [self.containerView removeConstraints:self.registeredConstraints];
    [self.subviewsForAutoLayoutMutable removeAllObjects];
    [self.registeredConstraintsMutable removeAllObjects];
    [self initializeDefaultLayoutMetrics];
    self.containerView = nil;
}


- (void)registerSubviewForAutoLayout:(UIView *)view forLayoutKey:(NSString *)layoutKey {
    if ([view isDescendantOfView:self.containerView] && layoutKey) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        self.subviewsForAutoLayoutMutable[layoutKey] = view;
    }
}

- (void)registerMetric:(NSNumber *)metricValue forKey:(NSString *)metricKey {
    if (metricKey && metricValue) {
        self.layoutMetricsMutable[metricKey] = metricValue;
    }
}

- (void)beginUpdates {
    [self.containerView removeConstraints:self.registeredConstraints];
    [self.registeredConstraintsMutable removeAllObjects];
}

- (void)endUpdates {
    [self.containerView addConstraints:self.registeredConstraints];
}

- (void)registerConstraintWithFormat:(NSString *)format {
    [self registerConstraintWithFormat:format formatOptions:0];
}

- (void)registerConstraint:(NSLayoutConstraint *)constraint {
    [self.registeredConstraintsMutable addObject:constraint];
}

- (void)registerConstraintWithFormat:(NSString *)format formatOptions:(NSLayoutFormatOptions)formatOptions {
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:formatOptions metrics:self.layoutMetrics views:self.subviewsForAutoLayout];
    [self.registeredConstraintsMutable addObjectsFromArray:constraints];
}

#pragma mark - Private methods

- (void)registerContentInsetsMetric:(UIEdgeInsets)contentInsets {
    [self registerMetric:@(contentInsets.top) forKey:AZConstraintRegisterTopKey];
    [self registerMetric:@(contentInsets.left) forKey:AZConstraintRegisterLeftKey];
    [self registerMetric:@(contentInsets.bottom) forKey:AZConstraintRegisterBottomKey];
    [self registerMetric:@(contentInsets.right) forKey:AZConstraintRegisterRightKey];
}
@end