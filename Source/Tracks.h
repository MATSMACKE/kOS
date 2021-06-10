/*
  ==============================================================================

    Tracks.h
    Created: 9 Jun 2021 8:23:14pm
    Author:  matsm

    This file contains all declarations of the TrackManager and Track classes

  ==============================================================================
*/

#pragma once

#include "MainComponent.h"

// Vector is used for list of tracks in TrackManager
// String is used for names of Tracks and Managers
#include <vector>
#include <string>

using std::string;
using std::vector;

// Declare Track class (required to create trackVector in TrackManager
class Track;

// Declare and define TrackManager class
class TrackManager {
private:
    // trackVector stores all of the Tracks for the project, making it
    // one of the most important variables in the whole app
    vector<Track> trackVector;

public:
    // Create constructor
    TrackManager(string managerName);

    // Create function for creating Tracks
    void createTrack(string trackName, Track::TrackType trackType);
};

// Define Track class
class Track {
public:
    // Create an enum of types of tracks
    enum class TrackType {
        midi,
        audio,
        group,
        trigger,
        bus,
        send,
        master
    };

private:
    int trackIndex;
    string trackName;
    TrackType trackType;

public:
    Track(TrackManager manager, string name, TrackType requestedType);
};