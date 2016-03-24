//
//  BMTabBarBtn.h
//  BMLOL
//
//  Created by donglei on 2/27/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
@interface BMTabBarBtn : UIButton
+(instancetype)createBtnNormalImage:(NSString *)normalName selectedImageName:(NSString*) selectedName title:(NSString *)titileName;
@end
