#!/usr/bin/env bash

if ! icalBuddy -V &> /dev/null
then
    brew install ical-buddy
else
    echo "ical-buddy already installed"
fi
