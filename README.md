# Film Locations
Film Locations in San Francisco

#### Description

If you love movies, and you love San Francisco, you're bound to love this -- a listing of filming locations of movies shot in San Francisco starting from 1924. You'll find the titles, locations, fun facts, names of the director, writer, actors, and studio for most of these films.

Dataset:    https://data.sfgov.org/api/views/yitu-d5am/rows.json?accessType=DOWNLOAD

API documentation:  https://data.sfgov.org/developers

#### Build Requirements

    - Xcode 9.0
    - iOS 10.0 or later
    - Swift 4.0
    - Devices: Universal

#### Design & Architeture
    - MVVM Architecture
    	- Controllers to update UIs
    	- ViewModel to prepare and manage data.
    	- Views
          - A master view to list all the movies by name and year
          - Map view to show the location of a scene a movie has been shot
    - CoreData Stack
    - Data Models
        - Movies: Contains the title, release year and location of a scene.
        
#### Features

    - Downloads the entire list and save it in core data for future access.
    - Can sort the data by name and release year.
    - Locations are reverse geo mapped from strings. So, the results are best effort.
    - Callouts are shown with location name when a pin is selected.
    
#### Known Issues

    
#### Future Work

    - Build Network manager to manage other api calls as well as error handling.
    - Build DBManager to support more data access operations.
