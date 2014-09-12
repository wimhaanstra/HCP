Home Control Panel
==================

Home Control Panel has been in development for a couple of months now, where the first try to set up this project was too complex and user-unfriendly. Because the scope of the project changed a bit (explanation below) and because I was ready for a *swift*-only project, I decided that most of the stuff could use a rewrite.

#Goals
The goals of **HCP** is to be able to control my home from an iPad which I have laying around. For this, you of course need hardware to perform most of (well, actually: all) functions this application offers.

I want to be able to connect to several devices and all control them from one giant control-panel. With this functionality I want to stay as close to the feature-set as the supported hardware supports.

At first the idea was that only [HomeWizard](http://homewizard.nl) devices could be controlled by this application, but as soon as I added beta testers to the first alpha release of the application, requests for more supported devices came rolling in. So HCP is now less [HomeWizard](http://homewizard.nl) focussed and also functions when you do not have one.

#iOS Compatibility

**iOS8**, better make sure you got your devices updated and ready.

#Supported Hardware

Currently the project focusses on 2 hardware devices, but can later be expanded by either me or other fellow developers.

###HomeWizard
The [HomeWizard](http://homewizard.nl) is a device that let's you tie all kinds of devices together. A couple of supported devices are:
* Smart P1 based power meters
* Klik-aan/Klik-uit switches (quite popular in the Netherlands)
* RF based door sensors
* RF based thermometers

###Philips Hue
Does the [Philips Hue Bridge](http://www2.meethue.com/en-US) need an introduction? RGB LED powered lights which can be controlled using your phone or tablet.

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

        // Just cast to HomeWizard, this will never make it in production code.... right?        
        (self.controller! as HomeWizard).performAction(String(format: "/sw/%d/on", self.id!), completion: { (results) -> Void in
        });
        
}
```

#API documentation

I try to document all the API calls I perform, because not everything is documented as good as I'd like. Visit the [Github Wiki](https://github.com/depl0y/HCP/wiki) I created for this.

#Localisation
The application will be prepared to be fully multi-lingual, but our main focus is English and Dutch.

#Used Frameworks and tools

For this application I currently use the following frameworks:

* [AFNetworking](http://afnetworking.com) - An awesome networking library that I use for all HTTP requests.
* [MagicalRecord/Shorthand](https://github.com/magicalpanda/MagicalRecord) - CoreData in an ActiveRecord kind of way.
* [Mogenerator](https://github.com/rentzsch/mogenerator) - Generate Swift files for my CoreData models.
* [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack) - Better logging than `NSLog`.
* [UICKeyChainStore](https://github.com/kishikawakatsumi/UICKeyChainStore) - Easy KeyChain access.
* [DZNSegmentedControl](https://github.com/dzenbot/DZNSegmentedControl) - A great control, used to page through the screens.

-

[![BY-NC Logo](https://i.creativecommons.org/l/by-nc/4.0/80x15.png)](http://creativecommons.org/licenses/by-nc/4.0/)

This work is licensed under a [Creative Commons Attribution-NonCommercial 4.0 International License](http://creativecommons.org/licenses/by-nc/4.0/).