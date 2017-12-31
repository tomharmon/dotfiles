

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


def main():
	# open the plist file that describes the songs the iTunes library is supposed to contain
	# if this gives errors, open the file name first as a binary file object
	itunesLibraryFile = pl.readPlist("./Library.xml")

	# get the dictionary for all tracks
	tracks = itunesLibraryFile["Tracks"]

	# For each track in iTunes library, check if a file exists at the
	# given 

	# Loop through each file on hard drive and check if that 




sys.exit(0)

# For the given artist, delete any songs on the hard drive that are not
# in the iTunes Library
def removeUnusedArtistsSongs(artistName):
	directoryPath = musicPath + artistName
	rootDirectory = os.fsencode(directoryPath)
	for subdir, dirs, files in os.walk(rootDirectory):
		for file in files:
			fileName = file.fsdecode(file)
			for dict in tracks:
				currentTrack
				if fileName == 
			if fileName in 
	return false


def main():
	# Loop through all songs on disk and check if they exist in library
	# If they are not in iTunes library, remove them from disk
	artistNames = getArtists()
	for artist in artistNames:
		removeUnusedArtistsSongs(artist)
