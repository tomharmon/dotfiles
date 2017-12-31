

# Written by Thomas Harmon
# This will navigate to the itunes media folder and delete any file that isn't contained in 
# The itunes Libaray.xml file
import os
from urllib.parse import urlparse
import plistlib as pl

# Global variable for the iTunes Media folder absolute path name
musicPath = os.path.expanduser("~/Music/iTunes/iTunes Media/Music/")

# Return an array of all Artist Names on the hard drive
def getArtists():
	directory = os.fsencode(musicPath)
	artistNames = []
	for subDir in os.listdir(directory):
		subDirName = os.fsdecode(subDir)
		artistNames.append(subDirName)
	return artistNames

# For the given artist, delete any songs on the hard drive that are not
# in the iTunes Library
def removeUnusedArtistsSongs(artistName, songsToDelete):
	directoryPath = musicPath + artistName
	rootDirectory = os.fsencode(directoryPath)
	for subdir, dirs, files in os.walk(rootDirectory):
		for file in files:
			fileLocation = file.fsdecode(file)
			isFileInLibrary = false
			songName = " "
			for dict in tracks:
				currentTrackLocation = urlparse.unquote(dict['Location'])
				isFileInLibrary = isFileInLibrary or fileLocation == currentTrackLocation
				if fileLocation == currentTrackLocation:
					songName = dict['Name']
			if not isFileInLibrary:
				# the file was not in the library, remove it from the hard disk
				# for now, add it to a list of songs and then return them
				songsToDelete.extend(songName)


def main():
	# open the plist file that describes the songs the iTunes library is supposed to contain
	# if this gives errors, open the file name first as a binary file object
	itunesLibraryFile = pl.readPlist("./Library.xml")

	# get the dictionary for all tracks
	tracks = itunesLibraryFile["Tracks"]

	# get a list of the names of all Artists on the physical hard drive
	artistNames = getArtists()

	# print the songs to delete
	for song in songsToDelete:
		print(song + '\n')

	print('\n\n\n\n')

	# declare the array that will hold the name of all songs on the hard drive and not in the library
	# that should be deleted
	songsToDelete = []

	# For each artist on hard drive, loop through physical songs on hard
	# drive and check if they exist in iTunes library
	for artist in artistNames:
		removeUnusedArtistsSongs(artist, songsToDelete)

	# print the songs to delete
	for song in songsToDelete:
		print(song + '\n')




	sys.exit(0)
