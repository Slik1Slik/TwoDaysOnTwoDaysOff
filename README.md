How many times have you got in a situation where you needed to make an appointment with a doctor, and you were asked if you were able to come on, say, Nov 12, and you had to stand there calculating if that would be a day-off? Probably, not so many, if you didn't work in shifts, but some people might share this pain with me. 

The TwoDaysOnTwoDaysOff (2/2) app is to solve the problem. Everything you have to do is to provide the nearest working day, working days and days-off count, and the app will do the rest.

The app also makes it possible to mark a day as an exception, e.g. sick-days or vacation; to define days colors whatever you want; and, of course, it dynamically updates data, so you won't have to do it yourself unless the schedule has changed.

The UI is (almost) fully SwiftUI-based;
The exceptions are stored in the Realm DB. As for the days, they are calculated by an algorithm each time it needs to be done;
Color themes are stored in the app's sandbox in JSON format;
View-Model interaction is based on the MVVM pattern.
