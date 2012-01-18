//
//  StackController.m
//  Facebook Graph
//
//  Created by Fahd on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StackController.h"

@interface StackController ()

@property (nonatomic, readonly) NSMutableArray* stack;

@end

@implementation StackController

-(void)clear {
    for (UIView* v in self.view.subviews) {
        [v removeFromSuperview];
    }
    [self.stack removeAllObjects];
}

-(void)updateViews {
    CGFloat stackInset = 50;
    CGFloat stackStep = 5;
    CGPoint center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    CGFloat stackX = center.x;
    CGFloat stackStartY = self.view.frame.size.height - stackInset;
    
    for (NSInteger i=0; i<[self.stack count]; i++) {
        NodeController* node = [self.stack objectAtIndex:i];
        node.view.center = CGPointMake(stackX, stackStartY+i*stackStep);
        node.state = @"StackedState";
    }
//    [self.view setNeedsDisplay];
}

-(NSMutableArray*)stack {
    if (stack) return stack;
    stack = [[NSMutableArray alloc] initWithCapacity:20];
    return stack;
}

-(NSInteger) count {
    return [stack count];
}

-(void)pushNodeController:(NodeController *)nodeController {
    [self.stack insertObject:nodeController atIndex:0];

    CGPoint oldCenter = CGPointMake(nodeController.view.frame.size.width/2, nodeController.view.frame.size.height/2);
    CGPoint newCenter = [nodeController.view convertPoint:oldCenter toView:self.view];
    [self.view addSubview:nodeController.view];    
    nodeController.view.center = newCenter;
    [self.view setNeedsDisplay];
}

-(void)popNodeController {
    if ([self.view.subviews containsObject:[self peekTopController].view])  {
        [[self peekTopController].view removeFromSuperview];
    }
    [self.stack removeObjectAtIndex:0];
}

-(NodeController*)peekTopController {
    return [stack objectAtIndex:0];
}

-(BOOL)isMember:(NSString *)nodeId {
    for (NodeController* nodeCon in stack) {
        if ([nodeCon.nodeData.id isEqualToString:nodeId])
            return YES;
    }
    return NO;
}

-(void)dealloc {
    [stack release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    CGFloat myWidth = 60;
    CGFloat myHeight = 75;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGRect mainFrame = [UIScreen mainScreen].applicationFrame;
        CGRect frame = CGRectMake(mainFrame.size.width/2-myWidth/2, mainFrame.size.height - myHeight, myWidth, myHeight);
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

@end
