# Poes
A Swift command-line tool to easily send push notifications to the iOS simulator.

<p align="center">
<img src="https://img.shields.io/badge/language-swift5.1-f48041.svg?style=flat"/>
<img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=flat"/>
</p>

Poes helps you with:

- [x] Generating a JSON payload for push notifications
- [x] Sending and testing push notifications in the simulator

### Requirements
- Xcode 11.4 beta 1 and up

### Usage
```
$ Poes --help
OVERVIEW: A Swift command-line tool to easily send push notifications to the iOS simulator

USAGE: Poes <options>

OPTIONS:
  --body, -b            The body of the Push Notification
  --bundle-identifier   The bundle identifier to push to
  --mutable, -m         Adds the mutable-content key to the payload
  --title, -t           The title of the Push Notification
  --verbose             Show extra logging for debugging purposes
  --help                Display available options
```

The bundle identifier is mandatory, all others have a default value. The following command can be enough to send out a notification:

```
$ Poes --bundle-identifier com.wetransfer.app --verbose
Generated payload:

{
  "aps" : {
    "alert" : {
      "title" : "Default title",
      "body" : "Default body"
    },
    "mutable-content" : false
  }
}

Sending push notification...
Push notification sent successfully
```

### Installation using [Mint](https://github.com/yonaskolb/mint)
You can install Poes using Mint as follows:

```
$ mint install AvdLee/Poes
```

### Why is it called "Poes"?
Poes is a Dutch word for a female cat. The pronunciation is the same as "Push" and pushing notifications is what we're doing here!

### Why is there a `PoesCore` framework?
This makes it really easy to eventually create a Mac App with a UI around it 🚀

### How do I create a Swift Package myself?
Check out my blog post [Swift Package framework creation in Xcode](https://www.avanderlee.com/swift/creating-swift-package-manager-framework/). 
