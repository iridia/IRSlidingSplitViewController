# IRSlidingSplitViewController

Two sliding panes backed by Master and Detail view controllers.

## Sample

Look at the [Sample App](https://github.com/iridia/IRSlidingSplitViewController-Sample).  You’ll notice that it slides vertically — which is expected: the sample app contains a tiny subclass of the Sliding Split View Controller that allows you to override the sliding direction pretty easily.

## What’s Inside

You can find an `IRSlidingSplitViewController`, and on its interface:

	@property (nonatomic, readwrite, assign) BOOL showingMasterViewController;
	@property (nonatomic, readwrite, strong) IBOutlet UIViewController *masterViewController;
	@property (nonatomic, readwrite, strong) IBOutlet UIViewController *detailViewController;

That pretty much sums up what it does.  You can set it up with Interface Builder, or with code.

Also, it exposes these methods for toggling things on and off:

	- (void) setShowingMasterViewController:(BOOL)showingMasterViewController animated:(BOOL)animate completion:(void(^)(BOOL didFinish))callback;

	- (void) setMasterViewController:(UIViewController *)toMasterVC animated:(BOOL)animate completion:(void(^)(BOOL didFinish))callback;
	- (void) setDetailViewController:(UIViewController *)toDetailVC animated:(BOOL)animate completion:(void(^)(BOOL didFinish))callback;

So, you can actually do things like this in a sliding table-detail navigation app:

	[wSlidingSplitVC setDetailViewController:toDetailVC animated:YES completion:^(BOOL didFinish) {
		
		[wSlidingSplitVC setShowingMasterViewController:NO animated:YES completion:nil];
			
	}];

## Licensing

This project is in the public domain.  You can use it and embed it in whatever application you sell, and you can use it for evil.  However, it is appreciated if you provide attribution, by linking to the project page ([https://github.com/iridia/IRSlidingSplitViewController](https://github.com/iridia/IRSlidingSplitViewController)) from your application.

## Credits

*	[Evadne Wu](http://twitter.com/evadne) at [Iridia Productions](http://iridia.tw) ([Info](http://radi.ws))
