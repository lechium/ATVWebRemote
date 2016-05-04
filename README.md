# ATVWebRemote

This project is currently split up into 3 separate targets. 

ATVWebRemote: The server that works on the AppleTV 4 itself, this target doesn't
build directly through Xcode, and only exists for easy code editing.

It runs a Cydia Substrate tweak that mainly serves up a webserver, hooks
into PineBoard.app and forwards the HID commands through it. This may
not be necessary and may change in the near future.

AirMagicClient:

Mac client app for the AirMagic server mentioned above. This is pretty much a 
carbon copy of the AirControl mac client app I wrote for firecore when
this same project was called AirControl for the AppleTV 2. Minor changes
and updated for ARC support. Code is kinda messy, but it works.

AirMagiciOS:

An iOS version of the client, has some minor bugs that I havent hunted down
yet, currently only for iPhone and doesn't really have much flexibility 
regarding layout, but it delivers practically identical functionality to
the mac client.

Windows version: https://github.com/lechium/AirMagicWindows


