

good mantra or options parsing

https://github.com/lindes/oyster



![Realm](logo.png)

Realm is a mobile database that runs directly inside phones, tablets or wearables.
This repository holds the source code for the iOS & OSX versions of Realm, for both Swift & Objective-C.

## Features

* **Mobile-first:** Realm is the first database built from the ground up to run directly inside phones, tablets and wearables.
* **Simple:** Data is directly [exposed as objects](http://realm.io/docs/cocoa/#models) and [queryable by code](http://realm.io/docs/cocoa/#queries), removing the need for ORM's riddled with performance & maintenance issues. Plus, we've worked hard to [keep our API down to just 4 common classes](http://realm.io/docs/cocoa/api/) (Object, Array, Results and Realms) and 1 utility class (Migrations): most of our users pick it up intuitively, getting simple apps up & running in minutes.
* **Modern:** Realm supports relationships, generics, vectorization and even Swift.
* **Fast:** Realm is faster than even raw SQLite on common operations, while maintaining an extremely rich feature set.

## Getting Started

Please see the [detailed instructions in our docs](http://realm.io/docs/cocoa/#installation) to add Realm to your Xcode project.

## Documentation

Documentation for Realm can be found at [realm.io/docs/cocoa](http://realm.io/docs/cocoa).  
The API reference is located at [realm.io/docs/cocoa/api](http://realm.io/docs/cocoa/api).

## Getting Help

- **Reproducible Bugs & Feature Requests** should be filed directly against our [Github Issues](https://github.com/realm/realm-cocoa/issues).
- **Discussions & Support**: [realm-cocoa@googlegroups.com](https://groups.google.com/d/forum/realm-cocoa).
- **StackOverflow**: look for previous questions under the tag [#realm](https://stackoverflow.com/questions/tagged/realm?sort=newest) — or [open a new one](http://stackoverflow.com/questions/ask?tags=realm).
- Sign up for our [**Community Newsletter**](http://eepurl.com/VEKCn) to get regular tips, learn about other use-cases and get alerted of blogposts and tutorials about Realm.
- Attend our monthly [**Online Office Hours**](https://attendee.gotowebinar.com/rt/1182038037080364033) to ask questions directly to the team.

## Building Realm

In case you don't want to use the precompiled version, you can build Realm yourself from source.

Prerequisites:

* Building Realm requires Xcode 6.
* Building Realm documentation requires [appledoc](https://github.com/tomaz/appledoc)

Once you have all the necessary prerequisites, building Realm.framework just takes a single command: `sh build.sh build`. You'll need an internet connection the first time you build Realm to download the core binary.

Run `sh build.sh help` to see all the actions you can perform (build ios/osx, generate docs, test, etc.).

Executing the examples under the `examples/` folder, requires that you have built the `Realm.framework`.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for more details!

## License

Realm Cocoa is published under the Apache 2.0 license.  
The underlying core is available under the [Realm Core Binary License](https://github.com/realm/realm-cocoa/blob/master/LICENSE#L210-L243) while we [work to open-source it under the Apache 2.0 license](http://realm.io/docs/cocoa/#faq).

## Feedback

**_If you use Realm and are happy with it, all we ask is that you please consider sending out a tweet mentioning [@realm](http://twitter.com/realm), announce your app on [our mailing-list](https://groups.google.com/forum/#!forum/realm-cocoa), or email [help@realm.io](mailto:help@realm.io) to let us know about it!_**

**_And if you don't like it, please let us know what you would like improved, so we can fix it!_**

![analytics](https://ga-beacon.appspot.com/UA-50247013-2/realm-cocoa/README?pixel)




/*
 * VERY important single-line comments look like this.
 */

/* Most single-line comments look like this. */

/*
 * Multi-line comments look like this.  Make them real sentences.  Fill
 * them so they look like real paragraphs.
 */

Copyright header at top of file.

Leave another blank line before the header files.
Non-local includes in angle brackets.
Kernel include files (i.e. sys/*.h) come first;
Leave a blank line before the next group, the framework and /usr include files, which should be sorted alphabetically by name.
Leave another blank line before the user include files.
Local includes in double quotes.

Space after keywords (if, while, for, return, switch).  No braces are
     used for control statements with zero or only a single statement unless
     that statement is more than a single line in which case they are permit-
     ted.  Forever loops are done with for's, not while's.

Variable names should contain underscores to separate words.

Do not add whitespace at the end of a line, and only use tabs followed by spaces to form the indentation.  Do not use more spaces than a tab will produce and do not use spaces in front of tabs.

Closing and opening braces go on the same line as the else.  Braces that are not necessary may be left out.

No spaces after function names.  Commas have a space after them.  No spaces after `(' or `[' or preceding `]' or `)' characters.

Use err(3) or warn(3), do not roll your own.

Main should be
int main(int argc, char *argv[])
(getopt shuffles argv)

Use getopt_long or getopt_long_only; provide at least --help and --version.

Use climac_version_info(); to print standard copyright information -- if copyright belongs to lipidity.com
else use custom_version_info(...)
