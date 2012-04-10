//
//  WebviewBrowserAppDelegate.h
//  WebviewBrowser
//

#import <UIKit/UIKit.h>

@class WebviewBrowserViewController;

@interface WebviewBrowserAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    WebviewBrowserViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WebviewBrowserViewController *viewController;

@end

