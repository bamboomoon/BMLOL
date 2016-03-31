//
//  BMTopScrollButton.h
//  BMLOL
//
//  Created by donglei on 3/31/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMNewsPhoneModel;

@interface BMTopScrollButton : UIButton

/**
 *  通过静态方法创建对象
 *
 *  @param buttonDict newSPhoneModel
 *
 *  @return 实例对象
 */
+(instancetype) topScrollButtonDict:(BMNewsPhoneModel *) buttonDict;

-(instancetype) initTopScrollButtonWithDict:(BMNewsPhoneModel *) buttonDict;
@end
