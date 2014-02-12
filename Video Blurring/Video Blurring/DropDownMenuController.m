//
//  DropDownMenuController.m
//  Video Blurring
//
//  Created by Ray Wenderlich on 11/9/13.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

#import "DropDownMenuController.h"
#import "UIView+Screenshot.h"
#import <GPUImage/GPUImage.h>

#define MENUSIZE 150.0f

@interface DropDownMenuController (){
    GPUImageView *_blurView;
    GPUImageiOSBlurFilter *_blurFilter;
    UIView *_backgroundView;
}

@end

BOOL removed;

@implementation DropDownMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect deviceSize = [UIScreen mainScreen].bounds;
    
    removed = NO;
    _blurView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, deviceSize.size.height, 0)];
    _blurView.clipsToBounds = YES;
    _blurView.layer.contentsGravity = kCAGravityTop;
    
    // replacing with blur effect
    //_blurView.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:_blurView];
    
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -MENUSIZE, deviceSize.size.height, MENUSIZE)];
    [self.view addSubview:_backgroundView];
    
    
    UIView *dividingLine = [[UIView alloc] initWithFrame:CGRectMake(deviceSize.size.height/2, 30, 1, MENUSIZE-40)];
    dividingLine.backgroundColor = [UIColor whiteColor];
    [_backgroundView addSubview:dividingLine];
    
    
    UILabel *takePicture = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 150, 40)];
    takePicture.center = CGPointMake(deviceSize.size.height/4, 120);
    takePicture.textAlignment = NSTextAlignmentCenter;
    takePicture.text = @"Record New Video";
    takePicture.textColor = [UIColor whiteColor];
    [_backgroundView addSubview:takePicture];
    
    UIImageView *cameraImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Camera.png"]];
    cameraImageView.contentScaleFactor = 0.25;
    cameraImageView.center = CGPointMake(deviceSize.size.height/4, 70);
    [_backgroundView addSubview:cameraImageView];
    
    
    UILabel *loadVideo = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 150, 40)];
    loadVideo.center = CGPointMake((deviceSize.size.height/4)*3, 120);
    loadVideo.textAlignment = NSTextAlignmentCenter;
    loadVideo.text = @"Load Video";
    loadVideo.textColor = [UIColor whiteColor];
    [_backgroundView addSubview:loadVideo];
    
    UIImageView *filmImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FilmStrip.png"]];
    filmImageView.contentScaleFactor = 0.25;
    filmImageView.center = CGPointMake((deviceSize.size.height/4)*3, 70);
    [_backgroundView addSubview:filmImageView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)didTap:(UITapGestureRecognizer*)tap{
    
    CGPoint location = [tap locationInView:self.view];
    CGRect deviceSize = [UIScreen mainScreen].bounds;

    if(location.y < MENUSIZE){
        if(location.x < deviceSize.size.height/2){
            [self.delegate didSelectItemAtIndex:0];
        }
        else{
            [self.delegate didSelectItemAtIndex:1];
        }
        
    }
    [self hide];
    
}


-(void)show{
    
    [self addToParentViewController];
    
    // update the static blur image
    [self updateBlur];
    
    CGRect deviceSize = [UIScreen mainScreen].bounds;

    // resize the content scale before animating
    _blurView.layer.contentsScale = 2.0f;
    
    [UIView animateWithDuration:0.25f animations:^(void){
        _blurView.frame = CGRectMake(0, 0, deviceSize.size.height, MENUSIZE);
        _backgroundView.frame = CGRectMake(0, 0, _backgroundView.frame.size.width, MENUSIZE);
        
        _blurView.layer.contentsRect = CGRectMake(0.0f, 0.0f, 1.0f, MENUSIZE / 320.0f);
        _blurView.layer.contentsScale = (MENUSIZE / 320.0f) * 2;
    }];
    
}

-(void)hide{
    _blurView.layer.contentsGravity = kCAGravityTop;
    [UIView animateWithDuration:0.25f animations:^(void){
        _backgroundView.frame = CGRectMake(0, -_backgroundView.frame.size.height, _backgroundView.frame.size.width, _backgroundView.frame.size.height);
        _blurView.frame = CGRectMake(0, 0, _blurView.frame.size.width, 0);
    }
                     completion:^(BOOL finished){
                         [self didMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                         
                         [self.delegate didHideMenu];
                     }];
    
}

/*
 This method adds the menu view to the top view controller
 */
-(void)addToParentViewController{
    if(self.parentViewController == nil){
        UIViewController *parent = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        if([[parent childViewControllers] count] > 0){
            parent = [[parent childViewControllers] lastObject];
        }
        
        [parent addChildViewController:self];
        [parent.view addSubview:self.view];
        [self didMoveToParentViewController:self];
        self.view.frame = CGRectMake(0, 0, self.parentViewController.view.frame.size.height, self.parentViewController.view.frame.size.width);

    }
}

-(void)updateBlur {
    if (_blurFilter == nil) {
        _blurFilter = [[GPUImageiOSBlurFilter alloc] init];
        _blurFilter.blurRadiusInPixels = 1.0f;
    }
    
    // capture the current view's superview using our category method
    UIImage *image = [self.view.superview convertViewToImage];
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:image];
    
    [picture addTarget:_blurFilter];
    [_blurFilter addTarget:_blurView];
    
    [picture processImage];
}

@end
