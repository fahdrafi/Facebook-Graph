//
//  UserDetailsController.h
//  Facebook Graph
//
//  Created by Fahd on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsController.h"

@interface UserDetailsController : DetailsController {

    // Views
    UILabel *relationshipLabel;
    UILabel *genderLabel;
    UILabel *locationLabel;
    UILabel *bioLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *relationshipLabel;
@property (nonatomic, retain) IBOutlet UILabel *genderLabel;
@property (nonatomic, retain) IBOutlet UILabel *bioLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;

@end
