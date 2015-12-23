# topcoder-hackathon-episode3

## Online app
This is the spec for the app:
* Show the 9 top youtube videos foe the last day in a 3x3 grid.
* Once a user click on the video they are shown the video in a popup
* The number of click is shown next to the video
* Allow for a slider to slide backwards in time ??

## Batch process
This is the spec for the batch process:
* In cron job call the update to get the top 9 videos
* Use giflayer to get a gif for the video if it's not avaialble
* For each day just create a new directory

## Tech stack
This is the tech stack used to create this entry:
* nodejs
* express

* youtube api
* giflayer api
