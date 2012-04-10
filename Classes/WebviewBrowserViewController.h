//
//  WebviewBrowserViewController.h
//  WebviewBrowser
//
//

#import <UIKit/UIKit.h>

@interface WebviewBrowserViewController : UIViewController<UIWebViewDelegate> {
	IBOutlet UIWebView *webView;
	IBOutlet UITextField *addressBar;
	IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic,retain) UIWebView *webView;
@property(nonatomic,retain) UIWebView *webViewHidden;
@property(nonatomic,retain) UITextField *addressBar;
@property(nonatomic,retain) UIActivityIndicatorView *activityIndicator;

-(IBAction) gotoAddress:(id)sender;
-(IBAction) goBack:(id)sender;
-(IBAction) goForward:(id)sender;
-(IBAction) refresh:(id)sender;

@end
