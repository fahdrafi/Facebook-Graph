//
//  StackController.h
//  Facebook Graph
//
//  Created by Fahd on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NodeController.h"

@interface StackController : UIViewController {
    NSMutableArray* stack;
}

@property (nonatomic, readonly) NSInteger count;

-(void)clear;
-(void)pushNodeController:(NodeController*)nodeController;
-(void)popNodeController;
-(NodeController*)peekTopController;
-(BOOL)isMember:(NSString*)nodeId;
-(void)updateViews;

@end
