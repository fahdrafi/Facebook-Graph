//
//  DetailsController.h
//  Facebook Graph
//
//  Created by Fahd on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataController.h"
#import "Node.h"

@interface DetailsController : UIViewController {
    // Model
    Node* nodeData;
    
}

-(void)updateView;
-(void)updateDetails:(DataController*)dataCon;

@property (nonatomic, retain) Node* nodeData;

@end
