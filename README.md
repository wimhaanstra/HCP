Home Control Panel
==================

Home Control Panel has been in development for a couple of months now, where the first try to set up this project was too complex and user-unfriendly. Because the scope of the project changed a bit (explanation below) and because I was ready for a *swift*-only project, I decided that most of the stuff could use a rewrite.

#Goals
The goals of **HCP** are to be able to control my home from an iPad which I have laying around. For this, you of course need hardware to perform most of (well, actually: all) functions this application offers.

I want to be able to connect to several devices and all control them from one giant control-panel. With this functionality I want to stay as close to the feature-set as the supported hardware supports.

At first the idea was that only [HomeWizard][1] devices could be controlled by this application, but as soon as I added beta testers to the first alpha release of the application, requests for more supported devices came rolling in. So HCP is now less [HomeWizard][1] focussed and also functions when you do not have one.

#iOS Compatibility

iOS7 and up probably, but when HomeKit is fully revealed by Apple it might be iOS8 and higher.

#Supported Hardware

Currently the project focusses on 2 hardware devices, but can later be expanded by either me or other fellow developers.

###HomeWizard
The [HomeWizard][1] is a device that let's you tie all kinds of devices together. A couple of supported devices are:
* Smart P1 based power meters
* Klik-aan/Klik-uit switches (quite popular in the Netherlands)
* RF based door sensors
* RF based thermometers

###Philips Hue
Does the [Philips Hue Bridge][2] need an introduction? RGB LED powered lights which can be controlled using your phone or tablet.

#Model definitions
In the model these are defined as `Controller` objects. A `Controller` is a device that can control one or more connected devices (like lights, cameras etc.).

Because every controller has different discovery methods and ways to communicate with its devices, the `HueBridge` and `HomeWizard` classes are subclassed from the abstract `Controller` class.

The `Controller` class defines a couple of methods that each subclass of the `Controller` class should override.

**Override these methods**

`class func discover(completion: (results: [Controller]) -> Void)`

The **discover** method should try to find local controllers of this type. Both the Hue Bridge and the HomeWizard devices support discovery of local devices. These devices should be returned in an array, while **not yet** stored in the CoreData database.


`func start()`

For both the HomeWizard and the Hue Bridge, this starts a timer which fetches data and new sensors on a regular interval.


`func stop()`

This should stop the timers that are running on the `Controller` object.


#Sensor definitions
Every supported device-type has its own model defined. For example a simple `Switch` connected to the HomeWizard has a model names `Switch`. Each model has the responsibility to create a request which can be send to the `Controller` to perform the selected action.

A switch has 2 methods, `on` and `off` and this is an example of the `on` function.

```
func on() -> Void {
        
    self.controller!.performAction(String(format: "/sw/%d/on", self.id!), completion: { (results) -> Void in
    });
        
}
```

[1]: http://homewizard.nl
[2]: http://www2.meethue.com/en-US

#API documentation

I try to document all the API calls I perform, because not everything is documented as good as I'd like. Visit the [Github Wiki][7] I created for this.

[7]: https://github.com/depl0y/HCP/wiki

#Localisation
The application will be prepared to be fully multi-lingual, but our main focus is English and Dutch.

#Used Frameworks and tools

For this application I currently use the following frameworks:

* [AFNetworking][3] - An awesome networking library that I use for all HTTP requests.
* [MagicalRecord][4] - CoreData in an ActiveRecord kind of way
* [Mogenerator][5] - Generate Swift files for my CoreData models
* [CocoaLumberjack][6] - Better logging than `NSLog`.

[3]: http://afnetworking.com
[4]: https://github.com/magicalpanda/MagicalRecord
[5]: https://github.com/rentzsch/mogenerator
[6]: https://github.com/CocoaLumberjack/CocoaLumberjack

#License
I chose the current license because I want to be able to share my progress and code with the world, but I also have the intention of putting this application up in the Apple App Store and maybe fund some more hardware for my HCP setup.