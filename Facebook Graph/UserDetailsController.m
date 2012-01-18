//
//  UserDetailsController.m
//  Facebook Graph
//
//  Created by Fahd on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserDetailsController.h"

#import "User.h"

@implementation UserDetailsController
@synthesize relationshipLabel;
@synthesize genderLabel;
@synthesize locationLabel;
@synthesize bioLabel;

-(void) updateView {
    User* user = (User*) self.nodeData;
    self.genderLabel.text = user.gender;
    self.relationshipLabel.text = user.relationship_status;
    self.locationLabel.text = user.location;
    self.bioLabel.text = user.bio;
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
    [self setRelationshipLabel:nil];
    [self setGenderLabel:nil];
    [self setLocationLabel:nil];
    [self setBioLabel:nil];
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
    [relationshipLabel release];
    [genderLabel release];
    [locationLabel release];
    [bioLabel release];
    [super dealloc];
}
@end
