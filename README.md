# AZConstraintsRegister

[![Version](http://cocoapod-badges.herokuapp.com/v/AZConstraintsRegister/badge.png)](http://cocoadocs.org/docsets/AZConstraintsRegister)
[![Platform](http://cocoapod-badges.herokuapp.com/p/AZConstraintsRegister/badge.png)](http://cocoadocs.org/docsets/AZConstraintsRegister)

## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

Let's say you have a view with one subview, something like that:

```objective-c
@interface MyView : UIView
@property (nonatomic, strong) UIView *mySubview;
@end
```
In order to use the constraints register, all you need to do is:

```objective-c

@interface MyView ()
@property (nonatomic, strong) AZConstraintsRegister *constraintsRegister;
@end

@implementation MyView : UIView

- (id)initWithFrame:(CGRect)rect {
	self = [super initWithFrame:rect];
	if (self) {		
		self.subview = [UIView new];
		[self addSubview:self.subview];

		self.constraintsRegister = [AZConstraintsRegister new];
		[self.constraintsRegister registerContainerView:self];
		[self.constraintsRegister registerSubviewForAutoLayout:self.subview forLayoutKey:@"subview"];
	}
	return self;
}

- (void)updateConstraints {
	[self.constraintsRegister beginUpdates]

	[self.constraintsRegister registerConstraintWithFormat:@"|-[subview]-|"];
	[self.constraintsRegister registerConstraintWithFormat:@"V:|-[subview]-|"];

	[self.constraintsRegister endUpdates]
	[super updateConstraints]
}

@end
```

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

