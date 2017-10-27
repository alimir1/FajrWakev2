![Fajr Wake: Islamic Alarm Clock app for Fajr](https://raw.githubusercontent.com/alimir1/FajrWakev2/master/fajrWakeBanner.png)

<p align="center">
<a href="https://raw.githubusercontent.com/alimir1/FajrWakev2/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
<a href="https://www.apple.com/ios"><img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" /></a>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift4-compatible-brightgreen.svg" alt="Swift 4 compatible" /></a>
</p>

# Fajr Wake
An Islamic iOS alarm clock app that helps Muslims wake up early morning

<a href="https://itunes.apple.com/us/app/fajr-wake/id1143559369?mt=8"><img src="availableInAppStore.svg" alt="Fajr Wake App Store Link Islamic Alarm Clock App iOS" /></a>

* License: MIT License
* Source repo: https://github.com/alimir1/FajrWakev2
* Version: 2.0
* Made for: [Al-Kisa Foundation](https://kisakids.org/)
* Under the guidance of [Moulana Abidi](http://www.moulananabirazaabidi.com/).
* Developer: [Ali Mir](https://www.github.com/alimir1)

### Minimum Requirements
* [Xcode](https://itunes.apple.com/us/app/xcode/id497799835) - The easiest way to get Xcode is from the [App Store](https://itunes.apple.com/us/app/xcode/id497799835?mt=12), but you can also download it from [developer.apple.com](https://developer.apple.com/) if you have an AppleID registered with an Apple Developer account.

## Development

### Guidelines
These are general guidelines rather than hard rules

#### Objective-C
* [Apple's Coding Guidelines for Cocoa](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html)

#### Swift
* [swift.org API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)

### Third-party Dependencies

We use [Cocoapods](https://cocoapods.org/) to manage third-party native dependencies.

## Setup

1. Install [Cocoapods](https://cocoapods.org/)
2. Xcode 9.0 (with Swift 4.0)
3. Clone the project and open Xcode workspace "Fajr Wake.xcworkspace".

#### Libraries

* [PrayTimes](http://praytimes.org/code/)
* [MBProgressHUD](https://github.com/jdg/MBProgressHUD)
* [SweetAlert](https://github.com/codestergit/SweetAlert-iOS)
* [SwiftyUserDefaults](https://github.com/radex/SwiftyUserDefaults)
* [HGCircularSlider](https://github.com/HamzaGhazouani/HGCircularSlider)

### Architecture

We use MVC design pattern to architect this application.

## Contributing
We 💗 contributors! If you're interested in contributing to the project, please fork this repo and give us a pull request.

## About the app

Islam requires that Muslims pray 5 times a day. These prayers (i.e. Salah) cannot be prayed just at any times. They must be prayed on specific times. The following is a list of 5 obligatory daily prayers with corresponding timing for that prayer:

* **Fajr**: When the sky begins to lighten (dawn).
* **Dhuhr**: When the Sun begins to decline after reaching its highest point in the sky.
* **Asr**: The time when the length of any object's shadow reaches a factor (usually 1 or 2) of the length of the object itself plus the length of that object's shadow at noon.
* **Maghreb**: Soon after sunset.
* **Isha**: The time at which darkness falls and there is no scattered light in the sky.

Fajr prayer begins when the sky begins to lighten and ends at sunrise. (**Note: This is a simplified version of the ruling for non-Muslims to better understand. Please note that there are different opinions amongst Islamic scholars.**).

You can learn more about Islamic prayer times [here](http://praytimes.org/wiki/Prayer_Times_Calculation).

There are many great Islamic prayer time alarm clock apps available at the app store. We created this app because:

* It lets users set appropriate alarm timing based on their needs. For example: at Fajr, 30 min before sunrise, 15 min before Fajr, etc.
* Alarm times are autmocally updated daily (as Fajr and Sunrise timing change every day) so that users don't need to calculate and keep track of wake up time daily.


