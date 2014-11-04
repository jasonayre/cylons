# Cylons

Collectively intelligent remote models which behave very much like models they are claiming to be. (Or the first zero configuration RPC/SOA framework).

Cylons lets your models in one Rails app, act very much like your ActiveRecord models in another Rails app, providing a foundation for building an SOA infrastructure. Not exactly production ready, but getting there.

### Quick Explanation / Scenario

Youve got a product model in one app, a category model in another. A category has many remote products. Then youve got another app, with a front end, that you want to use data from in both of those apps. Its as simple as:
(note you just need to include gem and initializers additionally)

**App 1**
*Product Model:*
``` ruby
class Product < ActiveRecord::Base
  include ::Cylons::Remote
  remote_belongs_to :category
end
```
*Category Agent:*
``` ruby
class Category < Cylons::Agent

end
```

**App 2**
*Category Model:*
``` ruby
class Category < ActiveRecord::Base
  include ::Cylons::Remote
  remote_has_many :products
end
```
*Product Agent:*
``` ruby
class Product < Cylons::Agent

end
```

That minimal amount of code will enable you to do things from app 3 such as:

*App 3*
``` ruby
category = Category.first
category.products

Product.create
Category.create
```

So on a so forth. Extensive examples provided down further.

### Depends heavily on:
* DCell
* Zookeeper

### Heavily inspired by
* This concept - http://www.youtube.com/watch?v=Hu-jvAWTZ9o&feature=autoplay&list=PLF88804CB7380F32C&playnext=1#t=4m59s
* ActiveRemote - https://github.com/liveh2o/active_remote
* DCell - https://github.com/celluloid/dcell

### Alternatives
Right now, the gem is still in sketchy mode. If you are looking for a heavy duty rpc ruby framework, I'd recommend:

* ActiveRemote - https://github.com/liveh2o/active_remote
* Protobuf - https://github.com/localshred/protobuf


### Quick start

### How it works?

### Install ZK, Clone and run the examples

```
git clone https://github.com/jasonayre/cylons_demo
```

open 2 new terminal windows/tabs

*Prepare & start the fake user credentials service, identify*
```
cd identify
bundle exec rake db:create && rake db:migrate && rake db:seed
bundle exec cylons start
```

*cd into admin service in other window, launch console and run some commands*

``` ruby
cd static_admin
bundle
RPC=1 bundle exec rails c
```

*Then run some rails console commands on the remote cylons service*
``` ruby
User.all
User.first
u = User.create(:name => "asdasd", :email => "bill@initech.com")
u.name = "blumbergh"
u.save

u = User.create(:name => "asdasd", :email => "asdasd@asdasd.com", :password => "asdasd")
{:error=>"unknown attribute: password"}

u = User.create(:email => "asdasd@asdasd")
puts u.errors
#<ActiveModel::Errors:0x343a4ddd @base=#<User created_at: nil, email: "asdasd@asdasd", id: nil, name: nil, updated_at: nil>, @messages={:name=>["can't be blank", "can't be blank"]}

users = User.search(:name => "blumbergh")
[#<User created_at: "2014-11-04 22:23:10.697000", email: "bill@initech.com", id: 2013, name: "blumbergh", updated_at: "2014-11-04 22:23:25.993000">]

#(when ::Cylons::RemotePagination included into remote model, results will be a will paginate collection)
users.current_page

#dont know why this isnt returning integer thats a bug..
users.current_page
 => page 1
```

*Start Zookeeper, and start each service up with:*
```
bundle exec cylons start
```

*NOTE: You just need to pass a flag RPC=1 to force connection when running rails c or rails s -- RPC env var just needs to exist to force connection

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
