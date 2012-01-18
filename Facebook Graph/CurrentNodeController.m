//
//  CurrentNodeController.m
//  Facebook Graph
//
//  Created by Fahd on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"

#import "CurrentNodeController.h"

#import "Constants.h"

@implementation CurrentNodeController

@synthesize nodeController;

-(void)updateViews {
    self.nodeController.state = @"DetailedState";
    self.nodeController.view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
//    [self.view setNeedsDisplay];
}

-(void)clear {
    for (UIView* v in self.view.subviews) {
        [v removeFromSuperview];
    }
//    [nodeController release];
    nodeController = nil;
}

-(void)setNodeController:(NodeController *)newController {
    [newController retain];
    if (nodeController) {
        if ([nodeController.view.superview  isEqual:self.view]) {
            NodeController *interimController = nodeController;
            [interimController retain];
            [nodeController release];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [UIView animateWithDuration:0.5 * TIMINGSCALE
                                          delay:0 
                                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                                     animations:^(void) {
                                         CALayer* layer = interimController.view.layer;
                                         CGFloat zDistance = 400;
                                         CATransform3D t = CATransform3DIdentity;
                                         t.m34 = -1.0/zDistance;
                                         t = CATransform3DRotate(t, M_PI_2, 0.0, 1.0, 0.0);
                                         layer.transform = t;
                                         interimController.view.alpha = 0.0;
                                     } 
                                     completion:^(BOOL finished) {
                                         [interimController.view removeFromSuperview];
                                         [interimController release];
                                     }];
                });
            });

        }
    }
    nodeController = newController;
    
    CGPoint oldCenter = CGPointMake(nodeController.view.frame.size.width/2, nodeController.view.frame.size.height/2);
    CGPoint newCenter = [nodeController.view convertPoint:oldCenter toView:self.view];
    [self.view addSubview:nodeController.view];
    nodeController.view.center = newCenter;
    [self.view setNeedsDisplay];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGRect mainFrame = [UIScreen mainScreen].applicationFrame;
        CGRect frame = CGRectInset(mainFrame, 60.0, 100.0);
        self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
        self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
     
 }

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc {
    [nodeController release];
    [super dealloc];
}

@end
