# AZConstraintsRegister CHANGELOG

## 0.1.5
- added new method:
 ```
 - (void)registerFormats:(NSArray *)constraintsFormats formatOptions:(NSLayoutFormatOptions)formatOptions;
 ```

- added new method:
 ```
 - (void)registerSubview:(UIView *)view forLayoutKey:(NSString *)layoutKey disableAutoresizingMaskTranslation:(BOOL)disableTranslation;
 ```


## 0.1.4
- fixes an issue when registering subiview or metrics with variable bindings, when plain variable with dot notation was provided to the `NSDictionaryOfVariableBindings` it was not registered;

## 0.1.3

- Added new methods to bulk register of subviews, metrics and `NSLayoutConstraint` objects:
```objective-c
- (void)registerSubviews:(NSDictionary *)subviewsMapping;
- (void)registerMetrics:(NSDictionary *)metricsMapping;
- (void)registerConstraints:(NSArray *)constraints;
```

- Added two methods to register subviews and metrics using `NSDictionaryOfVariableBindings` macro:
```objective-c
- (void)registerSubviewsWithVariableBindings:(NSDictionary *)variableBindings;
- (void)registerMetricsWithVariableBindings:(NSDictionary *)metricsBindings;
```

## 0.1.2

- Added new method for bulk register constraints: `registerFormats:`;
- Renamed `registerConstraintWithFormat:` to shorter `registerFormat:`
- Renamed `registerConstraintWithFormat:formatOption:` to shorter `registerFormat:formatOption:`

## 0.1.1

Initial release.

