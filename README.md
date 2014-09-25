<center><img style="margin: 15px" src="https://raw.githubusercontent.com/depl0y/HCP/develop/HCP/Images.xcassets/AppIcon.appiconset/Icon-76@2x.png"></center>

#Home Control Panel

Home Control Panel has been in development for a couple of months now, where the first try to set up this project was too complex and user-unfriendly. Because the scope of the project changed a bit (explanation below) and because I was ready for a *swift*-only project, I decided that most of the stuff could use a rewrite.

#Goals
The goals of **HCP** is to be able to control my home from an iPad which I have laying around. For this, you of course need hardware to perform most of (well, actually: all) functions this application offers.

I want to be able to connect to several devices and all control them from one giant control-panel. With this functionality I want to stay as close to the feature-set as the supported hardware supports.

At first the idea was that only [HomeWizard](http://homewizard.nl) devices could be controlled by this application, but as soon as I added beta testers to the first alpha release of the application, requests for more supported devices came rolling in. So HCP is now less [HomeWizard](http://homewizard.nl) focussed and also functions when you do not have one.

#iOS Compatibility

**iOS8**, HomeKit integration might be useful. It is going to be an universal application, running both on the iPad with iOS8 and your iPhone as well. Currently there are no plans to display a different interface for iPhone 6 and 6+. There will be minor differences between the iPhone and iPad version.

The iPhone version will not prevent locking of your device, which the iPad version will do by default (should be a setting somewhere).

#Supported Hardware

Currently the project focusses on 2 hardware devices, but can later be expanded by either me or other fellow developers.

###HomeWizard
The [HomeWizard](http://homewizard.nl) is a device that let's you tie all kinds of devices together. A couple of supported devices are:
* Smart P1 based power meters
* Klik-aan/Klik-uit switches (quite popular in the Netherlands)
* RF based door sensors
* RF based thermometers
* IP cameras

###Philips Hue
Does the [Philips Hue Bridge](http://www2.meethue.com/en-US) need an introduction? RGB LED powered lights which can be controlled using your phone or tablet.

#Controller definitions
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

It is also important to override the `fields` method, when your custom sensor has settings that can be configured. The example below is the `fields` method from the `Dimmer` sensor. It fetches the fields from the superclass and appends a new configuration option.

```
override func fields() -> [AnyObject]! {
		
	var superFields = super.fields();
	superFields.append([ "key": "defaultDimValue", "title": "Default Dim Value", "type": "number" ]);
	return superFields;
	
}
```

Read the [documentation of FXForms](https://github.com/nicklockwood/FXForms) for more information.

#API documentation

I try to document all the API calls I perform, because not everything is documented as good as I'd like. Visit the [Github Wiki](https://github.com/depl0y/HCP/wiki) I created for this.

#Localisation
The application will be prepared to be fully multi-lingual, but **our** main focus is English and Dutch. We of course will accept pull requests with translations.

#Colors

The application will be have both a light and a dark mode. The light mode will show different colors, while the dark mode uses different tints of gray to differentiate different sensors. Themes will be accepted as pull requests also, as long as you are willing to support them.

#Events
Events are 

#Also on my mind
There are a couple of things that are on my mind, that I would love to integrate in HCP.

* Time based triggers.
* Sensor based trigger.
* XBMC controller, to control XBMC devices located in your house.

*These things will be build after the first release to the App Store.*

#Used Frameworks and tools

For this application I currently use the following frameworks (in no particular order).

* [AFNetworking](http://afnetworking.com) - An awesome networking library that I use for all HTTP requests.
* [Classy](http://classy.as) - Styling of UIKit using CSS-like files.
* [DZNSegmentedControl](https://github.com/dzenbot/DZNSegmentedControl) - A great control, used to page through the screens.
* [FXForms](https://github.com/nicklockwood/FXForms) - A great way to create forms per sensor. This is used for the settings screens.
* [MagicalRecord/Shorthand](https://github.com/magicalpanda/MagicalRecord) - CoreData in an ActiveRecord kind of way.
* [Mogenerator](https://github.com/rentzsch/mogenerator) - Generate Swift files for my CoreData models.
* [Telerik UI for iOS](http://www.telerik.com/ios-ui) (Commercial) - Great graph rendering and feedback system.
* [UICKeyChainStore](https://github.com/kishikawakatsumi/UICKeyChainStore) - Easy KeyChain access.
* [XCGLogger](https://github.com/DaveWoodCom/XCGLogger) - XCGLogger is a log framework written in Swift.

#Thanks
Thanks to the following people, making this project possible:

* [Telerik](http://www.telerik.com/) for supplying me a [Telerik UI for iOS](http://www.telerik.com/ios-ui) license for free to incorporate in this project.
* My wife, for her eternal patience ;)
* My enthousiastic Alpha testers.


-

[![BY-NC Logo](https://i.creativecommons.org/l/by-nc/4.0/80x15.png)](http://creativecommons.org/licenses/by-nc/4.0/)

This work is licensed under a [Creative Commons Attribution-NonCommercial 4.0 International License](http://creativecommons.org/licenses/by-nc/4.0/).