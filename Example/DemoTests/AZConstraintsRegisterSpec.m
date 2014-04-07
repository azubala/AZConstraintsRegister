#import "Specta.h"
#import "AZConstraintsRegister.h"
#import "NSLayoutConstraint+AZComparing.h"

SpecBegin(AZConstraintsRegister)

        __block AZConstraintsRegister *constraintsRegister;

        beforeEach(^{
            constraintsRegister = [AZConstraintsRegister new];
        });

        it(@"should have default edge insets set", ^{
            expect(constraintsRegister.layoutMetrics[AZConstraintRegisterTopKey]).to.equal(0);
            expect(constraintsRegister.layoutMetrics[AZConstraintRegisterLeftKey]).to.equal(0);
            expect(constraintsRegister.layoutMetrics[AZConstraintRegisterBottomKey]).to.equal(0);
            expect(constraintsRegister.layoutMetrics[AZConstraintRegisterRightKey]).to.equal(0);
        });

        describe(@"creating with container view", ^{
            __block UIView *testView;
            beforeEach(^{
                testView = [UIView new];
                constraintsRegister = [AZConstraintsRegister registerWithContainerView:testView];
            });
            it(@"should update view property", ^{
                expect(constraintsRegister.containerView).to.equal(testView);
            });
        });

        describe(@"register view for auto layout", ^{
            __block UIView *testView;
            beforeEach(^{
                testView = [UIView new];
                [constraintsRegister registerContainerView:testView];
            });
            it(@"should update view property", ^{
                expect(constraintsRegister.containerView).to.equal(testView);
            });
        });

        describe(@"unregister view", ^{
            __block UIView *testView;
            __block UIView *testSubview;
            __block NSArray *registeredConstraints;
            beforeEach(^{
                testView = [UIView new];
                testSubview = [UIView new];
                [testView addSubview:testSubview];

                [constraintsRegister registerContainerView:testView];
                [constraintsRegister registerSubview:testSubview forLayoutKey:@"subview"];
                [constraintsRegister beginUpdates];
                [constraintsRegister registerFormat:@"|-left-[subview]-right-|"];
                [constraintsRegister registerFormat:@"V:|-top-[subview]-bottom-|"];
                [constraintsRegister registerMetric:@(123) forKey:@"Test"];
                [constraintsRegister endUpdates];
                registeredConstraints = constraintsRegister.registeredConstraints;

                [constraintsRegister unregisterContainerView]; // action
            });

            it(@"should clear the view property", ^{
                expect(constraintsRegister.containerView).to.beNil();
            });
            it(@"should clear registered subviews", ^{
                expect([constraintsRegister.subviewsForAutoLayout allValues]).to.haveCountOf(0);
            });
            it(@"should remove all constraints from container view", ^{
                for (NSLayoutConstraint *registeredConstraint in registeredConstraints) {
                    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint *evaluatedObject, NSDictionary *bindings) {
                        return [registeredConstraint az_isEqualToConstraint:evaluatedObject];
                    }];
                    expect([testView.constraints filteredArrayUsingPredicate:predicate]).to.haveCountOf(0);
                }
            });
            it(@"should clear registered constraints", ^{
                expect([constraintsRegister registeredConstraints]).to.haveCountOf(0);
            });
            it(@"should clear registered metrics", ^{
                AZConstraintsRegister *cleanRegister = [AZConstraintsRegister new];
                expect(constraintsRegister.layoutMetrics).to.equal(cleanRegister.layoutMetrics);
            });
        });

        describe(@"registering view", ^{
            __block UIView *testView;
            __block UIView *testSubview;
            __block NSString *subviewLayoutKey;
            beforeEach(^{
                testView = [UIView new];
                [constraintsRegister registerContainerView:testView];
                testSubview = [UIView new];
                subviewLayoutKey = @"testSubview";
            });
            context(@"which is subview of container view", ^{
                beforeEach(^{
                    [testView addSubview:testSubview];
                    [constraintsRegister registerSubview:testSubview forLayoutKey:subviewLayoutKey]; //action
                });
                it(@"should add a new key to subview for auto layout dictionary", ^{
                    expect([[constraintsRegister subviewsForAutoLayout] allKeys]).to.contain(subviewLayoutKey);
                });
                it(@"should add a view to subview for auto layout dictionary ", ^{
                    expect([[constraintsRegister subviewsForAutoLayout] allValues]).to.contain(testSubview);
                });

                it(@"should disable translate autoresizing masks to constraints", ^{
                    expect(testSubview.translatesAutoresizingMaskIntoConstraints).to.beFalsy();
                });
            });
            context(@"which is not a subview of container view", ^{
                beforeEach(^{
                    [constraintsRegister registerSubview:testSubview forLayoutKey:subviewLayoutKey]; //action
                });
                it(@"should NOT add a new key to subview for auto layout dictionary", ^{
                    expect([[constraintsRegister subviewsForAutoLayout] allKeys]).notTo.contain(subviewLayoutKey);
                });
                it(@"should NOT add a view to subview for auto layout dictionary ", ^{
                    expect([[constraintsRegister subviewsForAutoLayout] allValues]).notTo.contain(testSubview);
                });
            });
        });

        describe(@"registering metric", ^{

            __block NSString *metricKey;
            __block NSNumber *metricValue;

            beforeEach(^{
                metricKey = @"test-metric";
                metricValue = @(1.245f);

                [constraintsRegister registerMetric:metricValue forKey:metricKey]; //action
            });

            it(@"should update metrics dictionary", ^{
                expect(constraintsRegister.layoutMetrics[metricKey]).to.equal(metricValue);
            });
        });

        describe(@"default metric", ^{
            context(@"content insets", ^{
                __block UIEdgeInsets testEdgeInsets;
                beforeEach(^{
                    testEdgeInsets = UIEdgeInsetsMake(10, 20, 30, 40);
                    constraintsRegister.contentInsets = testEdgeInsets; //action
                });

                it(@"should be present in the metrics dict with value based on property", ^{
                    expect(constraintsRegister.layoutMetrics[AZConstraintRegisterTopKey]).to.equal(testEdgeInsets.top);
                    expect(constraintsRegister.layoutMetrics[AZConstraintRegisterLeftKey]).to.equal(testEdgeInsets.left);
                    expect(constraintsRegister.layoutMetrics[AZConstraintRegisterBottomKey]).to.equal(testEdgeInsets.bottom);
                    expect(constraintsRegister.layoutMetrics[AZConstraintRegisterRightKey]).to.equal(testEdgeInsets.right);
                });
            });
            context(@"inter item spacing", ^{
                __block CGFloat testInterItemSpacing;
                beforeEach(^{
                    testInterItemSpacing = 10.0f;
                    constraintsRegister.interItemSpacing = testInterItemSpacing;
                });

                it(@"should be present in the metrics dict with value based on property", ^{
                    expect(constraintsRegister.layoutMetrics[AZConstraintRegisterSpacingKey]).to.equal(testInterItemSpacing);
                });
            });
        });

        describe(@"register constraint", ^{
            __block NSLayoutConstraint *constraint;
            beforeEach(^{
                constraint = [[NSLayoutConstraint alloc] init];
                [constraintsRegister registerConstraint:constraint]; //action
            });
            it(@"should add constraint ", ^{
                expect(constraintsRegister.registeredConstraints).to.contain(constraint);
            });
        });

        describe(@"register constraints", ^{

            __block UIView *testView;
            __block UIView *testSubview;
            __block NSString *subviewKey;
            __block NSLayoutFormatOptions formatOptions;


            beforeEach(^{
                formatOptions = 0;
                subviewKey = @"subview";
                testView = [UIView new];
                testSubview = [UIView new];
                [testView addSubview:testSubview];
                [constraintsRegister registerContainerView:testView];
                [constraintsRegister registerSubview:testSubview forLayoutKey:subviewKey];
                constraintsRegister.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            });

            context(@"with format", ^{
                __block NSString *format;

                sharedExamplesFor(@"register update", ^(NSDictionary *sharedContext) {
                    it(@"should add constraints to register", ^{
                        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                                       options:formatOptions
                                                                                       metrics:constraintsRegister.layoutMetrics
                                                                                         views:constraintsRegister.subviewsForAutoLayout];
                        NSEnumerator *enumerator = [constraintsRegister.registeredConstraints objectEnumerator];
                        for (NSLayoutConstraint *constraint in constraints) {
                            NSLayoutConstraint *registeredConstraint = [enumerator nextObject];
                            expect([constraint az_isEqualToConstraint:registeredConstraint]).to.beTruthy();
                        }
                    });
                });

                beforeEach(^{
                    format = @"|-left-[subview]-right-|";
                });

                context(@"and without layout format", ^{
                    beforeEach(^{
                        [constraintsRegister registerFormat:format];
                    });
                    itShouldBehaveLike(@"register update", @{});
                });
                context(@"and layout format", ^{
                    beforeEach(^{
                        formatOptions = NSLayoutFormatAlignAllCenterY;
                        [constraintsRegister registerFormat:format formatOptions:formatOptions]; //action
                    });
                    itShouldBehaveLike(@"register update", @{});
                });
            });

            context(@"from array", ^{
                __block NSArray *formats;
                beforeEach(^{
                    formats = @[
                        @"|-left-[subview]-right-|",
                        @"V:|-top-[subview]-bottom-|"
                    ];
                    [constraintsRegister registerFormats:formats];
                });
                it(@"should add all constraints from formats", ^{
                    NSMutableArray *constraints = [NSMutableArray new];
                    for (NSString *format in formats) {
                        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:format
                                                                                                 options:formatOptions
                                                                                                 metrics:constraintsRegister.layoutMetrics
                                                                                                   views:constraintsRegister.subviewsForAutoLayout]];
                    }
                    NSEnumerator *enumerator = [constraintsRegister.registeredConstraints objectEnumerator];
                    for (NSLayoutConstraint *constraint in constraints) {
                        NSLayoutConstraint *registeredConstraint = [enumerator nextObject];
                        expect([constraint az_isEqualToConstraint:registeredConstraint]).to.beTruthy();
                    }
                });
            });

        });

        describe(@"begin updates", ^{
            __block UIView *testView;
            __block UIView *subview;
            __block NSString *subviewKey;
            beforeEach(^{
                subviewKey = @"subview";
                testView = [UIView new];
                subview = [UIView new];
                [testView addSubview:subview];
                [constraintsRegister registerContainerView:testView];
                constraintsRegister.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
                [constraintsRegister registerSubview:subview forLayoutKey:subviewKey];

                [constraintsRegister beginUpdates];
                [constraintsRegister registerFormat:@"V:|-top-[subview]-bottom-|"];
                [constraintsRegister endUpdates];


                [constraintsRegister beginUpdates]; //action
            });

            it(@"should remove all registered constraints", ^{
                for (NSLayoutConstraint *layoutConstraint in constraintsRegister.registeredConstraints) {
                    expect(constraintsRegister.containerView.constraints).notTo.contain(layoutConstraint);
                }
            });
            it(@"should clear registered constraints", ^{
                expect(constraintsRegister.registeredConstraints).to.haveCountOf(0);
            });
        });

        describe(@"end updates", ^{
            __block UIView *testView;
            __block UIView *subview;
            __block NSString *subviewKey;

            beforeEach(^{
                subviewKey = @"subview";
                testView = [UIView new];
                subview = [UIView new];
                [testView addSubview:subview];
                [constraintsRegister registerContainerView:testView];
                constraintsRegister.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
                [constraintsRegister registerSubview:subview forLayoutKey:subviewKey];
                [constraintsRegister registerFormat:@"V:|-top-[subview]-bottom-|"];

                [constraintsRegister endUpdates]; //action
            });

            it(@"should add all registered constraints to view", ^{
                for (NSLayoutConstraint *layoutConstraint in constraintsRegister.registeredConstraints) {
                    expect(constraintsRegister.containerView.constraints).to.contain(layoutConstraint);
                }
            });
        });
        SpecEnd