# Normalizy

[![Build Status](https://travis-ci.org/wbotelhos/normalizy.svg)](https://travis-ci.org/wbotelhos/normalizy)
[![Gem Version](https://badge.fury.io/rb/normalizy.svg)](https://badge.fury.io/rb/normalizy)

Attribute normalizer for ActiveRecord.

## Description

If you know the obvious format of an input, why not normalize it instead of raise an validation error to your use? Make the follow email `  myemail@example.org  ` valid like `email@example.com` with no need to override acessors methods.

## install

Add the following code on your `Gemfile` and run `bundle install`:

```ruby
gem 'normalizy'
```

So generates an initializer for future custom configurations:

```ruby
rails g normalizy:install
```

It will generates a file `config/initializers/normalizy.rb` where you can configure you own normalizer and choose some defaults one.

## Usage

On your model, just add `normalizy` callback with the attribute you want to normalize and the filter to be used:

```ruby
class User < ApplicationRecord
  normalizy :name, with: :strip
end
```

Now some email like `  myemail@example.org  ` will be saved as `email@example.com`.

## Filters

We have a couple of built-in filters.

### Number

```ruby
normalizy :age, with: :number

' 32'
# 32
```

By default, `number` works with input value before [Type Cast](#type-cast)
### Strip

Options:

- `side`: `:left`, `:right` or `:both`. Default: `:both`

```ruby
normalizy :name, with: :strip
'  Washington  Botelho  '
# 'Washington  Botelho'
```

```ruby
normalizy :name, with: { strip: { side: :left } }
'  Washington  Botelho  '
# 'Washington  Botelho  '
```

```ruby
normalizy :name, with: { strip: { side: :right } }
'  Washington  Botelho  '
# '  Washington  Botelho'
```

```ruby
normalizy :name, with: { strip: { side: :both } }
'  Washington  Botelho  '
# 'Washington  Botelho'
```

As you can see, the rules can be passed as Symbol/String or as Hash if it has options.

## Multiple Filters

You can normalize with a couple of filters at once:

```ruby
normalizy :name, with: %i[squish titleize]
'  washington  botelho  '
# 'Washington Botelho'
```

## Multiple Attributes

You can normalize more than one attribute at once too, with one or muiltiple filters:

```ruby
normalizy :email, :username, with: :downcase
```

Of course you can declare muiltiples attribute and multiple filters, either.
It is possible to make sequential normalizy calls:

```ruby
normalizy :email, :username, with: :squish
normalizy :email           , with: :downcase
```

In this case, each line will be evaluated from the top to the bottom.

## Default Filters

You can configure some default filters to be runned. Edit initializer at `config/initializers/normalizy.rb`:

```ruby
Normalizy.configure do |config|
  config.default_filters = [:squish]
end
```

Now, all normalization will include squish, even when no rule is declared.

```ruby
normalizy :name
'  Washington  Botelho  '
# 'Washington Botelho'
```

If you declare some filter, the default filter `squish` will be runned together:

```ruby
normalizy :name, with: :downcase
'  washington  botelho  '
# 'Washington Botelho'
```

## Custom Filter

You can create a custom filter that implements `call` method with an `input` as argument and an optional `options`:

```ruby
module Normalizy
  module Filters
    module Blacklist
      def self.call(input)
        input.gsub 'Fuck', replacement: '***'
      end
    end
  end
end
```

```ruby
Normalizy.configure do |config|
  config.add :blacklist, Normalizy::Filters::Blacklist
end
```

Now you can use your custom filter:

```ruby
normalizy :name, with: :blacklist

'Washington Fuck Botelho'
# 'Washington *** Botelho'
```

If you want to pass options to your filter, just call it as a hash and the value will be send to the custom filter:

```ruby
module Normalizy
  module Filters
    module Blacklist
      def self.call(input, options: {})
        input.gsub 'Fuck', replacement: options[:replacement]
      end
    end
  end
end
```

```ruby
normalizy :name, with: blacklist: { replacement: '---' }

'Washington Fuck Botelho'
# 'Washington --- Botelho'
```

You can pass a block and it will be received on filter:

```ruby
module Normalizy
  module Filters
    module Blacklist
      def self.call(input, options: {})
        value = input.gsub('Fuck', 'filtered')

        value = yield(value) if block_given?

        value
      end
    end
  end
end
```

```ruby
normalizy :name, with: :blacklist, &->(value) { value.sub('filtered', '(filtered 2x)') }

'Washington Fuck Botelho'
# 'Washington (filtered 2x) Botelho'
```

## Method Filters

If a built-in filter is not found, Normalizy will try to find a method in the current class.

```ruby
normalizy :birthday, with: :parse_date

def parse_date(input)
  Time.zone.parse(input).strftime '%Y/%m/%d'
end

'1984-10-23'
# '1984/10/23'
```

If you gives an option, it will be passed to the function:

```ruby
normalizy :birthday, with: { parse_date: { format: '%Y/%m/%d' }

def parse_date(input, options = {})
  Time.zone.parse(input).strftime options[:format]
end

'1984-10-23'
# '1984/10/23'
```

Block methods works here either.

## Native Filter

After the missing built-in and class method, the fallback will be the value of native methods.

```ruby
normalizy :name, with: :reverse

'Washington Botelho'
# "ohletoB notgnihsaW"
```

## Inline Filter

Maybe you want to declare an inline filter, in this case, just use a Lambda or Proc:

```ruby
normalizy :age, with: ->(input) { input.abs }

-32
# 32
```

You can use it on filters declaration too:

```ruby
Normalizy.configure do |config|
  config.add :age, ->(input) { input.abs }
end
```

## Type Cast

An input field with `$ 42.00` dollars when sent to model with a field with `integer` type,
will be converted to `0`, since the type does not match. But you want to use the value before Rails cast the type.

To receive the value before type cast, just pass a `raw` options as `true`:

```ruby
normalizy :amount, with: :number, raw: true

'$ 42.00'
# 4200
```

To avoid repeat the `raw: true` when you have multiple uses, you can register a filter with this options:

```ruby
Normalizy.configure do |config|
  config.add :money, ->(input) { input.gsub(/\D/, '') }, raw: true
end
```

## Alias

Sometimes you want to give a better name to your filter, just to keep the things semantic.
Duplicates the code, as you know, it is not a good idea, so, create an alias:

```ruby
Normalizy.configure do |config|
  config.alias :money, :number
end
```

Now, `money` will delegate to `number` filter.
Since we already know the need of `raw` options, we can declare it here:

```ruby
Normalizy.configure do |config|
  config.alias :money, :number, raw: true
end
```

But `number` filter already works with `raw: true`, don't need to tell it again.
At our previously example, about `amount`, was refactored to:

```ruby
normalizy :amount, with: :money

'$ 42.00'
# 4200
```

If you need to alias multiple filters, just provide an array of them:

```ruby
Normalizy.configure do |config|
  config.alias :username, %i[squish downcase]
end
```

## RSpec

If you use [RSpec](http://rspec.info), we did built-in matchers for you.
Add the following code to your `rails_helper.rb`

```ruby
RSpec.configure do |config|
 config.include Normalizy::RSpec
end
```

And now you can use some of the matchers:

##### Result Matcher

```ruby
it { is_expected.to normalizy(:email).from(' Email@gmail.com  ').to 'email@gmail.com' }
```

##### Filter Matcher

```ruby
it { is_expected.to normalizy(:email).with :downcase }
```


## Love it!

Via [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=X8HEP2878NDEG&item_name=normalizy) or [Gratipay](https://gratipay.com/~wbotelhos). Thanks! (:
