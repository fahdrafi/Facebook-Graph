//
//  NodeController.h
//  Facebook Graph
//
//  Created by Fahd on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Node.h"
#import "DetailsController.h"

@interface NodeController : UIViewController {
    NSString* state;

    // Model Objects
    Node* nodeData;
    DataController* dataController;
    DetailsController* detailsController;
    
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *mainLabel;
    IBOutlet UILabel *auxLabel;
    
    IBOutlet UIScrollView *detailsView;
}

- (IBAction)nodeClicked:(id)sender;
- (IBAction)touchDown:(id)sender;
- (void)updateView;

-(void) setInvisible;
-(void) animateToVisible;

@property (nonatomic, retain) DataController* dataController;
@property (nonatomic, retain) UIScrollView* detailsView;
@property (nonatomic, retain) DetailsController* detailsController;
@property (nonatomic, retain) Node* nodeData;

@property (nonatomic) CGPoint center;
@property (nonatomic, retain) NSString* state;

@property (nonatomic, readonly) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UILabel* mainLabel;
@property (nonatomic, retain) IBOutlet UILabel* auxLabel;

@end
