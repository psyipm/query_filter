# QueryFilter

This gem provides DSL to write custom complex filters for ActiveRecord models. It automatically parses whitelisted params and adds filters to query.

Instead of writing this:
```ruby
class Order < ActiveRecord::Base
  def self.filter(params)
    query = all
    query = query.with_state(params[:state]) if params[:state].present?
    query
  end
end
```

you can write this:
```ruby
class Order < ActiveRecord::Base
  def self.filter(params)
    OrderFilter.new(all, params).to_query
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'query_filter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install query_filter

## Usage

This gem support next types of filter params:
* scope - simple filter by column
    ```ruby
    scope :state

    def scope_state(value)
      # your code
    end
    ```
    Keyword `scope` defines type of filter, and argument `:state` is a key from params to use for filter. Can be restricted using array of allowed values

* range - between, greater than or equal, less than or equal
    For range inputs, can be used with 2 arguments or with 1, for example if both params supplied as
    ```ruby
    { price_from: 100, price_to: 200 }
    ```
    this will produce a query like
    ```sql
    orders.price BETWEEN 100 AND 200
    ```
    With one parameter `price_from` a query would look like:
    ```sql
    orders.price >= 100
    ```
    or `price_to`:
    ```sql
    orders.price <= 200
    ```

* splitter range - the same as range, but with one param
  Some JS slider libraries join ranges with splitter, this filter could be used for that.
  Sample params:
  ```ruby
  { price: '100;200' }
  ```
  query:
  ```sql
  orders.price BETWEEN 100 AND 200
  ```

* date range - the same as range, but for dates
    Sample params:
    ```ruby
    { created_at: '06/24/2017 to 06/30/2017' }
    ```
    query:
    ```sql
    orders.created_at BETWEEN '2017-06-24 04:00:00.000000' AND '2017-07-01 03:59:59.999999'
    ```

* order by
    ```ruby
      order_by :sort_column, via: :sort_mode

      def order_by_sort_column(column, direction)
        # your code
      end
    ```
    Sample params:
    ```ruby
    { sort_column: 'created_at', sort_mode: 'desc' }
    ```
    query:
    ```sql
    ORDER BY "orders"."created_at" DESC
    ```

### Sample class with usage examples

To use scope filter with Order model define your filter class as `app/filters/order_filter.rb`
```ruby
class OrderFilter < QueryFilter::Base
  # can be restricted using array of values
  scope :state, only: [:pending, :completed]
  scope :deleted, only: TRUE_ARRAY

  range :price

  splitter_range :price

  date_range :created_at

  order_by :sort_column, via: :sort_mode

  # Filter will be applied when following params present
  # { state: :pending }
  def scope_state(value)
    query.with_state(value)
  end

  def scope_deleted(_value)
    query.where(deleted: true)
  end

  # Filter will be applied when following params present
  # { price_from: 100, price_to: 200 }
  def range_price(range)
    # You should pass SQL column name to `query` method
    # this will result with following query:
    # 'orders.price BETWEEN 100 AND 200'
    query.where(range.query('orders.price'))
  end

  def splitter_range_price(values)
    # 'orders.price BETWEEN 100 AND 200'
    query.where(price: value.range)
  end

  def date_range_created_at(period)
    query.where(created_at: period.range)
  end

  def order_by_sort_column(column, direction)
    query.reorder("orders.#{column} #{direction} NULLS LAST")
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/query_filter.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
