//  
//  Copyright (c) 2014 Aleksander Zubala. All rights reserved.
//  


#import "NSLayoutConstraint+AZComparing.h"


@implementation NSLayoutConstraint (AZComparing)
- (BOOL)az_isEqualToConstraint:(NSLayoutConstraint *)constraint {
    return [constraint.firstItem isEqual:self.firstItem] &&
        constraint.firstAttribute == self.firstAttribute &&
        constraint.relation == self.relation &&
        [constraint.secondItem isEqual:self.secondItem] &&
        constraint.secondAttribute == self.secondAttribute &&
        constraint.multiplier == self.multiplier &&
        constraint.constant == self.constant &&
        constraint.priority == self.priority &&
        constraint.shouldBeArchived == self.shouldBeArchived;
}
@end