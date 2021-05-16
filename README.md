Movie Booking App
============

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

### Movies APIs
```
# GET /api/v1/movies
# GET /api/v1/movies/:id
# POST /api/v1/movies
# PUT /api/v1/movies/:id
# DELETE /api/v1/movies/:id
```

### Shows APIs
```
# GET /api/v1/shows
# GET /api/v1/shows/:id
```

### Booking APIs
```
# GET /api/v1/bookings
# POST /api/v1/bookings
```
