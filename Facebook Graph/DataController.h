//
//  DataController.h
//  Facebook Graph
//
//  Created by Fahd on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FBConnect.h"
#import "Node.h"

@interface DataController : NSObject {
    NSManagedObjectContext*     moc;
    Facebook*                   facebook;
}

@property (nonatomic, retain) NSManagedObjectContext* moc;
@property (nonatomic, retain) Facebook* facebook;

-(Node*)newNodeWithId:(NSString*)nodeId type:(NSString*)nodeType;
-(void)updateNode:(NSNotification*)notif;
-(NSArray*)linkTypesForNode:(Node*)queryNode;
-(void)updateLinksForNode:(Node*)targetNode ofType:(NSString*)linksType;

@end
