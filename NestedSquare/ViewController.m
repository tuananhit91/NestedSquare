//
//  ViewController.m
//  NestedSquare
//
//  Created by admin on 7/29/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
{
    NSTimer* _timer;
    AVAudioPlayer* player;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self drawNestedSquare];
    [self performSelector:@selector(rotateAllSquares)
               withObject:nil
               afterDelay:1];
    //_timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(rotateAllSquares) userInfo:nil repeats:YES];
    NSURL* urlSound = [[NSBundle mainBundle] URLForResource:@"AoAmBaoHap" withExtension:@"mp3"];
    [self soundNestedSquare:urlSound];
}

- (void) soundNestedSquare:(NSURL*) url{
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    player.numberOfLoops = -1;
    [player play];
}

- (void) drawNestedSquare{
    CGSize mainViewSize = self.view.bounds.size;
    CGFloat margin = 20;
    CGFloat recWidth = mainViewSize.width - margin * 2.0;
    CGFloat statusNavigationBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.bounds.size.height;
    
    CGPoint center = CGPointMake(mainViewSize.width * 0.5, (mainViewSize.height + statusNavigationBarHeight) * 0.5);
    for (int i = 0; i < 10; i++) {
        UIView* square;
        if (i % 2 == 0) {
            square = [self drawSquareByWidth:recWidth
                                   andRotate:false atCenter:center];
        }else{
            square = [self drawSquareByWidth:recWidth
                               andRotate:true atCenter:center];
        }
        [self.view addSubview:square];
        recWidth = recWidth * 0.707;
    }
}

-(UIView*) drawSquareByWidth: (CGFloat) width
                   andRotate: (BOOL) rotate
                    atCenter: (CGPoint) center{
    UIView* square =[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    square.center = center;
    square.backgroundColor = rotate ? [UIColor whiteColor] : [UIColor darkGrayColor];
    square.transform = rotate ? CGAffineTransformMakeRotation(M_PI_4) : CGAffineTransformIdentity;
    return square;
}

- (void) rotateAllSquares {
        [UIView animateWithDuration:2 animations:^{
        for (int i = 0; i < self.view.subviews.count; i++) {
            if (i % 2 == 0) {
                ((UIView*)self.view.subviews[i]).transform = CGAffineTransformMakeRotation(M_PI_4);
            }else{
                ((UIView*)self.view.subviews[i]).transform = CGAffineTransformIdentity;
            }
        }
    }completion:^(BOOL finished){
        [UIView animateWithDuration:2 animations:^{
            for (int i = 0; i < self.view.subviews.count; i++) {
                if (i % 2 != 0) {
                    ((UIView*)self.view.subviews[i]).transform = CGAffineTransformMakeRotation(M_PI_4);
                }else{
                    ((UIView*)self.view.subviews[i]).transform = CGAffineTransformIdentity;
                }
            }
        }completion:^(BOOL finished){
            [self rotateAllSquares];
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
