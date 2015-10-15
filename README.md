# RadListing

### Description

RadListing is a Rails app that parses an XML feed into an SQL database and displays the results.

### Demo

Please visit the [Heroku App](http://radlisting.herokuapp.com/) for a live demo

### Setup

1. Clone the git repo into local computer

1. Run `rake db:development:refresh`

1. Run `rails s`

1. Go to `http://localhost:3000`

Note: The file that parses the XML feed is located at `lib/tasks/populate_db.rake`

### Bonuses Accomplished

* Google maps integration

* Listing index and detail pages

* Listings are sortable by id, title, and price

* Listing stats 