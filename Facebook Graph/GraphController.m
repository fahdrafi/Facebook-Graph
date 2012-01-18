//
//  GraphController.m
//  Facebook Graph
//
//  Created by Fahd on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphController.h"

#import "Constants.h"

@interface GraphController ()

@property (nonatomic, readonly) CurrentNodeController* currentController;
@property (nonatomic, readonly) StackController* stackController;
@property (nonatomic, readonly) LinkedNodesController* linkedNodesController;

@end

@implementation GraphController

@synthesize dataController, currentController, stackController, linkedNodesController;

-(void)clear {
    [self.stackController clear];
    [self.linkedNodesController clear];
    [self.currentController clear];
}

-(NodeController*)newNodeController {
    NodeController* newNode = [[NodeController alloc] initWithNibName:nil bundle:nil];
    newNode.dataController = self.dataController;
    return newNode;
}

-(void)setupLinkedNodes {
    Node* currentNode = self.currentController.nodeController.nodeData;
    NSArray* linkTypes = [self.dataController linkTypesForNode:currentNode];
    NSLog(@"Setting up %d types of links for %@", [linkTypes count], [currentNode entity].name);
    for (NSString* type in linkTypes) {
        [self.dataController updateLinksForNode:currentNode ofType:type];
    }
}



-(void)resetToNodeWithId:(NSString *)nodeId {
    [self clear];
    
    NodeController* newNode = [[self newNodeController] autorelease];
    newNode.nodeData = [[self.dataController newNodeWithId:nodeId type:@"User"] autorelease];
    newNode.state = @"DetailedState";
    currentController.nodeController = newNode;
    [currentController updateViews];
    [currentController.view setNeedsDisplay];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNodeNeedsUpdate" object:newNode.nodeData];

    [self setupLinkedNodes];
}

-(void)linksAvailable:(NSNotification*)notification {
    Node* node = notification.object;
    if ([node.id isEqualToString:self.currentController.nodeController.nodeData.id]) {
        NSString* type = [notification.userInfo valueForKey:@"type"];
        NSSet* linkedNodes = [node valueForKey:type];
        for (Node* link in linkedNodes) {
            NodeController* newNodeCon = [self newNodeController];
            newNodeCon.nodeData = link;
            [self.linkedNodesController addNodeController:newNodeCon];
        }
        [self.linkedNodesController updateViews];
    }
}

-(void)linkClicked:(NSString*) nodeId {
    [self.stackController pushNodeController:self.currentController.nodeController];
    self.currentController.nodeController = [self.linkedNodesController nodeControllerForId:nodeId];
    [self.linkedNodesController releaseAllNodes];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [UIView animateWithDuration:0.5 * TIMINGSCALE
                                  delay:0.1 * TIMINGSCALE
                                options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [self.stackController updateViews];
                                 [self.currentController updateViews];
                             } 
                             completion:^(BOOL finished) {
//                                 [self.linkedNodesController releaseAllNodesExcept:@""];
                                 [self setupLinkedNodes];
                             }];

        });
    });
}

-(void)stackClicked {
    self.currentController.nodeController = [self.stackController peekTopController];
    [stackController popNodeController];
    [self.linkedNodesController releaseAllNodes];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [UIView animateWithDuration:0.5 * TIMINGSCALE 
                                  delay:0.1 * TIMINGSCALE  
                                options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [self.currentController updateViews];
                                 [self.stackController updateViews];
                             } 
                             completion:^(BOOL finished) {
//                                 [self.linkedNodesController releaseAllNodesExcept:@""];
                                 [self setupLinkedNodes];
                             }];
        });
    });
}

-(void)nodeClicked:(NSNotification*)notification {
    NodeController* clickedNode = notification.object;
    if ([clickedNode.state isEqualToString:@"LinkedState"]) {
        [self linkClicked:clickedNode.nodeData.id];
    } else if ([clickedNode.state isEqualToString:@"StackedState"]) {
        [self stackClicked];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentController = [[CurrentNodeController alloc] initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        stackController = [[StackController alloc] initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        linkedNodesController = [[LinkedNodesController alloc] initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        
        self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
        
        [self.view addSubview:linkedNodesController.view];
        [self.view addSubview:stackController.view];
        [self.view addSubview:currentController.view];
        
        // Setup notification listening
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linksAvailable:) name:@"NotificationLinksUpdated" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nodeClicked:) name:@"NotificationNodeClicked" object:nil];
        
    }
    return self;
}

-(void) dealloc {
    [dataController release];
    [currentController release];
    [stackController release];
    [linkedNodesController release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
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
