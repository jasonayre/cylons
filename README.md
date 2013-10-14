# Cylons

Collectively intelligent remote models which behave very much like models they are claiming to be. (Zero configuration SOA Framework).

Cylons lets your models in one Rails app, act very much like your ActiveRecord models in another Rails app, providing a base for a SOA infrastructure. I hope to be able to make it applicable to more than just AR models as well, however, I also hope to make it past cool proof of concept stage that works, but isn't exactly suitable for a production system, WHICH IS THE STATE IT IS CURRENTLY IN. You've been warned.

### Quick Explanation


### Depends heavily on:
DCell
Zookeeper (for now, only even though )

### Heavily inspired by
This concept - http://www.youtube.com/watch?v=Hu-jvAWTZ9o&feature=autoplay&list=PLF88804CB7380F32C&playnext=1#t=4m59s
ActiveRemote - https://github.com/liveh2o/active_remote
DCell - https://github.com/celluloid/dcell

### Alternatives
Ill list more later, because I've literally tried at least the 90% majority of the ruby soa "solutions", but if you are looking for an "enterprise" level SOA framework, I'd recommend:

ActiveRemote - https://github.com/liveh2o/active_remote
Protobuf - https://github.com/localshred/protobuf

Add those two together == winning.

### Reasons for building
Originally it started as a way to communicate between my raspberry pis, because http is so last summer. Soon I found myself wanting a database connection. So I ended up making it more active_record like. Those aren't reasons but brain tired done typing yep.


### Quick start


### How it works?

### Install ZK, Clone and run the examples

```
git clone https://github.com/jasonayre/cylons_demo

```

open 4 new terminal windows/tabs

*Prepare the inventory management service, inventory*

```
cd inventory
SKIP_CYLONS=true bundle exec rake db:create && rake db:migrate && rake db:seed
```

*Prepare the user credentials service, identify*
```
cd identify
SKIP_CYLONS=true bundle exec rake db:create && rake db:migrate && rake db:seed
```

*Prepare the categorization service, taxon*
```
cd taxon
SKIP_CYLONS=true bundle exec rake db:create && rake db:migrate && rake db:seed
```
*Start Zookeeper, and start each service up with:*
```
bundle exec cylons start
```

*Load that sample data, note the admin app has no database at all, only remote models*
```
cd admin
bx rake db:seed
```

Note: there will be quite a few N+1 queries happening, intentionally. This is to demonstrate communication between the services, and speed. Each record that is created will make a call to Inventory, to check if that record already exists. If not, it will build the record by doing a Category.first_or_create (Taxon Service), to get the category_id, then it will make 3 additional calls to the Inventory service, 1 for manufacturer, 1 for department, and then finally one to actually create the Product.


## Installation

Add this line to your application's Gemfile:

    gem 'cylons'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cylons

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
