//
//  FBResponseHandler.m
//  Facebook Graph
//
//  Created by Fahd on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBResponseHandler.h"
#import "Photo.h"

@implementation FBResponseHandler

@synthesize requestType, targetNode, nodeType, dataController, linksType;

- (void)getNodeThumbImage {
    if (self.targetNode.thumbnail.length) return;
    
    // Get Picture for Node
    if ([self.targetNode.entity.name isEqualToString:@"User"]) {
        [self retain];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString* urlFormat = [NSString stringWithString:@"https://graph.facebook.com/%@/picture?access_token=%@"];
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:urlFormat,self.targetNode.id,self.dataController.facebook.accessToken]];
            NSData* imageData = [NSData dataWithContentsOfURL:url];
            self.targetNode.thumbnail = imageData;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.targetNode.version = [NSNumber numberWithInteger:([self.targetNode.version integerValue]+1)];
                [self autorelease];
            });
        });
    } else if ([self.targetNode.entity.name isEqualToString:@"Photo"]) {
        [self retain];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Photo* photoNode = (Photo*) self.targetNode;
            NSURL* url = [NSURL URLWithString:photoNode.picture];
            NSData* imageData = [NSData dataWithContentsOfURL:url];
            self.targetNode.thumbnail = imageData;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.targetNode.version = [NSNumber numberWithInteger:([self.targetNode.version integerValue]+1)];
                [self autorelease];
            });
        });
    } else if ([self.targetNode.entity.name isEqualToString:@"Status"] ||
               [self.targetNode.entity.name isEqualToString:@"Comment"]) {
        [self retain];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString* urlFormat = [NSString stringWithString:@"https://graph.facebook.com/%@/picture?access_token=%@"];
            Post* post = (Post*) self.targetNode;
            NSString* targetID = post.fromID;
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:urlFormat, targetID, self.dataController.facebook.accessToken]];
            NSData* imageData = [NSData dataWithContentsOfURL:url];
            self.targetNode.thumbnail = imageData;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.targetNode.version = [NSNumber numberWithInteger:([self.targetNode.version integerValue]+1)];
                [self autorelease];
            });
        });
    }
    
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    [self autorelease];
    NSLog(@"Failed to Load: %@", request.url);
    NSLog(@"%@", error.description);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    [self autorelease];

    NSDictionary* response = result;
    if ([self.requestType isEqualToString:@"Node"]) {
        [self.targetNode setValuesForDefinedKeysWithDictionary:response];
        self.targetNode.version = [NSNumber numberWithInteger:([self.targetNode.version integerValue]+1)];
        [self getNodeThumbImage];
    } else if ([self.requestType isEqualToString:@"Links"]) {
        // setup code to get linked nodes
        
        NSArray* links = [response valueForKey:@"data"];
        
        NSString* selectorString = [NSString stringWithFormat:@"add%@Object:", [self.linksType capitalizedString]];
        SEL addLinkObjectSelector = NSSelectorFromString(selectorString);
        
        NSString* destinationType; // = [[[[self.targetNode entity] relationshipsByName] valueForKey:self.linksType] destinationEntity].name;
                
        for (NSInteger i=0; i<[links count]; i++) {
            if ([[[links objectAtIndex:i] allKeys] containsObject:@"type"]) {
                destinationType = [[links objectAtIndex:i] valueForKey:@"type"];
                if ([destinationType isEqualToString:@"status"]) { 
                    NSLog(@"Status Detected");
                }
                if (![NSEntityDescription entityForName:[destinationType capitalizedString]inManagedObjectContext:self.dataController.moc]) {
                    continue;                    
                }
            } else {
                if ([self.linksType isEqualToString:@"comments"]) {
                    destinationType = @"Comment";
                } else if ([self.linksType isEqualToString:@"likes"]) {
                    destinationType = @"User";
                } else {
                    continue;
                }
            }
            NSString* linkID = [[links objectAtIndex:i] valueForKey:@"id"];
//            if ([linkID isEqualToString:@"536237533_34834158120780655"]) {
//                int a = 1;
//                a++;
//            }
            Node* newLink = [dataController newNodeWithId:linkID type:destinationType];
            [self.targetNode performSelector:addLinkObjectSelector withObject:newLink];
            [newLink release];
        }
        
        self.targetNode.linksAvailable = [NSNumber numberWithInteger:1];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationLinksUpdated" object:self.targetNode userInfo:[NSDictionary dictionaryWithObject:self.linksType forKey:@"type"]];
        
        
    } else {
        NSLog(@"Request Type Unknown");
    }

}

-(void)dealloc {
    self.requestType = nil;
    self.targetNode = nil;
    self.nodeType = nil;
//    self.facebook = nil;
    self.dataController = nil;
    [super dealloc];
}


@end
