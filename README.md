# Normalizy

[![Build Status](https://travis-ci.org/wbotelhos/normalizy.svg)](https://travis-ci.org/wbotelhos/normalizy)
[![Gem Version](https://badge.fury.io/rb/normalizy.svg)](https://badge.fury.io/rb/normalizy)

Attribute normalizer for ActiveRecord.

## Description

If you know the obvious format of an input, why not normalize it instead of raise an validation error to your use? Make the follow email `  Email@example.com  ` valid like `email@example.com` with no need to override acessors methods.

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

Now some email like `  myemail@example.com  ` will be saved as `email@example.com`.

## Filters

We have a couple of built-in filters.

### Date

Transform a value to date format.

```ruby
normalizy :birthday, with: :date

'1984-10-23'
# Tue, 23 Oct 1984 00:00:00 UTC +00:00
```

By default, the date is treat as `%F` format and as `UTC` time.

#### format

You can change the format using the `format` options:

```ruby
normalizy :birthday, with: date: { format: '%y/%m/%d' }

'84/10/23'
# Tue, 23 Oct 1984 00:00:00 UTC +00:00
```

#### time zone

To convert the date on your time zone, just provide the `time_zone` option:

```ruby
normalizy :birthday, with: date: { time_zone: '%y/%m/%d' }

'1984-10-23'
# Tue, 23 Oct 1984 00:00:00 EDT -04:00
```

#### error message

If an invalid date is provided, Normalizy will add an error on attribute of the related object.
You can customize the error via I18n config:

```yml
en:
  normalizy:
    errors:
      date:
        user:
          birthday: '%{value} is an invalid date.'
```

If no configuration is provided, the default message will be `'%{value} is an invalid date.`.

#### adjust

If your model receive a `Time` or `DateTime`, you can provide `adjust` options to change you time to begin o the day:

```ruby
normalizy :birthday, with: date: { adjust: :begin }

Tue, 23 Oct 1984 11:30:00 EDT -04:00
# Tue, 23 Oct 1984 00:00:00 EDT -04:00
```

Or to the end of the day:

```ruby
normalizy :birthday, with: date: { adjust: :end }

Tue, 23 Oct 1984 00:00:00 EDT -04:00
# Tue, 23 Oct 1984 11:59:59 EDT -04:00
```

By default, `number` works with value before [Type Cast](#type-cast).

### Money

Transform a value to money format.

```ruby
normalizy :amount, with: :money

'$ 42.00'
# '42.00'
```

#### separator

The `separator` will be keeped on value to be possible cast the right integer value.
You can change this separator:

```ruby
normalizy :amount, with: money: { separator: ',' }

'R$ 42,00'
# '42,00'
```

If you do not want pass it as options, Normalizy will fetch your I18n config:

```yaml
en:
  currency:
    format:
      separator: '.'
```

And if it does not exists, `.` will be used as default.

#### type

You can retrieve the value in *cents* format, use the `type` options as `cents`:

```ruby
normalizy :amount, with: money: { type: :cents }

'$ 42.00'
# '4200'
```

#### precision

As you could see on the last example, when using `type: :cents` is important the number of decimal digits.
So, you can configure it to avoid the following error:

```ruby
normalizy :amount, with: money: { type: :cents }

'$ 42.0'
# 420
```

When you parse it back, the value need to be divided by `100` to be presented, but it will result in a value you do not want: `4.2` instead of the original `42.0`. Just provide a `precision`:

```ruby
normalizy :amount, with: money: { precision: 2 }

'$ 42.0'
# 42.00
```

```ruby
normalizy :amount, with: money: { precision: 2, type: :cents }

'$ 42.0'
# 4200
```

If you do not want pass it as options, Normalizy will fetch your I18n config:

```yaml
en:
  currency:
    format:
      separator: 2
```

And if it does not exists, `2` will be used as default.

#### cast

If you need get a number over a normalized string in a number style, provide `cast` option with desired cast method:

```ruby
normalizy :amount, with: money: { cast: :to_i }

'$ 42.00'
# 4200
```

Just pay attention to avoid to use `type: :cents` together `cast` with float parses.
Since `type` runs first, you will add decimal in a number that already is represented with decimal, but as integer:

```ruby
normalizy :amount, with: money: { cast: :to_f, type: :cents }

'$ 42.00'
# 4200.0
```

By default, `money` works with value before [Type Cast](#type-cast).

### Number

```ruby
normalizy :age, with: :number

' 32x'
# '32'
```

If you want cast the value, provide `cast` option with desired cast method:

```ruby
normalizy :age, with: number: { cast: :to_i }

' 32x'
# 32
```

By default, `number` works with value before [Type Cast](#type-cast).

### Percent

Transform a value to percent format.

```ruby
normalizy :amount, with: :percent

'42.00 %'
# '42.00'
```

#### separator

The `separator` will be keeped on value to be possible cast the right integer value.
You can change this separator:

```ruby
normalizy :amount, with: percent: { separator: ',' }

'42,00 %'
# '42,00'
```

If you do not want pass it as options, Normalizy will fetch your I18n config:

```yaml
en:
  percentage:
    format:
      separator: '.'
```

And if it does not exists, `.` will be used as default.

#### type

You can retrieve the value in *integer* format, use the `type` options as `integer`:

```ruby
normalizy :amount, with: percent: { type: :integer }

'42.00 %'
# '4200'
```

#### precision

As you could see on the last example, when using `type: :integer` is important the number of decimal digits.
So, you can configure it to avoid the following error:

```ruby
normalizy :amount, with: percent: { type: :integer }

'42.0 %'
# 420
```

When you parse it back, the value need to be divided by `100` to be presented, but it will result in a value you do not want: `4.2` instead of the original `42.0`. Just provide a `precision`:

```ruby
normalizy :amount, with: percent: { precision: 2 }

'42.0 %'
# 42.00
```

```ruby
normalizy :amount, with: percent: { precision: 2, type: :integer }

'42.0 %'
# 4200
```

If you do not want pass it as options, Normalizy will fetch your I18n config:

```yaml
en:
  percentage:
    format:
      separator: 2
```

And if it does not exists, `2` will be used as default.

#### cast

If you need get a number over a normalized string in a number style, provide `cast` option with desired cast method:

```ruby
normalizy :amount, with: percent: { cast: :to_i }

'42.00 %'
# 4200
```

Just pay attention to avoid to use `type: :integer` together `cast` with float parses.
Since `type` runs first, you will add decimal in a number that already is represented with decimal, but as integer:

```ruby
normalizy :amount, with: percent: { cast: :to_f, type: :integer }

'42.00 %'
# 4200.0
```

By default, `percent` works with value before [Type Cast](#type-cast).

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

#### options

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

### options value

By default, Modules and instance methods of class will receveis the following attributes on `options` argument:

- `object`: The object that Normalizy is acting;
- `attribute`: The attribute of the object that Normalizy is acting.

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
normalizy :age, with: ->(input) { input.to_i.abs }

-32
# 32
```

You can use it on filters declaration too:

```ruby
Normalizy.configure do |config|
  config.add :age, ->(input) { input.to_i.abs }
end
```

## Type Cast

An input field with `= 42` value when sent to model with a field as `integer` type,
will be converted to `0`, since the type does not match. But you want to use the value before Rails cast the type.

To receive the value before type cast, just pass a `raw` options as `true`:

```ruby
normalizy :amount, with: :number, raw: true

'= 42'
# 42
```

To avoid repeat the `raw: true` when you have multiple uses, you can register a filter:

```ruby
Normalizy.configure do |config|
  config.add :raw_number, ->(input) { input.gsub(/\D/, '') }, raw: true
end
```

And use it in short version:

```ruby
normalizy :amount, with: :raw_number

'= 42'
# 42
```

## Alias

Sometimes you want to give a better name to your filter, just to keep the things semantic.
Duplicates the code, as you know, is not a good idea, so, create an alias:

```ruby
Normalizy.configure do |config|
  config.alias :age, :number
end
```

Now, `age` will delegate to `number` filter.
Since we already know the need of `raw` options, we can declare it here:

```ruby
Normalizy.configure do |config|
  config.alias :age, :number, raw: true
end
```

And now, the aliased filter will work fine:

```ruby
normalizy :age, with: :age

'= 42'
# 42
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
it { is_expected.to normalizy(:email).from(' Email@example.com  ').to 'email@example.com' }
```

##### Filter Matcher

It will match the given filter literally:

```ruby
it { is_expected.to normalizy(:email).with :downcase }
```

```ruby
it { is_expected.to normalizy(:email).with %i[downcase squish] }
```

```ruby
it { is_expected.to normalizy(:email).with(trim: { side: :left }) }
```

## Love it!

Via [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=X8HEP2878NDEG&item_name=normalizy) or [Gratipay](https://gratipay.com/~wbotelhos). Thanks! (:
