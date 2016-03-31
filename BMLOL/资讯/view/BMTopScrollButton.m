//
//  BMTopScrollButton.m
//  BMLOL
//
//  Created by donglei on 3/31/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import "BMTopScrollButton.h"
#import "BMNewsPhoneModel.h"

@interface BMTopScrollButton()

@property(nonatomic,copy) NSString *buttonName;

@end

@implementation BMTopScrollButton


+(instancetype)topScrollButtonDict:(BMNewsPhoneModel *)buttonDict
{
   
    return [[self alloc] initTopScrollButtonWithDict:buttonDict];
    
}

-(instancetype) initTopScrollButtonWithDict:(BMNewsPhoneModel *)buttonDict
{
    if (self = [super init]) {
        
        [self setTitle:buttonDict.name forState:UIControlStateNormal];
       
    }
    return self;
}

-(BOOL)isHighlighted
{
    self.titleLabel.font = [UIFont systemFontOfSize:20.f];
    return YES;
}

@end
