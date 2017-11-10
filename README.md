# rename-photo
A script for renaming photos in a sortable way (using EXIF data and some handy parameters) so you can combine all of your holiday snaps in one folder even though they were taken by 5 different devices.

## Lengthy article:

* [Your photos are a mess! Maybe this PowerShell script can help](http://secretgeek.net/renamephoto)

## To use:

dot source the file `RenamePhoto.ps1`. That is, run this command from powershell: 

    . .\RenamePhoto.ps1
  
Now the `Rename-Photo` function will be available.

So you can, for example, rename a folder full of photos using this command:

    dir *.jpg | % { Rename-Photo $_.FullName "iPhoneSally" "Martinique" 10}

This will rename all of the jpg files in the current folder, to have a filename like this:

    2017-11-10-14-12-10_iPhoneSally_Martinique_53959339.jpg
    
Where:

* `2017-11-10-14-12-10` -- is a sortable representation of the date the photo was taken (from the Date taken EXIF data). It's not formatted in strict ISO 8601 format. If the file doesn't have the relevant EXIF data (for example if it's a png file) then the LastWriteTime is used instead.
* `iPhoneSally` -- is the device name you've supplied as a parameter. This can be helpful later if you need to work out who took a particular photo
* `Martinique` -- is from the 'location' parameter
* `53959339`-- is the number of bytes of the file, and acts as a useful tiebreaker in-case two photos were taken on the same device in the same second. (This was effective for me, over tens of thousands of photos, so I wasn't forced to use something like a checksum for tie-breaking.)

There's one more parameter, and you can use it for fixing the infamous timezone issue. Once you've worked out that the camera's internal clock was reporting times that were 10 hours earlier than the real local time, then add a final parameter of "10", e.g.

    dir *.jpg | % { Rename-Photo $_.FullName "iPhoneSally" "Martinique" 10}
    
If you've made a small mistake, the script can be re-run. There's no limit on how many times you can re-name the same file.
