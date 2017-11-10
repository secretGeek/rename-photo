# see https://til.secretgeek.net/powershell/rename_photos.html
# usage example:
# dir *.jpg | % { Rename-Photo $_.FullName "iPhoneLB" "Martinique" }

function rename-photo(
    [ValidateScript({Test-Path $_})][string]$fileName,
	[String]$device,
	[String]$location,
    [int]$AddHours){

	if ($fileName -eq "") {
		write-host "Please provide a filename!" -foregroundcolor "red"
		write-host 'Full example: dir *.jpg | % { Rename-Photo $_.FullName "iPhoneLB" "Martinique" }'
		return;
	}

	if ((Test-Path $fileName) -eq $false) {
		write-host "File not found $fileName!" -foregroundcolor "red"
		write-host 'Full example: dir *.jpg | % { Rename-Photo $_.FullName "iPhoneLB" "Martinique" }'
		return;
	}

	if ($device -eq "") {
		write-host "Please provide a device name, e.g. iPhoneLB!" -foregroundcolor "red"
		write-host 'Full example: dir *.jpg | % { Rename-Photo $_.FullName "iPhoneLB" "Martinique" }'
		return;
	}

	if ($location -eq "") {
		write-host "Please provide a location, e.g. Martinique!" -foregroundcolor "red"
		write-host 'Full example: dir *.jpg | % { Rename-Photo $_.FullName "iPhoneLB" "Martinique" }'
		return;
	}

	$null = [reflection.assembly]::LoadWithPartialName("System.Drawing")
	$pic = New-Object System.Drawing.Bitmap($fileName)

	# via http://stackoverflow.com/questions/6834259/how-can-i-get-programmatic-access-to-the-date-taken-field-of-an-image-or-video
	$bitearr = $pic.GetPropertyItem(36867).Value # Date Taken

	$pic.Dispose()

	if ($bitearr -ne $null) {

		$string = [System.Text.Encoding]::ASCII.GetString($bitearr)
		$exactDate = [datetime]::ParseExact($string,"yyyy:MM:dd HH:mm:ss`0",$Null)

    } else {

		# we could not extract an EXIF "Date Taken".
		# perhaps we can one of these dates instead.
		# CreationTime              Property       datetime CreationTime {get;set;}
		# CreationTimeUtc           Property       datetime CreationTimeUtc {get;set;}
		# LastAccessTime            Property       datetime LastAccessTime {get;set;}
		# LastAccessTimeUtc         Property       datetime LastAccessTimeUtc {get;set;}
		# LastWriteTime             Property       datetime LastWriteTime {get;set;}
		# LastWriteTimeUtc          Property       datetime LastWriteTimeUtc {get;set;}
		dir $fileName | % { $exactDate = $_.LastWriteTime; }
	}

	if ($AddHours -ne 0) {
		$exactDate = $exactDate.AddHours($AddHours)
	}

    $length = (dir $fileName | % length )
	$extensionWithDot = [io.path]::GetExtension($FileName)
	$newName = ("{0:yyyy-MM-dd-HH-mm-ss}_{1}_{2}_{3}{4}" -f $exactDate, $device, $location, $length, $extensionWithDot)

	write-host "Creating: $newName"
	rename-item $fileName $newName
}

