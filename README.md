# AZConstraintsRegister

Lightweight tool to manage Auto Layout constraints using Visual Format Language.

## Usage

### Basic example 

Let's say you have a view with one subview, something like that:

```objective-c
@interface MyView : UIView
@property (nonatomic, strong) UIView *mySubview;
@property (nonatomic, strong) AZConstraintsRegister *constraintsRegister;
@end
```
In order to use the register, you need to do two things. First you need to register container view and its subviews which will be used for AutoLayout. You can do it in your initialiser:

```objective-c
- (id)initWithFrame:(CGRect)rect {
	self = [super initWithFrame:rect];
	if (self) {		
		self.subview = [UIView new];
		[self addSubview:self.subview];

		self.constraintsRegister = [AZConstraintsRegister registerWithContainerView:self];
		[self.constraintsRegister registerSubview:self.subview forLayoutKey:@"subview"];				
	}
	return self;
}
```
You can also use the variable bindings macro for registering metrics and subview, check the section [NSDictionaryOfVariableBindings](#nsdictionaryofvariablebindings) to see how the register handles those bindings.

Now you can enjoy the register simplicity, just add VFL constraints to the view between calls of `beginUpdates` and `endUpdates`:

```objective-c
[self.constraintsRegister beginUpdates]; // clears previous state
[self.constraintsRegister registerFormat:@"|-[subview]-|"];
[self.constraintsRegister registerFormat:@"V:|-[subview]-|"];
[self.constraintsRegister endUpdates]; //submits created constraints to the view
```

For less code you can use bulk format register:

```objective-c
[self.constraintsRegister beginUpdates]; // clears previous state
[self.constraintsRegister registerFormats:@[
    @"|-(left)-[subview]-(right)-|",
    @"V:|-(top)-[subview]-(bottom)-|"
]];
[self.constraintsRegister endUpdates]; //submits created constraints to the view
```

You can either do this once in the initliser for static constraints or, if you need more dynamic behavior, in the `updateConstraints`:

```objective-c
- (void)updateConstraints {
	[self.constraintsRegister beginUpdates]; // clears previous state	
	[self.constraintsRegister registerFormat:@"|-[subview]-|"];
	[self.constraintsRegister registerFormat:@"V:|-[subview]-|"];
	[self.constraintsRegister endUpdates]; //submits created constraints to the view
	[super updateConstraints];
}
```

In this case remember to call somewhere `setNeedsUpdateConstraints` otherwise `updateConstraints` won't be fired.

And that's pretty much it! It's worth mentioning that `AZConstraintsRegister` tracks every constraints which were registered so it does not conflict with existing ones or added externally.

The cool thing about the register is that makes code cleaner, you don't have to use this long `NSLayoutConstraint` methods. 

### Fain-grained control: metrics

When creating `NSLayoutConstraint` you can provide `metrics` dictionary, where you can specify named values, which later can be referenced in VFL. For example:

```objective-c
NSDictionary *views = @{
	@"subview" : self.subview
};
NSDictionary *metrics = @{
	@"mySpacing" : @(20.0f)
};
NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(mySpacing)-[subview]-|" 
                                                               options:0 
                                                               metrics:metrics
                                                                 views:views];

```

That's pretty cool but makes code long and not nice to read. The `AZConstraintsRegister` comes to the rescue! Whenever you would like to register a metric for VFL, you can do it like so:

```objective-c
[self.constraintsRegister registerMetric:@(20.0f) forKey:@"mySpacing"];
```
or
```objective-c
[self.constraintsRegister registerMetrics:@{
    @"mySpacing" : @(20.0f)
}];
```

And then you can refer to `mySpacing` in your VFL.

By default `AZConstraintsRegister` comes with two default metrics, which are exposed as properties:
```objective-c
@property(nonatomic) UIEdgeInsets contentInsets;
@property(nonatomic) CGFloat interItemSpacing;
```
These are dynamic properties, which updates metrics when set. Which allows you to easily set metrics and use predefined metrics keys in your VFL:

```objective-c
extern NSString *const AZConstraintRegisterTopKey; //based on contentInsets.top,
extern NSString *const AZConstraintRegisterLeftKey; //based on contentInsets.left,
extern NSString *const AZConstraintRegisterBottomKey; //based on contentInsets.bottom
extern NSString *const AZConstraintRegisterRightKey; //based on contentInsets.right
extern NSString *const AZConstraintRegisterSpacingKey; //based on interItemSpacing
```

For example:

```objective-c
[self.constraintsRegister registerConstraintWithFormat:@"|-(left)-[subview]-(right)-|"];
[self.constraintsRegister registerConstraintWithFormat:@"V:|-(top)-[subview]-(bottom)-|"];
```

### NSDictionaryOfVariableBindings

Together with the Auto Layout, Apple has introduced the helper macro `NSDictionaryOfVariableBindings` which creates quickly a dictionary with provided variables. It works fine, but breaks VFL when you register properties like so:
```objective-c
NSDictionary *bindings = NSDictionaryOfVariableBindings(self.subview)
```
The key in `bindings` for the subview will be `self.subview` and if you reference it in VFL it will fail with an exception. To make use of the cool macro and be able to use it with properties `AZConstraintsRegister` comes with the two helper methods:
```objective-c
- (void)registerSubviewsWithVariableBindings:(NSDictionary *)variableBindings;
- (void)registerMetricsWithVariableBindings:(NSDictionary *)metricsBindings;
```

Which basically strips out key path from keys in the binding dictionary, which reduces code and let you do the following:

```objective-c
NSDictionary *bindings = NSDictionaryOfVariableBindings(self.subview);
[self.constraintsRegister registerSubviewsWithVariableBindings:bindings];
[self.constraintsRegister registerFormat:@"|-[subview]-|"]
```

### Demo project
To run the example project; clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS SDK 6 and newer (Auto Layout was introduced for this version)

## Installation

AZConstraintsRegister is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "AZConstraintsRegister"

## Author

Aleksander Zubala, alek.zubala@gmail.com

## License

AZConstraintsRegister is available under the MIT license. See the LICENSE file for more info.

