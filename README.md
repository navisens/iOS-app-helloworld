# iOS App Hello World (Objective-C)
An example Objective-C iOS project using the Navisens MotionDNA SDK

___Note: This app is designed to run on iOS 12.0 or higher___

run ```pod install``` from the project folder to install necessary dependencies

## What it does
This project builds and runs a bare bones implementation of our SDK core.

The core is initialized and activated on startup in the view controller triggering a call to the ```startWithDeveloperKey``` method in the view controller. After this occurs the controller checks for necessary location permission and if requirements are satisfied, begins to receive Navisens MotionDNA location estimates through the ```receiveMotionDna:``` callback method. The data received is used to update the appropriate label element with a user's relative x,y and z coordinated along with GPS data and motion categorizations.

Before attempting to run this project please be sure you have obtained a develepment key from Navisens. A key may be acquired free for testing purposes at [this link](https://navisens.com/index.html#contact)

For more complete documentation on our SDK please visit our [NaviDocs](https://github.com/navisens/NaviDocs)


### Setup

Enter your developer key in `ViewController.m` and run the app.
```Objective-C
[_manager startWithDeveloperKey:@"<ENTER YOUR DEV KEY HERE>"];
```

Walk around to see your position update.

## How the SDK works

Please refer to our [NaviDoc](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md#api) for full documentation.

### How you include (and update) the SDK

Add `pod 'MotionDnaSDK` to your podfile and run `pod install` to load the SDK. If there has been a version update to the SDK recently then run `pod update` from the project folder to update the repo.

### How you get your [estimated] position

In our SDK we provide `MotionDnaSDKDelegate` interface which you implement in your view controller and pass to the instantiated SDK. In order to receive estimated positiona and other data, you need to implement the methods listed below.

``` Objective-C
@interface MotionDnaManager: MotionDnaSDK

-(void)receiveMotionDna:(MotionDna*)motionDna;
-(void)reportStatus:(MotionDnaSDKStatus)status message:(NSString *)message;
@end
```

The ``` receiveMotionDna:(MotionDna*)motionDna ``` callback method returns a MotionDna estimation object containing [location, heading and motion classification](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md#estimation-properties) among many other interesting data on a users current state. Here is how we might print it out.

``` Objective-C
-(void)receiveMotionDna:(MotionDna*)motionDna {
  NSLog("%.8f %.8f %.8f %.8f\n",  motionDna.location.local.heading,
                                  motionDna.location.local.x,
                                  motionDna.location.local.y,
                                  motionDna.location.local.z);
}
```
### Running the SDK

Add MotionDnaSDK as a property of your View Controller

``` Objective-C
@property (nonatomic, strong) MotionDnaSDK *motionDnaSDK;
```

## Common Configurations (with code examples)
### Startup
```java
[_motionDnaSDK startWithDeveloperKey:@"<ENTER YOUR DEV KEY HERE>"];
```
### Startup with Configuration (Model Selection)
Additional configuration options will be added over time. Current configuration options are only for model seletion in motion estimation. Currently supported models are "standard", "headmount", and "chestmount".

```java
NSMutableDictionary<NString*, NSObject*> *configuration = [NSMutableDictionary dictionary];
configuration[@"model"] = @"standard";
[_motionDnaSDK startWithDeveloperKey:"<developer-key>" configurations:configuration];
```

### _Assigning initial position Locally (Cartesian X and Y coordinates)_
#### Common Task:
You know that a users position should be shifted by 4 meters in the X direction and 9 in the Y direction. Heading should not change. If the current estimated position is (4,3) the updated position should be (8,12)

``` [_motionDnaSDK setCartesianPositionWithX:4 y:9]; ```


-------------

### _Assigning initial position Globally (Latitude and Longitude coordinates)_

#### Common Tasks:
 You need to update the latitude and longitude to (37.756581, -122.419155). Heading can be taken from the device's compass

``` [_motionDnaSDK setGlobalPositionWithLatitude:37.756581 longitude:-122.419155]; ```

 You know the users location is latitude and longitude of (37.756581, -122.419155) with a heading of 3 degrees and need to indicate that to the SDK

``` [_motionDnaSDK setGlobalPositionWithLatitude:37.756581 longitude:-122.419155 heading:3.0]; ```


------------

### _Observations (EXPERIMENTAL)_
#### Common Task:
A user is indoors and revisits the same areas frequently. Through some outside mechanism the developer is aware of a return to certain landmarks and would like to indicate that the user has returned to a landmark with ID of 38 to aid in the estimation of a user's position. The developer also knows that this observation was made within 3 meters of the landmark 38

``` [_motionDnaSDK recordObservationWithIdentifier:38 uncertainty:3.0]; ```


## Additional configuration options are described in the project source and our [iOS Documentation](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md).
