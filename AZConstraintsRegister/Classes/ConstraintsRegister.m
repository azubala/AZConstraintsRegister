//  
//  Copyright (c) 2014 Taptera Inc. All rights reserved.
//  


#import "ConstraintsRegister.h"


@interface ConstraintsRegister ()
@property(nonatomic, weak) UIView *containerView;
@property(nonatomic, strong) NSMutableDictionary *subviewsForAutoLayoutMutable;
@property(nonatomic, strong) NSMutableDictionary *layoutMetricsMutable;
@property(nonatomic, strong) NSMutableArray *registeredConstraintsMutable;
@end


@implementation ConstraintsRegister

#pragma mark - Constants

NSString *const ConstraintRegisterTopKey = @"top";
NSString *const ConstraintRegisterLeftKey = @"left";
NSString *const ConstraintRegisterBottomKey = @"bottom";
NSString *const ConstraintRegisterRightKey = @"right";
NSString *const ConstraintRegisterSpacingKey = @"spacing";

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
    [self registerMetric:@(self.interItemSpacing) forKey:ConstraintRegisterSpacingKey];
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
        [self registerMetric:@(interItemSpacing) forKey:ConstraintRegisterSpacingKey];
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
    [self registerMetric:@(contentInsets.top) forKey:ConstraintRegisterTopKey];
    [self registerMetric:@(contentInsets.left) forKey:ConstraintRegisterLeftKey];
    [self registerMetric:@(contentInsets.bottom) forKey:ConstraintRegisterBottomKey];
    [self registerMetric:@(contentInsets.right) forKey:ConstraintRegisterRightKey];
}
@end