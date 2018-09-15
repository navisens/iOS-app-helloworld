# iOS App Hello World
___Note: This app is designed to run on iOS 9.1 or higher___

An example Objective-C iOS project using the Navisens MotionDNA SDK

run ```pod install``` from the project folder to install necessary dependencies

# Getting Started (Native)

Open a new project in xcode and navigate to the project folder.

## Installing the MotionDna SDK

Make sure you already have cocoapods installed. This is the package manager we use to distribute our SDK and is the simplest way for you to integrate it into your app.

To install the SDK navigate to the root folder of your project in terminal and type the following command.

``` pod init ```

This will generate a Podfile which you can specify our SDK as one of your dependencies for our app.

Open the Podfile in your project folder. It should look something like this:

``` bash
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'YourProjectName' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for YourProjectName

end
```

Add the line ``` pod 'MotionDnaSDK', :git => 'https://github.com/navisens/iOS-SDK.git' ``` to the file it should now resemble the text below.

``` bash
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'YourProjectName' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for YourProjectName
  pod 'MotionDnaSDK', :git => 'https://github.com/navisens/iOS-SDK.git'
end
```

Save this file and return to the terminal within your project folder. Type the following command.

``` pod install ```

This will install the SDK to your project folder and generate an xcode workspace from which to build and run your project. If you already have xcode open at this point you should close it and reopen using this generated workspace.


## What it does
This project builds and runs a bare bones implementation of our SDK core. 

The core is initialized and activated on startup in the view controller triggering a call to the ```startMotionDna``` method in the view controller. After this occurs the controller checks for necessary location permission and if requirements are satisfied, begins to receive Navisens MotionDNA location estimates through the ```receiveMotionDna:``` callback method. The data received is used to update the appropriate label element with a user's relative x,y and z coordinated along with GPS data and motion categorizations.

Before attempting to run this project please be sure you have obtained a develepment key from Navisens. A key may be acquired free for testing purposes at [this link](https://navisens.com/index.html#contact)

For more complete documentation on our SDK please visit our [NaviDocs](https://github.com/navisens/NaviDocs)


## Setting up your Project for MotionDna

The Navisens MotionDna SDK is implemented in your project by first subclassing the MotionDnaSDK class and then implementing select callbacks for receiving estimation data and other various pieces of information

The structure of this class should resemble the following code and implement a subset of the methods listed.

##### In Objective-C:
###### MotionDnaManager.h
``` Objective-C
#import <Foundation/foundation.h>
#import <MotionDnaSDK/MotionDnaSDK.h>
#import <MotionDnaSDK/MotionDna.h>

@interface MotionDnaManager: MotionDnaSDK

-(void)receiveMotionDna:(MotionDna*)motionDna;
-(void)receiveNetworkData:(MotionDna*)motionDna;
-(void)receiveNetworkData:(NetworkCode)opcode WithPayload:(NSDictionary*)payload;
-(void)reportError:(ErrorCode)error WithMessage:(NSString*)message;

@end
```
###### MotionDnaManager.m
``` Objective-C
@implementation HelloWorld

-(void)receiveMotionDna:(MotionDna*)motionDna {
  NSLog("%.8f %.8f %.8f %.8f\n", motionDna.getLocation().heading, motionDna.getLocation().localLocation.x, motionDna.getLocation().localLocation.y, motionDna.getLocation().localLocation.z);
}

-(void)receiveNetworkData:(MotionDna*)motionDna {

}

-(void)receiveNetworkData:(NetworkCode)opcode WithPayload:(NSDictionary*)payload {

}

-(void)reportError:(ErrorCode)error WithMessage:(NSString*)message {

}

@end

```

The ``` receiveMotionDna:(MotionDna*)motionDna ``` method is the key method in using the SDK. It will be responsible for passing location data from our core to your project. The MotionDna object contains your x,y,and z coordinates (in meters) with respect to your starting position, as well as a your current latitude and longitude and several other metrics of interest which you can read about in more detail in our [documentation](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md#getters).

Our SDK also support location sharing through the use of a server and the startUDP() method calls. Data is received by the  ``` receiveNetworkData ``` methods. The base method is passed a MotionDna object that for each user that is also sharing with the same host, developer key, and room.

The ``` reportError ``` callback received information regarding any issue that may have arisen over the course of trying to run our SDK. This can range from authentication errors with your developer key, to missing permissions that are needed for our system to run. For a full list see our documentation [here](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md#reporterror_-errorcode-errorcode-withmessage-s-string).

## Running the SDK

#### In Objective-C
Add the MotionDnaManager as a property of your view ViewController
##### ViewController.h
``` Objective-C
@property (nonatomic, strong) MotionDnaManager *_manager;
```

Within the ``` viewDidLoad ``` method of your view controller add the following

##### ViewController.m
``` Objective-C
- (void)viewDidLoad {
  _manager = [[MotionDnaManager alloc] init];
  [_manager runMotionDna:str];
  [_manager setLocationNavisens];
}
```

Substitute ``` <developer-key> ``` with your own Navisens provided developer key. Again, if you do not yet have one then please navigate to our [developer sign up](https://www.navisens.com/index.html#contact) to request a free key.

Running this project will begin to show your location estimation in the console. Walk around to see how it changes your x, y, and z coordinates.

Additional configuration options are described in the project source and our iOS [documentation](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md). 
