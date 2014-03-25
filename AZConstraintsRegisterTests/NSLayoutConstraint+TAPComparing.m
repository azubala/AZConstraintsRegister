//  
//  Copyright (c) 2014 Taptera Inc. All rights reserved.
//  


#import "NSLayoutConstraint+TAPComparing.h"


@implementation NSLayoutConstraint (TAPComparing)
- (BOOL)tap_isEqualToConstraint:(NSLayoutConstraint *)constraint {
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