# SimpleBank

*Do you ever feel like breaking down?*
*Do you ever feel out of money?*
*Like somehow you're just bankrupt*
*And no one wants to lend you*
*(...)*
*Welcome to my account!*

![Alt Text](https://media.giphy.com/media/mwEM69M5NInxm/giphy.gif)

**SimpleBank** is an [API-only Rails application](https://guides.rubyonrails.org/api_app.html) for bank operations (at the moment, we have money transfer and account info checking).

## Getting started

### Prerequisites
This projects needs [Ruby](https://www.ruby-lang.org/en/downloads/) 2.5.3 and [PostgreSQL](https://www.postgresql.org) 10.3+.

### Setup
**SimpleBank** setup is pretty straightforward, you'll see.
Clone the repository and go to the project folder
```
$ git clone https://github.com/karydja/SimpleBank.git
$ cd SimpleBank
```
Now the magic happens! Just run
```
$ ./bin/setup
```
and follow the instructions accordingly, and then you'll be ready to go.

## Running the application
Make sure you have PostgreSQL running and the setup step was completed.  After that, you just need to run
```
$ rails server
```
and the the application will be available in `localhost:3000`.

## Documentation
Once you access `localhost:3000` you'll be redirected to a Swagger UI loaded with the API documentation.

## Running the tests
Here you also need PostgreSQL and a successful setup. The project uses [RSpec](https://github.com/rspec/rspec-rails) to build its specs, so you can run the test suite using
```
$ bundle exec rspec
```

## Contributing
Feel free to open Pull Requests and contact me via issue or email :)

## License
This project is under the MIT License - see the LICENSE.md file for more details.
