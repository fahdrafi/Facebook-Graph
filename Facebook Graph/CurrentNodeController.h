//
//  CurrentNodeController.h
//  Facebook Graph
//
//  Created by Fahd on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NodeController.h"

@interface CurrentNodeController : UIViewController {
    NodeController* nodeController;
}

-(void)updateViews;
-(void)clear;

@property (nonatomic, retain) NodeController* nodeController;

@end
