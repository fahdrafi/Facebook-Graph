//
//  NodeController.m
//  Facebook Graph
//
//  Created by Fahd on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "NodeController.h"
#import "User.h"
#import "Post.h"

#import "DetailsController.h"

#import "Constants.h"

@implementation NodeController

@synthesize nodeData, imageView, mainLabel, auxLabel, detailsController, detailsView, dataController;

-(DetailsController*)detailsController {
    if (detailsController) return detailsController;
    
    NSString* nodeType = self.nodeData.entity.name;
    Class controllerClass = NSClassFromString([NSString stringWithFormat:@"%@DetailsController", nodeType ]);
    detailsController = [[controllerClass alloc] initWithNibName:nil bundle:nil];
    return detailsController;
}

-(NSString*)state {
    if (state) return state;
    return [NSString stringWithString:@"NoState"];
}

-(void)setupBasicDetailedState {
    for (UIView* view in self.view.subviews)
        view.alpha = 1.0;
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    self.view.bounds = CGRectMake(0.0, 0.0, 180.0, 300.0);
    self.imageView.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    self.mainLabel.frame = CGRectMake(50.0, 0.0, 130.0, 25.0);
    self.mainLabel.font = [UIFont fontWithName:self.mainLabel.font.fontName size:16.0];
    self.auxLabel.frame = CGRectMake(50.0, 25.0, 130.0, 25.0);
    self.auxLabel.font = [UIFont fontWithName:self.mainLabel.font.fontName size:16.0];

    if (![self.detailsView.subviews containsObject:self.detailsController.view]) {
        [self.detailsView addSubview:self.detailsController.view];
        [self.detailsController updateDetails:self.dataController];
        [self.detailsController updateView];
    }
    self.view.transform = CGAffineTransformIdentity;
}

-(void)setupBasicLinkedState {
    self.view.transform = CGAffineTransformIdentity;
    for (UIView* view in self.view.subviews)
        view.alpha = 0.0;
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    self.view.bounds = CGRectMake(0.0, 0.0, 50.0, 50.0);
    self.imageView.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    self.imageView.alpha = 1.0;
    self.mainLabel.frame = CGRectMake(0.0, 0.0, 50.0, 9.0);
    self.mainLabel.alpha = 1.0;
    self.mainLabel.font = [UIFont fontWithName:self.mainLabel.font.fontName size:8.0];
    self.auxLabel.frame = CGRectMake(0.0, 41.0, 50.0, 9.0);
    self.auxLabel.alpha = 1.0;
    self.auxLabel.font = [UIFont fontWithName:self.mainLabel.font.fontName size:8.0];
}

-(void)setupBasicStackedState {
    [self setupBasicLinkedState];
    
    CGFloat zDistance = 400;
    CATransform3D t;
    t = CATransform3DIdentity;
    t.m34 = -1.0/zDistance;
    t = CATransform3DRotate(t, M_PI/3.0, 1.0, 0.0, 0.0);
    self.view.layer.transform = t;

}

-(void)setState:(NSString *)newState {
    state = newState;
    
    if ([newState isEqualToString:@"DetailedState"]) {
        [self setupBasicDetailedState];
    } else if ([newState isEqualToString:@"LinkedState"]) {
        [self setupBasicLinkedState];
    } else if ([newState isEqualToString:@"StackedState"]) {
        [self setupBasicStackedState];
    } else {
        // ERROR State
        NSLog(@"Invalid state set");
    }
}

-(void)setCenter:(CGPoint)center {
    self.view.center = center;
}

-(CGPoint)center {
    return self.view.center;
}

- (void)updateView {
    if (self.view.superview) {
        NSString* nodeType = [self.nodeData entity].name;
                        
        if ([nodeType isEqualToString:@"User"]) {
            // if node is User
            self.imageView.image = [UIImage imageWithData:self.nodeData.thumbnail];
            self.mainLabel.text = @"Likes";
            if ([self.nodeData.id isEqualToString:@"me"])
                self.mainLabel.text = @"Me";
            User* userNode = (User*)self.nodeData;
            self.auxLabel.text = userNode.name;

        } else if ([nodeType isEqualToString:@"Photo"]) {
            // if node is Post
            self.imageView.image = [UIImage imageWithData:self.nodeData.thumbnail];
            self.mainLabel.text = nodeType;
            Post* postNode = (Post*)self.nodeData;
            self.auxLabel.text = postNode.from;

        } else if ([nodeType isEqualToString:@"Comment"]) {
            // if node is Post
            self.imageView.image = [UIImage imageWithData:self.nodeData.thumbnail];
            self.mainLabel.text = nodeType;
            Post* postNode = (Post*)self.nodeData;
            self.auxLabel.text = postNode.from;
            
        } else if ([nodeType isEqualToString:@"Status"]) {
            // if node is Post
            self.imageView.image = [UIImage imageWithData:self.nodeData.thumbnail];
            self.mainLabel.text = nodeType;
            Post* postNode = (Post*)self.nodeData;
            self.auxLabel.text = postNode.from;

        } else {
            // if node is unknown
            self.mainLabel.text = @"Type Error";
            
        }
        
        [self.view setNeedsDisplay];
        
    }

}

- (void)setNodeData:(Node *) newNode {
    if (nodeData) {
        [nodeData removeObserver:self forKeyPath:@"version"];
        [nodeData release];
    }
    
    nodeData = newNode;
    [nodeData retain];
    [nodeData addObserver:self forKeyPath:@"version" options:0 context:NULL];
    self.detailsController.nodeData = nodeData;
}

#define ARC4RANDOM_MAX      0x100000000

-(void)animateToVisible {
    CGPoint center = self.view.center;
    self.view.center = self.view.superview.center;
    CGFloat randDelay = (CGFloat)((double_t)arc4random() / ARC4RANDOM_MAX);
    randDelay *= 0.1;
    [UIView animateWithDuration:0.7 * TIMINGSCALE 
                          delay:(0.0 + randDelay) * TIMINGSCALE 
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) {
                         self.view.center = center;
                     }
                     completion:^(BOOL finished) {}];
    [UIView animateWithDuration:0.3 * TIMINGSCALE 
                          delay:(0.3 + randDelay) * TIMINGSCALE 
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) {
                         self.view.transform = CGAffineTransformIdentity;
                         self.view.alpha = 1.0;
                     } 
                     completion:^(BOOL finished) {}];
}

-(void)setInvisible {
    CGFloat zDistance = 400;
    CATransform3D t;
    t = CATransform3DIdentity;
    t.m34 = -1.0/zDistance;
    t = CATransform3DRotate(t, M_PI_2, 1.0, 0.0, 0.0);
    t = CATransform3DRotate(t, M_PI, 0.0, 0.0, 1.0);
    self.view.layer.transform = t;
    self.view.alpha = 0.0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"version"]) {
        [self updateView];
        if ([self.nodeData.version intValue] == 1) {
            [self setInvisible];
            [self animateToVisible];
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.state = @"LinkedState";
        [self setInvisible];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [imageView release];
    imageView = nil;
    [mainLabel release];
    mainLabel = nil;
    [auxLabel release];
    auxLabel = nil;
    [mainLabel release];
    mainLabel = nil;
    [detailsView release];
    detailsView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [imageView release];
    [nodeData release];
    [mainLabel release];
    [auxLabel release];
    [mainLabel release];
    [detailsView release];
    [super dealloc];
}
- (IBAction)nodeClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNodeClicked" object:self];
}

- (IBAction)touchDown:(id)sender {
}
@end
