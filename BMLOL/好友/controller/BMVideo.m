//
//  BMVideo.m
//  BMLOL
//
//  Created by donglei on 16/5/12.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMVideo.h"
#import <AVFoundation/AVFoundation.h>

@implementation BMVideo


-(void)viewDidLoad{
    [super viewDidLoad];
      AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"]];
    
     AVPlayer *avplayer = [AVPlayer playerWithPlayerItem:item];
    
    AVPlayerLayer *avplayerLayer = [AVPlayerLayer playerLayerWithPlayer:avplayer];
    avplayerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view.layer addSublayer:avplayerLayer];
    [avplayer play];
}


-(void)didReceiveMemoryWarning{
    NSLog(@"didReceiveMemoryWarning");
}
@end
