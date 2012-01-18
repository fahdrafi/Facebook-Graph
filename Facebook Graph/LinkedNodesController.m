//
//  LinkedNodesController.m
//  Facebook Graph
//
//  Created by Fahd on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LinkedNodesController.h"

#import "QuartzCore/QuartzCore.h"

#import "Constants.h"

@interface LinkedNodesController ()

@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, readonly) NSInteger nodesPerPage;

-(void)privateInit;
-(void)initVisiblePositions;

@end

@implementation LinkedNodesController

@synthesize currentPage, nodesPerPage, linkedNodes;

-(void)clear {
    for (UIView* v in self.view.subviews) {
        [v removeFromSuperview];
    }
    [self.linkedNodes removeAllObjects];
}

-(NodeController*)nodeControllerForId:(NSString *)nodeId {
    if (![self isMember:nodeId]) return nil;
    NodeController* requiredNode;
    for (requiredNode in linkedNodes) {
        if ([requiredNode.nodeData.id isEqualToString:nodeId]) {
            return requiredNode;
        }
    }
    return nil;
}

-(void)releaseAllNodes {    
    NSArray* interimControllers = [NSArray arrayWithArray:self.linkedNodes];
    [self.linkedNodes removeAllObjects];
    
    NodeController* nodeCon;
    for (NSInteger i=0; i<[interimControllers count]; i++) {
        nodeCon = [interimControllers objectAtIndex:i];
        if ([nodeCon.view.superview isEqual:self.view]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [UIView animateWithDuration:0.4 * TIMINGSCALE 
                                          delay:(0.1*i) * TIMINGSCALE 
                                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                                     animations:^(void) {
                                         CALayer* layer = nodeCon.view.layer;
                                         CGFloat zDistance = 400;
                                         CATransform3D t = CATransform3DIdentity;
                                         t.m34 = -1.0/zDistance;
                                         t = CATransform3DRotate(t, M_PI_2, 0.0, 1.0, 0.0);
                                         t = CATransform3DRotate(t, M_PI, 0.0, 0.0, 1.0);
                                         layer.transform = t;
                                         nodeCon.view.alpha = 0.0;
                                     }
                                     completion:^(BOOL finished) {
                                         [nodeCon.view removeFromSuperview];
                                     }];
                });
            });
        }
    }
}

-(void)releaseAllNodesExcept:(NSString *)keepId {
    NodeController* nodeCon;
    NSInteger keepIndex = -1;
    for (NSInteger i=0; i<[self.linkedNodes count]; i++) {
        nodeCon = [self.linkedNodes objectAtIndex:i];
        if ([nodeCon.nodeData.id isEqualToString:keepId]) {
            keepIndex = i;
            continue;
        }
        if ([nodeCon.view.superview isEqual:self.view]) {
            [nodeCon.view removeFromSuperview];
        }
    }

    if (keepIndex < 0) {
        [self.linkedNodes removeAllObjects];
    } else {
        NSInteger i = 0;
        for (i=0; i<keepIndex; i++) {
            [self.linkedNodes removeObjectAtIndex:0];
        }
        i++;
        while ([self.linkedNodes count]>1) {
            [self.linkedNodes removeObjectAtIndex:1];
        }
    }
}

-(BOOL)isMember:(NSString *)checkId {
    NodeController* con;
    for (con in linkedNodes) {
        if ([con.nodeData.id isEqualToString:checkId])
            return YES;
    }
    return NO;
}

-(void)updateViews {
    for (NodeController* node in linkedNodes) {
        if (node.view) {
            [node.view removeFromSuperview];
        }
    }
    NSInteger slot = 0;
    for (NSInteger i = (nodesPerPage*currentPage); i<[linkedNodes count]; i++) {
        NodeController* n = [linkedNodes objectAtIndex:i];
        n.state = @"LinkedState";
        n.view.center = visiblePositions[slot++];
        [self.view addSubview:n.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNodeNeedsUpdate" object:n.nodeData];
        if ([n.nodeData.version integerValue]) {
            [n setInvisible];
            [n animateToVisible];
            [n updateView];
        }
        if (slot==nodesPerPage)
            break;
    }
    [self.view setNeedsDisplay];
}

-(void)addNodeController:(NodeController *)newNodeCon {
    [self.linkedNodes addObject:newNodeCon];
//    [self updateViews];
}

// Utility Function
CGPoint CGPointsIntersect(CGPoint p1, CGPoint p2,CGPoint p3, CGPoint p4)
{
    CGFloat xNumerator = ((p1.x*p2.y-p1.y*p2.x)*(p3.x-p4.x) - (p1.x-p2.x)*(p3.x*p4.y-p3.y*p4.x));
    CGFloat yNumerator = ((p1.x*p2.y-p1.y*p2.x)*(p3.y-p4.y) - (p1.y-p2.y)*(p3.x*p4.y-p3.y*p4.x));
    CGFloat denominator = ((p1.x-p2.x)*(p3.y-p4.y)-(p1.y-p2.y)*(p3.x-p4.x));
    return CGPointMake((xNumerator / denominator), (yNumerator / denominator));
}

- (void)initVisiblePositions {
    
    visiblePositions = malloc(sizeof(CGPoint)*nodesPerPage);
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    CGFloat inset = 30.0;
    NSInteger divs = nodesPerPage;    
    CGFloat angleSpread = 3.0*M_PI_2;
    CGFloat unitAngle = angleSpread/(divs-1);
    
    CGPoint bl = CGPointMake(inset, height-inset);
    CGPoint br = CGPointMake(width-inset, height-inset);
    CGPoint tl = CGPointMake(inset, inset);
    CGPoint tr = CGPointMake(width-inset, inset);
    
    CGPoint lines[3][2];
    lines[0][0] = bl;
    lines[0][1] = tl;
    lines[1][0] = tl;
    lines[1][1] = tr;
    lines[2][0] = tr;
    lines[2][1] = br;
    
    CGPoint center = CGPointMake(width/2.0, height/2.0);
    CGFloat currentAngle = -angleSpread/2.0;
    
    CGPoint p;
    CGPoint intersections[3];
    NSInteger selectedIntersection;
    
    for (NSInteger i=0; i<self.nodesPerPage; i++) {
        p = CGPointApplyAffineTransform(CGPointMake(0.0, -1.0), CGAffineTransformMakeRotation(currentAngle));
        p = CGPointApplyAffineTransform(p, CGAffineTransformMakeTranslation(width/2.0, height/2.0));
        for (NSInteger j=0; j<3; j++) {
            intersections[j] = CGPointsIntersect(center, p, lines[j][0], lines[j][1]);
        }
        if (currentAngle < 0) {
            // left half
            if (intersections[0].y > inset) selectedIntersection = 0;
            else selectedIntersection = 1;
        } else {
            // right half
            if (intersections[2].y> inset) selectedIntersection = 2;
            else selectedIntersection = 1;
        }
        
        visiblePositions[i] = intersections[selectedIntersection];
        currentAngle += unitAngle;
    }
}

-(void)privateInit {
    nodesPerPage = 12;
    currentPage = 0;
    [self initVisiblePositions];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];

        linkedNodes = [[NSMutableArray alloc] initWithCapacity:100];
        [self privateInit];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [linkedNodes release];
    free(visiblePositions);
    [super dealloc];
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
