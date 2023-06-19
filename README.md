# Animal Service

This application collects pet sitting service booking requests. There is a simple form to fill out,
a simple show page, and a page that lists all submitted bookings.

## Instructions

### Prerequisites

#### Clone the repository

If you want to use ssh and have not already enabled it, follow these
[instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh).

Then open a terminal, navigate to the directory of your choice, and type:

```bash
git clone git@github.com:vancourtj/animal_service.git
```

#### rbenv

Make sure you have rbenv installed. This project used 1.1.1.

Type in the same terminal:

```bash
rbenv -v
```

If you do not have rbenv installed, follow these [instructions](https://github.com/rbenv/rbenv#installation).

#### Ruby

This project used Ruby [3.1.4](https://www.ruby-lang.org/en/news/2023/03/30/ruby-3-1-4-released/).

Check your Ruby installation:

```bash
ruby -v
```

If you do not have ruby installed or the correct version, type:

```bash
rbenv install 3.1.4
rbenv local 3.1.4
```

#### Bundler

Make sure you have bundler installed. This project used 2.3.26.

Type:

```bash
bundler -v
```

If you do not have bundler installed, use this command:

```bash
gem install bundler
```

Install the gems for this project:

```bash
bundle install
```

#### npm

Make sure you have npm installed. This project used 8.19.2.

Type:

```bash
npm -v
```

If you do not have npm installed, follow these [instructions](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm).

#### yarn

Make sure you have yarn installed. This project used 1.22.19.

Type:

```bash
yarn -v
```

If you do not have yarn installed, use this command:

```bash
npm install --global yarn
```

Then run:

```bash
yarn install
```

#### PostgreSQL

Make sure you have PostgreSQL installed. This project used 12.15 on Ubuntu.

Type in the same terminal:

```bash
psql --version
```

If you do not have PostgreSQL installed, follow these [instructions](https://www.postgresql.org/download/).

### Running the Application

#### Setting the database environment variables

Depending on your local PostgreSQL setup, you may need a username and password to connect to the database.

Those can be set in the `.env` file with `POSTGRES_USERNAME` and `POSTGRES_PASSWORD`. If you do not need them set,
you can go to `config/database.yml` and remove the username and password configuration.

#### Setting up the database encryption

You need to be able to decrypt `config/credentials.yml.enc`. Rails will use the master key in `config/master.key`.

This repository already has a credentials file, so you'll need the correct master key to use it unless you would
like to remake the credentials file.

You can do that by:

Running the following to generate keys for encryption:

```bash
bin/rails db:encryption:init
```

Those keys need placed in `config/credentials.yml.enc`.

Running the following will create a credentials file if one does not exist.
It will also create config/master.key if no master key is defined.

```bash
./bin/rails credentials:edit
```

Read more from the official docs [here](https://guides.rubyonrails.org/active_record_encryption.html)
and [here](https://guides.rubyonrails.org/security.html#custom-credentials).

Note: you may be prompted to run the command as: `EDITOR="code --wait" bin/rails credentials:edit` instead.

#### Setting up the database

```bash
rails db:create
rails db:migrate
```

#### Running the server

```bash
./bin/dev
```

### Running the test suite

```bash
bundle exec rspec
```

Note: you'll need to have the assets compiled for the full suite to pass

```bash
bundle exec rails assets:precompile
```

## Navigating the site

- localhost:3000 is the home page
  - you can click "Home" in the navigation bar at the top
- localhost:3000/bookings is the list of existing bookings
  - you can click "Bookings" in the navigation bar at the top
- localhost:3000/bookings/new is the submission form
  - you can click "New Booking" in the navigation bar at the top
- localhost:3000/bookings/\<uuid> is a single booking's show page
  - you can click a booking's First Name on `/bookings` to get here

## Assumptions

### Booking Model

- `service_length_hours` (Hours Requested) must be an integer
  - it would be reasonable to allow for fractional hours
- `service_date` (Date of Service) there is no date validation beyond presence
  - there are probably additional requirements here in a real app like:
    - not scheduling in the past
    - only scheduling X days in the future

### Booking - Pricing Relationship

- The relationship in the app was made very simple because there are no interactions beyond read once
  it is calculated and saved on the `Booking` object.
- Price only gets set to a non-zero amount if the `PricingService` is able to calculate a price
- A `before_save` callback was used. While there is only one time the `Booking` object gets saved currently which
  effectively makes it a `before_create`, it isn't unreasonable to think price should be recalculated every time the
  object changes.
- A real app would require a more robust representation of pricing. For example:
  - An `ActiveRecord` model to represent additional charge rates for each type of service offered (fee structure)
    - additional internal tooling to allow for devless pricing updates
    - end and start dates for each fee structure to ensure historically accurate pricing and auditing capabilities
  - An `ActiveRecord` model to represent a service quote
    - `has_one` fee structure and stores the price and rating attributes
  - `Booking` would have a `has_one` relationship with quotes - the quote that gets "bound"

### Bookings List Page

The prompt referred to this as an admin page. I deemed creating users and setting up devise and roles to be out of scope,
so it is accessible by anyone unlike typical admin pages.
