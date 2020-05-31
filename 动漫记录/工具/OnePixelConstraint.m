//
//  OnePixelConstraint.m

//
//  Created by beyond on 16/8/15.
//  Copyright © 2016年 beyond. All rights reserved.
//

#import "OnePixelConstraint.h"

@implementation OnePixelConstraint
-(void)awakeFromNib
{
    [super awakeFromNib];
    if (self.constant ==1) {
        self.constant=1/[UIScreen mainScreen].scale;
    }
}
@end
