# ReVerse

## Purpose
ReVerse is a web app that allows spotify users to associate fond memories with their favorite songs from their spotify library. Users organize these memories into an interactive timeline where they can associate images with a song and write a blurb of what this song means to them.

## The Timeline
![timeline](https://i.imgur.com/REO70wg.png)
This is a basic timeline. All of your memories are displayed here by month, and then inside of each month theya re sorted by date.

## Memories
Memories are the most basic aspect of a timeline. They are references to a certain song that contain your media and written text. Think of memories like an entry in a journal. This is what a memory looks like on your timeline:
![memorytl](https://i.imgur.com/fB7iAIG.png)

To add a memory simply click the "add memory button" on the timeline nav. This is what the form looks like:
![memform](https://i.imgur.com/0UrqmY1.png)

This is what a memory looks like when you click on it, the data you specified is shown:
![shownmem](https://i.imgur.com/qxna4et.png)

Here you can write about what this song means to you, specify a relative date, and attach a photo. The imageurl could be a link to the photo in google drive, google images, imgur, etc. We are working on direct uploads.

## Sharing your Timeline
To share your timeline with a friend, simply click the share timeline button at the top of your timeline nav. That will bring up a form. Enter in your friend's email that is attached to their spotify account:
![share](https://i.imgur.com/3RcSphK.png)

By default all users are subscribed to me. To manage your subscriptions and view the timelines you are subscribed to, click your name in the top left of the and you'll be taken to the activity feed:
![activy](https://i.imgur.com/HB6UunJ.png)

To view people subscribed to you, click on 'my profile':
![prof](https://i.imgur.com/rb0y6bh.png)

To manage your subscriptions, click on 'manage':
![maag](https://i.imgur.com/kjvoO1e.png)

## Friend Activity
When users first log in, they are taken to the friend activity feed. Users who have shared their timeline with you will show up here. Their activity from the past day populates this feed:
![feed](https://i.imgur.com/6nNa4JR.png)

You can manage your subscriptions by clicking the "manage" button in the top nav:
![maaeee](https://i.imgur.com/SwYWPVD.png)

## Developers: Install rails on your computer
This app utilizes Ruby on Rails, to run you need to set up a development environment on your computer.
Check out [this](https://gorails.com/setup/osx/10.14-mojave) guide.
