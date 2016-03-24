//
//  BMCustomTextField.m
//  BMLOL
//
//  Created by donglei on 3/10/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import "BMCustomTextField.h"

@interface BMCustomTextField()
@property(nonatomic,weak) UIView *namePassView;
@end

@implementation BMCustomTextField
+(instancetype)customTextField:(UIView *) superView{
    BMCustomTextField *custom  = [[BMCustomTextField alloc] init];

    if (custom) {
        
        custom.namePassView = superView;
    }
    return custom;
}
-(CGRect) textRectForBounds:(CGRect)bounds{
    return CGRectMake(10, 5, _namePassView.bounds.size.width-10, _namePassView.bounds.size.height);
}
- (CGRect)editingRectForBounds:(CGRect)bounds{
      return CGRectMake(10, 5, _namePassView.bounds.size.width-10, _namePassView.bounds.size.height);
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    return CGRectMake(10, 5, _namePassView.bounds.size.width-10, _namePassView.bounds.size.height);
}


@end
