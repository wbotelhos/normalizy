# Normalizy

[![Build Status](https://travis-ci.org/wbotelhos/normalizy.svg)](https://travis-ci.org/wbotelhos/normalizy)
[![Gem Version](https://badge.fury.io/rb/normalizy.svg)](https://badge.fury.io/rb/normalizy)
[![Patreon](https://img.shields.io/badge/donate-%3C3-brightgreen.svg)](https://www.patreon.com/wbotelhos)

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
  normalizy :name, with: :downcase
end
```

Now some email like `MyEmail@Example.com` will be saved as `myemail@example.com`.

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
normalizy :birthday, with: { date: { format: '%y/%m/%d' } }

'84/10/23'
# Tue, 23 Oct 1984 00:00:00 UTC +00:00
```

#### time zone

To convert the date on your time zone, just provide the `time_zone` option:

```ruby
normalizy :birthday, with: { date: { time_zone: Time.zone } }

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
normalizy :birthday, with: { date: { adjust: :begin } }

Tue, 23 Oct 1984 11:30:00 EDT -04:00
# Tue, 23 Oct 1984 00:00:00 EDT -04:00
```

Or to the end of the day:

```ruby
normalizy :birthday, with: { date: { adjust: :end } }

Tue, 23 Oct 1984 00:00:00 EDT -04:00
# Tue, 23 Oct 1984 11:59:59 EDT -04:00
```

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
normalizy :amount, with: { money: { separator: ',' } }

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
normalizy :amount, with: { money: { type: :cents } }

'$ 42.00'
# '4200'
```

#### precision

As you could see on the last example, when using `type: :cents` is important the number of decimal digits.
So, you can configure it to avoid the following error:

```ruby
normalizy :amount, with: { money: { type: :cents } }

'$ 42.0'
# 420
```

When you parse it back, the value need to be divided by `100` to be presented, but it will result in a value you do not want: `4.2` instead of the original `42.0`. Just provide a `precision`:

```ruby
normalizy :amount, with: { money: { precision: 2 } }

'$ 42.0'
# 42.00
```

```ruby
normalizy :amount, with: { money: { precision: 2, type: :cents } }

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
normalizy :amount, with: { money: { cast: :to_i } }

'$ 42.00'
# 4200
```

Just pay attention to avoid to use `type: :cents` together `cast` with float parses.
Since `type` runs first, you will add decimal in a number that already is represented with decimal, but as integer:

```ruby
normalizy :amount, with: { money: { cast: :to_f, type: :cents } }

'$ 42.00'
# 4200.0
```

### Number

Transform text to valid number.

```ruby
normalizy :age, with: :number

' 32x'
# '32'
```

If you want cast the value, provide `cast` option with desired cast method:

```ruby
normalizy :age, with: { number: { cast: :to_i } }

' 32x'
# 32
```

### Percent

Transform a value to a valid percent format.

```ruby
normalizy :amount, with: :percent

'42.00 %'
# '42.00'
```

#### separator

The `separator` will be keeped on value to be possible cast the right integer value.
You can change this separator:

```ruby
normalizy :amount, with: { percent: { separator: ',' } }

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
normalizy :amount, with: { percent: { type: :integer } }

'42.00 %'
# '4200'
```

#### precision

As you could see on the last example, when using `type: :integer` is important the number of decimal digits.
So, you can configure it to avoid the following error:

```ruby
normalizy :amount, with: { percent: { type: :integer } }

'42.0 %'
# 420
```

When you parse it back, the value need to be divided by `100` to be presented, but it will result in a value you do not want: `4.2` instead of the original `42.0`. Just provide a `precision`:

```ruby
normalizy :amount, with: { percent: { precision: 2 } }

'42.0 %'
# 42.00
```

```ruby
normalizy :amount, with: { percent: { precision: 2, type: :integer } }

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
normalizy :amount, with: { percent: { cast: :to_i } }

'42.00 %'
# 4200
```

Just pay attention to avoid to use `type: :integer` together `cast` with float parses.
Since `type` runs first, you will add decimal in a number that already is represented with decimal, but as integer:

```ruby
normalizy :amount, with: { percent: { cast: :to_f, type: :integer } }

'42.00 %'
# 4200.0
```

### Slug

Convert texto to slug.

```ruby
normalizy :slug, with: :slug
'Washington é Botelho'
# 'washington-e-botelho'
```

#### to

You can slug a field based on other just sending the result value.

```ruby
normalizy :title, with: { slug: { to: :slug } }

model.title = 'Washington é Botelho'

model.slug
# 'washington-e-botelho'
```

### Strip

Cleans edge spaces.

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

### Truncate

Remove excedent string part from a gived limit.

```ruby
normalizy :description, with: { truncate: { limit: 10 } }

'Once upon a time in a world far far away'
# 'Once upon '
```

## Multiple Filters

You can normalize with a couple of filters at once:

```ruby
normalizy :name, with: { %i[squish titleize] }
'  washington  botelho  '
# 'Washington Botelho'
```

## Multiple Attributes

You can normalize more than one attribute at once too, with one or multiple filters:

```ruby
normalizy :email, :username, with: :downcase
```

Of course you can declare multiple attribute and multiple filters, either.
It is possible to make sequential normalizy calls, but *take care*!
Since we use `prepend` module the last line will run first then others:

```ruby
normalizy :username, with: :downcase
normalizy :username, with: :titleize

'BoteLho'
# 'bote lho'
```

As you can see, `titleize` runs first then `downcase`.
Each line will be evaluated from the *bottom* to the *top*.
If it is hard to you accept, use [Muiltiple Filters](#multiple-filters)

## Default Filters

You can configure some default filters to be runned.
Edit initializer at `config/initializers/normalizy.rb`:

```ruby
Normalizy.configure do |config|
  config.default_filters = [:squish]
end
```

Now, all normalization will include `squish`, even when no rule is declared.

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
normalizy :name, with: { blacklist: { replacement: '---' } }

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
normalizy :name, with: { :blacklist, &->(value) { value.sub('filtered', '(filtered 2x)') } }

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

## Alias

Sometimes you want to give a better name to your filter, just to keep the things semantic.
Duplicates the code, as you know, is not a good idea, so, create an alias:

```ruby
Normalizy.configure do |config|
  config.alias :age, :number
end
```

Now, `age` will delegate to `number` filter.

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

Alias accepts options parameters too:

```ruby
Normalizy.configure do |config|
  config.alias :left_trim, trim: { side: :left }
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
