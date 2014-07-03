//
//  RSPageViewControllerDataSource.h
//
//
//  Created by Radoslaw Szeja on 15.06.2014.
//
//

#import <Foundation/Foundation.h>

@class RSPageViewControllerDataSource;

@protocol RSPageViewControllerProtocol <NSObject>

- (void)pageViewController:(UIPageViewController *)pageViewController switchedToController:(UIViewController *)controller;

@end

@interface RSPageViewControllerDataSource : NSObject <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

- (instancetype)initWithPageViewController:(UIPageViewController *)pageViewController
                          childControllers:(NSArray *)childControllers;

@property (nonatomic, weak) IBOutlet id<RSPageViewControllerProtocol> pvcDelegate;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *childControllers;

/**
 *  Pass the storyboard name, when using this object in storyboard,
 *  using runtime attributes in IB. 
 *  RSPageViewControllerDataSource will use "Main.storyboard" as a default.
 *  @param name Storyboard name
 */
- (void)setStoryboardName:(NSString *)storyboardName;

/**
 *  This method allows to pass view controllers' storyboard id's by using 
 *  runtime attributes in IB. This method need storyboard name to instantiate controllers
 *  @param controllers Expected to be a string with storyboard id's of controllers, seperated by coma
 */
- (void)setChildControllersFromString:(NSString *)controllers;

@end

