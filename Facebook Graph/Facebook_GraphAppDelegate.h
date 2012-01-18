//
//  Facebook_GraphAppDelegate.h
//  Facebook Graph
//
//  Created by Fahd on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FBConnect.h"

@interface Facebook_GraphAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> {
    BOOL authorizing;
    Facebook* facebook;
}

@property (nonatomic, retain) Facebook* facebook;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
