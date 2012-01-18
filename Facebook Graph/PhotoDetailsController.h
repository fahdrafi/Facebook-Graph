//
//  PhotoDetailsController.h
//  Facebook Graph
//
//  Created by Fahd on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailsController.h"

@interface PhotoDetailsController : DetailsController <UIScrollViewDelegate> {
    UIImageView *photoView;
}

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView;

@property (nonatomic, retain) IBOutlet UIImageView *photoView;

@end
