# iOS App Hello World (Objective-C)
An example Objective-C iOS project using the Navisens MotionDNA SDK

___Note: This app is designed to run on iOS 9.1 or higher___

run ```pod install``` from the project folder to install necessary dependencies

## What it does
This project builds and runs a bare bones implementation of our SDK core.

The core is initialized and activated on startup in the view controller triggering a call to the ```startMotionDna``` method in the view controller. After this occurs the controller checks for necessary location permission and if requirements are satisfied, begins to receive Navisens MotionDNA location estimates through the ```receiveMotionDna:``` callback method. The data received is used to update the appropriate label element with a user's relative x,y and z coordinated along with GPS data and motion categorizations.

Before attempting to run this project please be sure you have obtained a develepment key from Navisens. A key may be acquired free for testing purposes at [this link](https://navisens.com/index.html#contact)

For more complete documentation on our SDK please visit our [NaviDocs](https://github.com/navisens/NaviDocs)


### Setup

Enter your developer key in `ViewController.m` and run the app.
```Objective-C
[_manager runMotionDna:@"<ENTER YOUR DEV KEY HERE>"];
```

Walk around to see your position update.

## How the SDK works

Please refer to our [NaviDoc](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md#api) for full documentation.

### How you include (and update) the SDK

Add `pod 'MotionDnaSDK` to your podfile and run `pod install` to load the SDK. If there has been a version update to the SDK recently then run `pod update` from the project folder to update the repo.

### How you get your [estimated] position

In our SDK we provide `MotionDnaSDK` class which you subclass and override. In order to receive estimated positiona and other data, you need to override the key methods listed below.

``` Objective-C
@interface MotionDnaManager: MotionDnaSDK

-(void)receiveMotionDna:(MotionDna*)motionDna;
-(void)receiveNetworkData:(MotionDna*)motionDna;
-(void)receiveNetworkData:(NetworkCode)opcode WithPayload:(NSDictionary*)payload;
-(void)reportError:(ErrorCode)error WithMessage:(NSString*)message;

@end
```

The ``` receiveMotionDna:(MotionDna*)motionDna ``` callback method returns a MotionDna estimation object contains [location, heading and motion type](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md#getters) among many other interesting data on a users current state. Here is how we might print it out.
``` Objective-C
-(void)receiveMotionDna:(MotionDna*)motionDna {
  NSLog("%.8f %.8f %.8f %.8f\n",  motionDna.getLocation().heading,
                                  motionDna.getLocation().localLocation.x,
                                  motionDna.getLocation().localLocation.y,
                                  motionDna.getLocation().localLocation.z);
}
```
### Running the SDK

#### In Objective-C
Add the subclassed MotionDnaSDK as a property of your View Controller

``` Objective-C
@property (nonatomic, strong) MotionDnaManager *motionDnaSDK;
```

## Common Configurations (with code examples)
### Startup
```java
[_motionDnaSDK runMotionDna:@"<ENTER YOUR DEV KEY HERE>"];
```
### Startup with Configuration (Model Selection)
Additional configuration options will be added over time. Current configuration options are only for model seletion in motion estimation. Currently supported models are "standard", "headmount", and "chestmount".

```java
NSMutableDictionary<NString*, NSObject*> *configuration = [NSMutableDictionary dictionary];
configuration[@"model"] = @"standard";
[_motionDnaSDK runWithDeveloperKey:"<developer-key>" andConfigurations:configuration];
```

### Setting SDK Options
#### Common Task:
You only require an update of a users position every half a second and would like a user's position in the global frame (latitude and longitude) to be as accuracte as possible
```Objective-C
[_motionDnaSDK setCallbackUpdateRateInMs:500];
[_motionDnaSDK setExternalPositioningState:HIGH_ACCURACY];
```
These should alway be called after the runWithDeveloperKey:andConfigurations: or runMotionDna: method has been called

-------------

### _Assigning initial position Locally (Cartesian X and Y coordinates)_
#### Common Tasks:
You know that a users position should be shifted by 4 meters in the X direction and 9 in the Y direction. Heading should not change. If the current estimated position is (4,3) the updated position should be (8,12)

``` [_motionDnaSDK setCartesianPositionX:4 Y:9]; ```

You wish to update your X and Y positions to 3 in the X and 4 meters in the Y direction. Heading should not be affected

``` [_motionDnaSDK setCartesianOffsetInMetersX:3 Y:4]; ```

-------------

### _Assigning initial position Globally (Latitude and Longitude coordinates)_

#### Common Tasks:
 You need to update the latitude and longitude to (37.756581, -122.419155). Heading can be taken from the device's compass

``` [_motionDnaSDK setLocationLatitude:37.756581 Longitude:-122.419155]; ```

 You know the users location is latitude and longitude of (37.756581, -122.419155) with a heading of 3 degrees and need to indicate that to the SDK

``` [_motionDnaSDK setLocationLatitude:37.756581 Longitude:-122.419155 AndHeadingInDegrees:3.0]; ```

You have a use case that will be outside often and wish to have the SDK determine a users latitude, longitude and heading automatically

``` [_motionDnaSDK setLocationNavisens]; ```

------------

### _Observations (EXPERIMENTAL)_
#### Common Task:
A user is indoors and revisits the same areas frequently. Through some outside mechanism the developer is aware of a return to certain landmarks and would like to indicate that the user has returned to a landmark with ID of 38 to aid in the estimation of a user's position. The developer also knows that this observation was made within 3 meters of the landmark 38

``` [_motionDnaSDK recordObservationWithIdentifier:38 andUncertainty:3.0]; ```


## Additional configuration options are described in the project source and our [iOS Documentation](https://github.com/navisens/NaviDocs/blob/master/API.iOS.md).
