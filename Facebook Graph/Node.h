//
//  Node.h
//  Facebook Graph
//
//  Created by Fahd on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Node : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * linksAvailable;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSDate * updatedTime;

@end
