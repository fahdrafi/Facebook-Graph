//
//  PhotoDetailsController.m
//  Facebook Graph
//
//  Created by Fahd on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoDetailsController.h"

#import "Photo.h"

@implementation PhotoDetailsController

@synthesize photoView;

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.view;
}

- (void)updateView {
    Photo* photoNode = (Photo*) self.nodeData;
    if ([photoNode.photoData length]) {
        UIScrollView* scrollView = (UIScrollView*)self.photoView.superview.superview;
        UIImage* img = [UIImage imageWithData:photoNode.photoData];

        scrollView.contentSize = CGSizeMake(img.size.width, img.size.height);
        scrollView.contentMode = UIViewContentModeScaleAspectFit;        
        scrollView.clipsToBounds = YES;
        scrollView.multipleTouchEnabled = YES;
        scrollView.delegate = self;

        self.view.frame = CGRectMake(0.0, 0.0, img.size.width, img.size.height);
        self.photoView.frame = CGRectMake(0.0, 0.0, img.size.width, img.size.height);
        self.photoView.image = img;
                
        CGFloat hRatio = scrollView.frame.size.width / img.size.width;
        CGFloat vRatio = scrollView.frame.size.height / img.size.height;
        
        CGFloat minZoom = MIN(hRatio, vRatio);
        
        scrollView.maximumZoomScale = 1.0;
        scrollView.minimumZoomScale = minZoom;
        
        scrollView.zoomScale = minZoom;
        
    }
    [self.view setNeedsDisplay];
}

- (void)updateDetails:(DataController*)dataCon {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Photo* photoNode = (Photo*) self.nodeData;
        if (!photoNode.photoData) {
            NSString* formatString = [NSString stringWithString:@"https://graph.facebook.com/%@/picture?access_token=%@"];
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:formatString, photoNode.object_id, dataCon.facebook.accessToken]];
            photoNode.photoData = [NSData dataWithContentsOfURL:url];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
    });
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
    [self setPhotoView:nil];
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
    [photoView release];
    [super dealloc];
}

@end
