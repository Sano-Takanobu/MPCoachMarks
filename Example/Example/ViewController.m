//
//  ViewController.m
//  Example
//
//  Created by marcelo.perretta@gmail.com on 7/8/15.
//  Copyright (c) 2015 MAWAPE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    MPCoachMarks *_coachMarksView;
    NSUInteger _coachMarksViewIndex;
    NSArray *_coachMarks;
    __weak IBOutlet UIImageView *lightImageView;
    __weak IBOutlet UIButton *button;
    __weak IBOutlet UIBarButtonItem *barButtonItem;
    __weak IBOutlet UITabBarItem *firstTabBarItem;
    __weak IBOutlet UITabBarItem *secondTabBarItem;
    __weak IBOutlet UITabBar *tabBar;
}

@end

@implementation ViewController

- (IBAction)startTutorial:(id)sender {
    [self showTutorial];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self showTutorial];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showTutorial];
}

#pragma mark - Tutorial

- (void)setupTutorial {
    CGRect coachmark1 = CGRectMake(lightImageView.frame.origin.x - 5, lightImageView.frame.origin.y - 5, lightImageView.frame.size.width + 10, lightImageView.frame.size.height + 10);
    
    CGRect coachmark2 = CGRectMake(button.frame.origin.x - 5, button.frame.origin.y - 5, button.frame.size.width + 10, button.frame.size.height + 10);
    
    UIView *targetView = (UIView *)[barButtonItem performSelector:@selector(view)];
    CGRect coachmark3;
    if (UIDeviceOrientationPortrait == [[UIApplication sharedApplication] statusBarOrientation]) {
        coachmark3 = CGRectMake(targetView.frame.origin.x - 5, targetView.frame.origin.y + 15, targetView.frame.size.width + 10, targetView.frame.size.height + 10);
    }else {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            coachmark3 = CGRectMake(targetView.frame.origin.x - 5, targetView.frame.origin.y + 15, targetView.frame.size.width + 10, targetView.frame.size.height + 10);
        }else {
            coachmark3 = targetView.frame;
        }
    }
    
    targetView = (UIView *)[firstTabBarItem performSelector:@selector(view)];
    CGRect coachmark4 = CGRectMake(targetView.frame.origin.x, tabBar.frame.origin.y, targetView.frame.size.width, targetView.frame.size.height);
    
    targetView = (UIView *)[secondTabBarItem performSelector:@selector(view)];
    CGRect coachmark5 = CGRectMake(targetView.frame.origin.x, tabBar.frame.origin.y, targetView.frame.size.width, targetView.frame.size.height);
    

    // Setup coach marks
    _coachMarks = @[
                    @{
                        @"rect": [NSValue valueWithCGRect:coachmark1],
                        @"caption": @"You can put marks over images",
                        @"shape": [NSNumber numberWithInteger:SHAPE_CIRCLE],
                        @"position":[NSNumber numberWithInteger:LABEL_POSITION_BOTTOM],
                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_CENTER],
                        @"showArrow":[NSNumber numberWithBool:YES]
                        },
                    @{
                        @"rect": [NSValue valueWithCGRect:coachmark2],
                        @"caption": @"Also, we can show buttons",
                        @"position":[NSNumber numberWithInteger:LABEL_POSITION_TOP],
                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_CENTER],
                        @"showArrow":[NSNumber numberWithBool:YES]
                        },
                    @{
                        @"rect": [NSValue valueWithCGRect:coachmark3],
                        @"caption": @"And works with navigations buttons too",
                        @"shape": [NSNumber numberWithInteger:DEFAULT],
                        @"position":[NSNumber numberWithInteger:LABEL_POSITION_BOTTOM],
                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_CENTER],
                        @"showArrow":[NSNumber numberWithBool:YES]
                        },
                    @{
                        @"rect": [NSValue valueWithCGRect:coachmark4],
                        @"caption": @"Also, we can show tab buttons",
                        @"position":[NSNumber numberWithInteger:LABEL_POSITION_TOP],
                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_RIGHT],
                        @"showArrow":[NSNumber numberWithBool:YES]
                        },
                    @{
                        @"rect": [NSValue valueWithCGRect:coachmark5],
                        @"caption": @"このアイコンをアップして\nもっと無料作品を読もう！",
                        @"position":[NSNumber numberWithInteger:LABEL_POSITION_TOP],
                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_CENTER],
                        @"showArrow":[NSNumber numberWithBool:YES]
                        }
                    ];
    
    if (_coachMarksView) {
        _coachMarksView.coachMarks = _coachMarks;
    }else {
        _coachMarksView = [[MPCoachMarks alloc] initWithFrame:self.navigationController.view.bounds coachMarks:_coachMarks];
        _coachMarksView.delegate = self;
        [self.navigationController.view addSubview:_coachMarksView];
    }
}

-(void) showTutorial{
    [self setupTutorial];
    [_coachMarksView start];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [self setupTutorial];
        
        CGRect frame = self.navigationController.view.frame;
        frame.size = size;
        
        CGRect markRect = [_coachMarksView.coachMarks[_coachMarksViewIndex][@"rect"] CGRectValue];

        switch (_coachMarksViewIndex) {
            case 0:
                [_coachMarksView animateCutoutToRect:markRect withShape:SHAPE_CIRCLE frame:frame];
                break;
                
            default:
                [_coachMarksView animateCutoutToRect:markRect withShape:DEFAULT frame:frame];
                break;
        }
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Stuff you used to do in didRotateFromInterfaceOrientation would go here.
        // If not needed, set to nil.
        
    }];
}

#pragma mark - MPCoachMarksViewDelegate
- (void)coachMarksView:(MPCoachMarks *)coachMarksView willNavigateToIndex:(NSUInteger)index {
    _coachMarksViewIndex = index;
}

- (void)coachMarksViewDidClicked:(MPCoachMarks *)coachMarksView atIndex:(NSInteger)index {
    
}

@end
