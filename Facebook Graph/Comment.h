//
//  Comment.h
//  Facebook Graph
//
//  Created by Fahd on 10/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Post.h"


@interface Comment : Post {
@private
}
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * user_likes;

@end
