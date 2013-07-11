# Redis::Objects::RMap

[![Travis CI](https://secure.travis-ci.org/inossidabile/redis-objects-rmap.png)](https://travis-ci.org/inossidabile/redis-objects-rmap)
[![Code Climate](https://codeclimate.com/github/inossidabile/redis-objects-rmap.png)](https://codeclimate.com/github/inossidabile/redis-objects-rmap)

Adds Redis-cached hash containing correspondence between row id and selected field to ActiveRecord models.

[![endorse](http://api.coderwall.com/inossidabile/endorsecount.png)](http://coderwall.com/inossidabile)

## Installation

Add this line to your application's Gemfile:

    gem 'redis-objects-rmap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis-objects-rmap

## Usage

```ruby
class Foo < ActiveRecord::Base
  include Redis::Objects::RMap
  has_rmap :title # field to use as a title
end

Foo.create! :title => 'foo'
Foo.rmap # {1 => 'foo'} <- Does SQL request and puts to Redis
Foo.rmap # {1 => 'foo'} <- Gets from Redis without an SQL query
```

You can specify field to use as an ID source:

```ruby
class Foo < ActiveRecord::Base
  include Redis::Objects::RMap
  has_rmap :title, :my_id
end
```

Or even specify lambdas to prepare your cache:

```ruby
class Foo < ActiveRecord::Base
  include Redis::Objects::RMap
  has_rmap :title => lambda{|x| x.camelize}, :id => lambda{|x| x.to_s}
end
```

```ruby
class Foo < ActiveRecord::Base
  include Redis::Objects::RMap
  has_rmap({:title => lambda{|x| x.camelize}}, :my_id)
end
```

## License

It is free software, and may be redistributed under the terms of MIT license.