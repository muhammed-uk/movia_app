Movie Booking App
============
This is a small movie booking application with limited set of APIs.

## Prerequisites

Working setup requires `git` and `rails` pre-installed.

## Setting up the Movie App

Clone and move into repository

`git clone https://github.com/muhammed-uk/movia_app.git movie_app`

`cd movie_app`

## Installation

from the app directory

```shell
bundle install

rake db:setup
```

## Starting the application

```shell
rails s
```
Now the application should be up and running on port 3000.
If you want to change the port please pass -p PORT_NUMBER

```shell
rails s -p 5000
```

## Running the Test

This application has automated testcases setup with `RSpec`
In order to run the testcase, Please enter

```shell
rspec
```
from app directory.

## Exposed APIs
This application exposes few set of APIs, some are available public
few are restricted to Admin only.

Admin APIs expects Basic Auth with username as the user email and password as password.
You can find admin credentials in `db/seeds.rb` file.

### Movies APIs
Note: All the listed APIs are admin restricted.
```ruby
# GET /api/v1/movies
# GET /api/v1/movies/:id
# POST /api/v1/movies
# PUT /api/v1/movies/:id
# DELETE /api/v1/movies/:id
```
#### params
```ruby
# POST /api/v1/movies
# To filter the shows, you can pass following params
params = {
  "title": "Spider Man"
}

```

### Shows APIs
```
# GET /api/v1/shows
# GET /api/v1/shows/:id
```
#### params
```ruby
# GET /api/v1/shows
# To filter the shows, you can pass following params
params = {
  date: "2021-05-16",
  timeslot: "8-11"
}

```

### Booking APIs
```
# GET /api/v1/bookings (restricted to admins only.)
# POST /api/v1/bookings
```
#### params
```ruby
# GET /api/v1/bookings
# To filter the bookings, you can pass following params
params = {
  user_id: "1",
  show_id: "1"
}

# POST /api/v1/bookings
params = {
  show_id: "1",
  seats: [
    "A-29",
    "A-30",
    "B-1"
  ]
}
```
