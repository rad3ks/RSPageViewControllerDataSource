//
//  RSPageViewControllerDataSource.m
//
//
//  Created by Radoslaw Szeja on 15.06.2014.
//
//

#import "RSPageViewControllerDataSource.h"

@interface RSPageViewControllerDataSource ()
@property (nonatomic, strong) NSArray *controllersIDs;
@property (nonatomic, strong) NSString *storyboardName;
@end

@implementation RSPageViewControllerDataSource

- (instancetype)initWithPageViewController:(UIPageViewController *)pageViewController childControllers:(NSArray *)childControllers
{
    self = [super init];
    if (self) {
        _pageViewController = pageViewController;
        _childControllers = childControllers;
        
        [self configureWithInitialControllers:@[self.childControllers.firstObject]];
    }
    
    return self;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger pageIndex = [self.childControllers indexOfObject:viewController];
    
    if (NSNotFound == pageIndex) {
        return nil;
    }
    
    if (++pageIndex == self.childControllers.count) {
        return nil;
    }
    
    return [self.childControllers objectAtIndex:pageIndex];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger pageIndex = [self.childControllers indexOfObject:viewController];
    
    if (0 == pageIndex || NSNotFound == pageIndex ) {
        return nil;
    }
    
    return [self.childControllers objectAtIndex:(pageIndex-1)];
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return [self.childControllers objectAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (finished && completed) {
        NSInteger index = [self.childControllers indexOfObject:pageViewController.viewControllers.firstObject];
        self.pageControl.currentPage = index;
        
        if ([self.pvcDelegate respondsToSelector:@selector(pageViewController:switchedToController:)]) {
            [self.pvcDelegate pageViewController:self.pageViewController switchedToController:pageViewController.viewControllers.firstObject];
        }
    }
}

#pragma mark - Configuration

- (void)configureWithInitialControllers:(NSArray *)controllers
{
    if (nil != self.pageViewController &&
        nil != controllers &&
        [controllers isKindOfClass:[NSArray class]] &&
        controllers.count > 0)
    {
        [self.pageViewController setViewControllers:controllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
    }
}

#pragma mark - Setup

- (void)instantiateChildControllers
{
    if (self.controllersIDs != nil) {
        UIStoryboard *storyboard = nil;
        
        if (self.storyboardName) {
            storyboard = [UIStoryboard storyboardWithName:self.storyboardName bundle:nil];
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        }
        
        if (storyboard) {
            NSMutableArray *mutableChildControllers = [NSMutableArray array];
            
            for (NSString *storyboardID in self.controllersIDs) {
                UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:storyboardID];
                [mutableChildControllers addObject:controller];
            }
            
            self.childControllers = [mutableChildControllers copy];
        }
    }
}

#pragma mark - Setters

- (void)setChildControllers:(NSArray *)childControllers
{
    _childControllers = childControllers;
}

- (void)setChildControllersFromString:(NSString *)controllers
{
    _controllersIDs = [controllers componentsSeparatedByString:@","];
    [self instantiateChildControllers];
}

- (void)setStoryboardName:(NSString *)storyboardName
{
    _storyboardName = storyboardName;
}

- (void)setPageViewController:(UIPageViewController *)pageViewController
{
    if (pageViewController != nil) {
        _pageViewController = pageViewController;
        
        NSAssert(self.childControllers.count > 0, @"Child Controllers must be provided before page view controller");
        [self configureWithInitialControllers:@[self.childControllers.firstObject]];
    }
}

- (void)setPageControl:(UIPageControl *)pageControl
{
    _pageControl = pageControl;
    
    NSUInteger childControllersCount = self.childControllers.count;
    if (childControllersCount > 0) {
        _pageControl.numberOfPages = self.childControllers.count;
    }
}

@end
