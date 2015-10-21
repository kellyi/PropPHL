PropPHL
=======

[![Build Status](https://travis-ci.org/kellyi/PropPHL.svg?branch=master)](https://travis-ci.org/kellyi/PropPHL)

PropPHL is an iPhone client for the [City of Philadelphia's Property Data API](http://phlapi.com/opaapi.html). It's the fifth app project for Udacity's [iOS Developer Nanodegree](https://www.udacity.com/course/ios-developer-nanodegree--nd003).

The app enables users to search block-level property-value assessment data from the Philadelphia Office of Property Assessment API. Users can search by an address string, by dropping a pin on a map, or by having the app detect their current location using Core Location services. Once the block data's found from the API, the block's saved along with the specific properties on the block using Core Data. 

Users can browse through saved blocks presented in a table, browse through particular properties on a block in another table, and see detailed information for both blocks and properties. For blocks, this info includes the number of properties on the block, the median assessment value of those properties, the name of the neighborhood the block's in, and a map with a pin designating the block's location; for properties, the map and pin are joined by info like the assessed property value, assessed property taxes, the date and price of the last sale, and an occasionally cryptic but frequently evocative-at-least shorthand description apparently stored with the other data.

**Usage**

On launching the app, you'll see a map, with a pin dropped on the 1500 block of Walnut Street in Center City Philadelphia. Tap the pin and it'll display a callout with the street address and city. To place a pin elsewhere, longpress (1+ seconds) on the map and a new pin will drop (and the prior pin'll disappear.) If you're physically in Philadelphia, you can tap the magnifying glass icon on the right side of the bottom toolbar to have the app find your location and drop a pin nearby.

To find assessment data for the block and the properties on the block, tap the "Find Block" button. That will make the API calls, disabling the buttons and showing an activity indicator until it's complete. On completion -- or failure! -- a custom alertview will pop up to let you know that the app has "Saved 1500 Walnut St," that it "Couldn't connect to the APIs," or whatever other error message. If a block doesn't have any properties with assessment data, it'll show that error message, too.

(Note: the app's currently not perfect at validating addresses of the style "1500-1598 Walnut Street." It works best with address of the style "1550 Walnut Street," but it will also occasionally work with "1500-1598" type addresses, too. Either way, an alert will appear to let you know what happened!)

If you'd prefer to type an address, flip the slider on the toolbar from Map to Address and you'll be presented with a text field. Type it, tap "Find Block," and the app'll ask the APIs for data based on the block you've entered. Both the Address and the Map options accept street numbers and names of the style "1552 Walnut St." The app's got some validation logic to transform "1552" to "1500" for the API call, and it'll even try to capitalize the street name et cetera for a saved block properly.

Here are a few addresses you could try:

- 126 Elfreths Alley
- 1020 Pattison Ave
- 900 S 47th St
- 22 N 3rd Street
- 8111 Germantown Avenue
- 1245 E Passyunk Ave

(The project also includes a few .gpx files to use to simulate locations in the iOS simulator, but [it looks like the ability to switch between them might currently be broken due to an Xcode bug](https://github.com/calabash/calabash-ios/issues/377#issuecomment-141967184).)

Once you've saved a block or two, or three, you can see the saved blocks presented in a table by tapping the file folder on the left side of the navigation bar. Tap a cell to move ahead to a table of the block's properties; tap the detail accessory indicator to see detailed info about the block. Tapping a specific property's tableViewCell will show you a property detail screen. You can also opt to delete blocks or properties with the usual "slide to reveal the delete button" grammar of tableViewCells.

Want to add more properties? Tap the plus-sign-shaped "Add" button on the Blocks table view. You can also see app info by tapping the "Info" button on the navigation bar on the Blocks table view and the Add a New Block view.

Since the app's a Udacity nanodegree project, here's a bit about how it's put together:

**UI/UX**

In addition to the mapView that makes up part of the Add Block view, PropPHL also features several tableViews. Some mostly-straightforward tables show the list of saved blocks and properties, and the app also features grouped tables to display info on the Block Detail view and the Property Detail view. Each of these grouped tables is presented by a UITableViewController class embedded in a container on the detail view.

PropPHL uses two custom open-source view components: DOAlertController and DGRunKeeperSwitch. DOAlertController is a custom UIViewController that operates like a UIAlertController. DGRunKeeperSwitch is a customized subclass of UIControl that supports taps and slide gestures to change its state. I wrote my own subclass of DGRunKeeperSwitch in "AddressMapSwitch.swift" so I could apply some styling without modifying the original class.

([DGRunKeeperSwitch](https://github.com/gontovnik/DGRunkeeperSwitch), and [DOAlertController](https://github.com/okmr-d/DOAlertController) were both used under the MIT license.)

I don't love the interface or the user flow, but putting it together was a good way to start figuring out the work involved in creating a really effective user interface.

**Networking**

PropPHL includes data from two networked APIs: [the City of Philadelphia's Property Data API](http://phlapi.com/opaapi.html) and [Philly Hoods: a neighborhoods API for Philadelphia](http://phillyhoods.net/). The app makes an API call to get block-level data from the property data API, then unwraps the resulting JSON into a Block object and a set of affiliated Property and Pin objects. Once a Block object's created, the app makes another API call to the Philly Hoods API to find the name of the neighborhood the block is in.

The Info screen, incidentally, shows this very README.md file in a UIWebView! (Formatted for mobile, naturally.)

**Persistence**

The app uses Core Data for persistence. The data model includes three entities: Block, Property, and Pin. Among these entities, there are multiple relationships:

- a Block has many Properties
- a Block has one Pin
- a Property belongs to one Block
- a Property has one Pin
- a Pin belongs either to one Block or to one Property

Pin objects store coordinates and act like MKAnnotation objects. You can check out the Block, Property, and Pin files to see how they're put together as classes. The app uses NSFetchedResultsControllers to manage displaying data in its tables.

The app also users NSUserDefaults to persist the state of the AddressMapSwitch.

**One Additional Note, Probably Unnecessary but**

I am not affiliated with the Philadelphia Office of Property Assessment or the City of Philadelphia.

Here's the required attribution from [PHL API](http://phlapi.com/license.html):

"This product uses a City of Philadelphia Data API but is not endorsed or certified by the City of Philadelphia".

**Finally**

I derived the app icon from [this image from Openclipart](https://openclipart.org/detail/179251/brown-house).

**Screenshots**

*Finding a block on the map using a dropped pin or location services*

![mapentry](https://github.com/kellyi/PropPHL/blob/master/screenshots/mapentry.png)

*Finding a block by entering an address*

![textentry](https://github.com/kellyi/PropPHL/blob/master/screenshots/textentry.png)

*Alert popup*

![alert](https://github.com/kellyi/PropPHL/blob/master/screenshots/alertpopup.png)

*Table view of saved blocks*

![blocktable](https://github.com/kellyi/PropPHL/blob/master/screenshots/blocktable.png)

*Block detail view*

![blockdetail](https://github.com/kellyi/PropPHL/blob/master/screenshots/blockdetail.png)

*Table view of saved properties*

![propertytable](https://github.com/kellyi/PropPHL/blob/master/screenshots/propertytable.png)

*Property detail view*

![propertydetail](https://github.com/kellyi/PropPHL/blob/master/screenshots/propertydetail.png)

