//
//  FBResponseHandler.h
//  Facebook Graph
//
//  Created by Fahd on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// Class used to handle facebook response for specific queries.
// New object will be created for each request. Object is to be destroyed upon destroy notification.


#import <Foundation/Foundation.h>

#import "Node+SetterExtension.h"

#import "FBConnect.h"
#import "DataController.h"

@interface FBResponseHandler : NSObject <FBRequestDelegate> {
    NSString* requestType;
    Node* targetNode;

    // if Node
    NSString* nodeType;
    
    // if Links
    DataController* dataController;
    NSString*       linksType;
}

@property (nonatomic,retain) NSString* requestType; // "Node" or "Links"
@property (nonatomic,retain) Node* targetNode; // needs to be set for both cases

@property (nonatomic,retain) NSString* nodeType; // needs to be set for node request

@property (nonatomic,retain) DataController* dataController; // needs to be set when requesting links
@property (nonatomic,retain) NSString* linksType; // needs to be set when requesting links

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error;
- (void)request:(FBRequest *)request didLoad:(id)result;

@end
