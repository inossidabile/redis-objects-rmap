# Redis::Objects::RMap

Adds Redis-cached hash containing correspondence between row id and selected field to ActiveRecord models.

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
Foo.rmap # {'foo' => '1'} <- Does SQL request and puts to Redis
Foo.rmap # {'foo' => '1'} <- Gets from Redis without SQL query

Foo.create! :title => 'bar'
Foo.rmap # {'foo' => '1', 'bar' => '2'} <- Does SQL request and puts to Redis
Foo.rmap # {'foo' => '1', 'bar' => '2'} <- Gets from Redis without SQL query
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request