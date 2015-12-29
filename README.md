# topcoder-hackathon-episode3

## Online app
This is the spec for the app:
* Show the 9 top youtube videos foe the last day in a 3x3 grid.
* Once a user click on the video they are shown the video in a popup
* Allow for user to go backwards in time one day at a time

## Batch process
This is the spec for the batch process:
* In cron job call the update to get the top 9 videos
* Use giflayer to get a gif for the video if it's not yet available as a gif

## Tech stack
This is the tech stack used to create this entry:

* nodejs
* express
* bootstrap
* youtube api
* giflayer api

## TODO
* Add google analytics
* Deploy to somewhere : yougif.abicat.com
* Error handling. Right now there is almost no error handling.
* Some kind of waiting to load image.
* Some kind of error indicator for images that could not be loaded.
* Generate the gif's to S3

## Notes
* new Date(publishedAfterDate.getDate! +1) - Obscure error in livescript it should be + 1 not +1...
* Had to remove pepper flash player in chrome to stop machine from crashing with 9 gifs open.
