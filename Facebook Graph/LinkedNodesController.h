//
//  LinkedNodesController.h
//  Facebook Graph
//
//  Created by Fahd on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NodeController.h"

@interface LinkedNodesController : UIViewController {
    NSMutableArray* linkedNodes;
    //{
    @private
    CGPoint* visiblePositions;
    NSInteger currentPage;
    NSInteger nodesPerPage;
    //}

}

@property (nonatomic, readonly) NSMutableArray* linkedNodes;

-(void)addNodeController:(NodeController*) newNodeCon;
-(BOOL)isMember:(NSString*) checkId;
//-(void)releaseAllNodesExcept:(NSString*) keepId;
-(void)releaseAllNodes;
-(NodeController*)nodeControllerForId:(NSString*)nodeId;
-(void)updateViews;
-(void)clear;

@end

CGPoint CGPointsIntersect(CGPoint p1, CGPoint p2,CGPoint p3, CGPoint p4);

