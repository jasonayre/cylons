# Cylons

Collectively intelligent remote models which behave very much like models they are claiming to be. (Zero configuration SOA Framework).

Cylons lets your models in one Rails app, act very much like your ActiveRecord models in another Rails app, providing a base for a SOA infrastructure. I hope to be able to make it applicable to more than just AR models as well, however, I also hope to make it past cool proof of concept stage that works, but isn't exactly suitable for a production system, WHICH IS THE STATE IT IS CURRENTLY IN. You've been warned.

### Quick Explanation / Scenario

Youve got a product model in one app, a category model in another. A category has many remote products. Then youve got another app, with a front end, that you want to use data from both of those apps. Its as simple as:
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
* Zookeeper (for now, only even though redis may work just fine, redis nodes dont properly drop out of the cluster which is main reason zk being forced for time being. that and zk has alot of advanced features IDK if can be implemented using redis. but getting ahead of self.)

### Heavily inspired by
* This concept - http://www.youtube.com/watch?v=Hu-jvAWTZ9o&feature=autoplay&list=PLF88804CB7380F32C&playnext=1#t=4m59s
* ActiveRemote - https://github.com/liveh2o/active_remote
* DCell - https://github.com/celluloid/dcell

### Alternatives
Ill list more later, because I've literally tried at least the 90% majority of the ruby soa "solutions", but if you are looking for an "enterprise" level SOA framework, I'd recommend:

* ActiveRemote - https://github.com/liveh2o/active_remote
* Protobuf - https://github.com/localshred/protobuf

Add those two together == winning.

### Reasons for building / Goals
Originally it started as a way to communicate between my raspberry pis, because http is so last summer. Soon after getting a pi to communicate with my computer, I found myself wanting a database connection. So I ended up making it more active_record like. I then built it into its present state with a few goals.

1. Super simple but robust, zero config rpc solution. When Im hacking on rails apps at home, I dont want the overhead of having to deal with a DDL. To do that, I wanted to make it as dynamic as possible
2. Other than ActiveRemote and Protobuf, Ive seen nothing like this as far as cohesiveness between apps goes. I mean, if your services are generally returning data from a database, do you generally want to have a bunch of custom services scattered all over the place doing generally the same thing? Rhetorical question, the answer is no, you do not. Ernie/Thrift/ whatever other service layers solution may exist, but I havent seen other libs that wrap up the really painful and boring parts for you.
3. Reusability -- Ok this one is a stretch, but my ideal vision of the future looks something like this. *skip ahead to dodge a rant*

``` ruby
EveryWordpressGarbageSpaghettiCodeNoTalentAssClownWebsiteOnTheInternet.all.map(&:destroy)
```

**I really hate wordpress**. With passion. Why? Because its not just the spaghetti code, if you can even call it code, core that it is built upon, its the fact that people build these crappy spaghetti code plugins, of which if you tried to take a single line of the code out of its original habitat it would explode into a million pieces, because the core of wordpress is so horrible that it forces these bad patterns on people. How wordpress got as big as it did boggles my mind. **End rant**.

Ok so its not just wordpress, its alot of open source solutions. My point is this:

So very few if any open source platforms, or commercial buy the code platforms, be it ecommerce, or blogging, or whatever, have any sort of reusability. So I thought, what would be cool, is if rather than these huge behemoths of spaghetti crap existed, what if these super small cohesive sets of services existed. The smaller services could serve as a base for building larger, and actually scaleable, customizable, platforms.

The future of computing is virtual machines, which will enable IMO, smaller cohesive services to really shine once you can partition OS's within OS's within OS's... Or however that pans out. So my point is, it would be cool to see people building and sharing reusable, small cohesive services that can be combined and mix and matched into a larger platform, so we're not always reinventing the wheel on new projects. -- *ONCE AGAIN PROBABLY A STRETCH BUT HEY A GEEK CAN DREAM*

4. Extendability - I want to eventually get it to a point where its simply a base framework for defining reusable objects over your network. For instance, right now everything is based around the remote, or agent as im now calling a local remote, mapping back to a service, which is proxying calls to the actual database model. So Id like for it to eventually have an extendable enough base, something like:
``` ruby
Cylons::ActiveRecord::Agent
Cylons::ActiveRecord::Service
Cylons::ActiveRecord::Remote
```
Where, if you wanted a new type of remote mode, lets say a sidekiq worker, there would be an extension for that. So that would look like
``` ruby
Cylons::Sidekiq::Agent
Cylons::Sidekiq::Service
Cylons::Sidekiq::Remote
```
So you can share sidekiq workers, or any type of class that you are defining in more than one app, between apps. I think thats the direction Im going to head in the future. Feedback is more than welcome and encouraged BTW.

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
bundle exec rake db:create && rake db:migrate && rake db:seed
```

*Prepare the user credentials service, identify*
```
cd identify
bundle exec rake db:create && rake db:migrate && rake db:seed
```

*Prepare the categorization service, taxon*
```
cd taxon
bundle exec rake db:create && rake db:migrate && rake db:seed
```
*Start Zookeeper, and start each service up with:*
```
bundle exec cylons start
```

*Load that sample data, note the admin app has no database at all, only remote models*
```
cd admin
bundle exec rake db:seed
RPC=true bundle exec rails s
```

Visit your localhost:3000 and your rails app should be loading from the services, winning.

*NOTE: You just need to pass a flag RPC=true to force connection when running rails c or rails s - RPC env var just needs to exist and railtie will fire.

*You may have also noticed a new repo example called static_admin...*

### Agent Modes

Originally I wrote this library as a proof of conecpt of the simplest, most cohesive/dynamic/crazy/probably a bad idea because its so dynamic, SOA solution out there. Ive come to several conclusions regarding the reality of my ideas here, one of them being, I think you need to control on the individual applications side, what remote models you want present in the consumer app. So, being that the dynamic mode is still pretty damn cool, albeit, not incredibly safe in practice, Im leaving it in for now, however, you can change the agent mode with a simple switch.

```
// default agent mode is now static, 

config.agent_mode = :static

//or
config.agent_mode = :dynamic
```

Static mode will only define a local remote (or agent as im now calling them), if the matching service class exists in the remote registry. I.E.

``` ruby
class Product < Cylons::Agent
  
end
```

Will find the ProductService if it exists in the registry, and will store the connection between this class and the remote service and forward any calls to it, via the default methods on the agent class. This should also clear up most of the smoke and mirror action going on all over. It also allows you to define or override methods included on the remote model.

---

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
