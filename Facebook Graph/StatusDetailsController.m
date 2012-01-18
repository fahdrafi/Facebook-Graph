//
//  StatusDetailsController.m
//  Facebook Graph
//
//  Created by Fahd on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StatusDetailsController.h"

#import "Status.h"

@implementation StatusDetailsController
@synthesize messageLabel;

-(void) updateView {
    Status* status = (Status*) self.nodeData;
    if ([status.message length]) {
        self.messageLabel.text = status.message;
    } else if ([status.story length]) {
        self.messageLabel.text = status.story;
    } else {
        NSLog(@"No story, no message!");
    }
    [self.view setNeedsDisplay];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self setMessageLabel:nil];
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
    [messageLabel release];
    [super dealloc];
}
@end
