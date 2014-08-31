Home Control Panel
==================

Home Control Panel has been in development for a couple of months now, where the first try to set up this project was too complex and user-unfriendly. Because the scope of the project changed a bit (explanation below) and because I was ready for a *swift*-only project, I decided that most of the stuff could use a rewrite.

Goals
-
The goals of **HCP** are to be able to control my home from an iPad which I have laying around. For this you of course need hardware to perform most of (well, actually: all) functions this application offers.

I want to be able to connect to several devices and all control them from one giant control-panel. With this functionality I want to stay as close to the feature-set as the supported hardware supports.

iOS Compatibility
-
iOS7 and up probably, but when HomeKit is fully reveiled by Apple it might be iOS8 and higher.

Supported Hardware
-
Currently the project focusses on 2 hardware devices, but can later be expanded by either me or other fellow developers.

* [HomeWizard][1] and all the devices you are able to connect to that device.
* [Philips Hue Bridge][2] and the lights that can be connected to that device.

[1]: http://homewizard.nl
[2]: http://www2.meethue.com/en-US

Used Frameworks and tools
-
For this application I currently use the following frameworks:

* [AFNetworking][3]
* [MagicalRecord][4]
* [Mogenerator][5]
* [CocoaLumberjack][6]

[3]: http://afnetworking.com
[4]: https://github.com/magicalpanda/MagicalRecord
[5]: https://github.com/rentzsch/mogenerator
[6]: https://github.com/CocoaLumberjack/CocoaLumberjack

License
-
I chose the current license because I want to be able to share my progress and code with the world, but I also have the intention of putting this application up in the Apple App Store and maybe fund some more hardware for my HCP setup.