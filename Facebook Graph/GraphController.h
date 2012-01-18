//
//  GraphController.h
//  Facebook Graph
//
//  Created by Fahd on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataController.h"
#import "CurrentNodeController.h"
#import "StackController.h"
#import "LinkedNodesController.h"

@interface GraphController : UIViewController {
    // Model Object
    DataController* dataController;

    // View Controllers
    CurrentNodeController* currentController;
    StackController* stackController;
    LinkedNodesController* linkedNodesController;
}

@property (nonatomic, retain) DataController* dataController;

-(void)resetToNodeWithId:(NSString*)nodeId;
-(void)clear;

@end
