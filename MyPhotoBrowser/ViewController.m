//
//  ViewController.m
//  MyPhotoBrowser
//
//  Created by 惠上科技 on 2018/11/6.
//  Copyright © 2018 惠上科技. All rights reserved.
//

#import "ViewController.h"
#import "MWPhotoBrowser.h"
@interface ViewController ()<MWPhotoBrowserDelegate>
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageArray;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSArray *imageUrl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageUrl = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=260079827,3986917683&fm=26&gp=0.jpg",
                          @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3314992878,4183343306&fm=26&gp=0.jpg",
                          @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2814482483,3947067843&fm=26&gp=0.jpg",
                          @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=4246635619,2104901758&fm=26&gp=0.jpg",
                          @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1315806054,736659395&fm=26&gp=0.jpg",
                          @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3472873265,979949319&fm=26&gp=0.jpg"];
    for (int i = 0; i<self.imageArray.count; i++) {
        UIImageView *imageView = self.imageArray[i];
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        [imageView addGestureRecognizer:tap];
        imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl[i]]]];
    }
    
}




-(void)imageTap:(UITapGestureRecognizer *)tapView{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = YES;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    for (NSString *imageUrl in self.imageUrl) {
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:imageUrl]];
        [photos addObject:photo];
    }
    
    // Options
    startOnGrid = YES;
    self.photos = photos;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:tapView.view.tag - 100];
    
    // Show
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
