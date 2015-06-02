# CustomFields

A simple way of adding those "one-off" attributes/properties to any ActiveRecord model.  The custom fields are stored in a separate table (`custom_field_store`) and serialized to a
single column (`custom_fields`) so only one row needs to be loaded from the database.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'custom_fields'
```

And then execute:

    $ bundle

Finally, run the generator (which will create a new migration):

    $ bin/rails generate custom_fields:install
    $ rake db:migrate

## Usage

In your models, simply include the module and then define the custom fields you want:

```ruby
class User < ActiveRecord::Base
  include CustomFields

  custom_field :hometown
  custom_field :gender
  
  # If you are using Rails < 4 or `protected_attributes` gem, you may need to 
  # make your custom fields accessible:
  # attr_accessible :hometown, :gender
end
```

When you include `CustomFields`, an association named `custom_field_store` (`owner` from the perspective of `CustomFieldStore` model) is added with `has_one` relationship .  Then,
each call to `custom_field` defines getter and setter methods which communication with the `custom_field_store`.

Also, you do not need to worry about manually instantiating the `custom_field_store`, as one will be built automatically if needed.

You can get a list of all defined custom fields with `ClassName.custom_fields` e.g. `User.custom_fields`.

## Ideas

Possible ideas for future:

- provide default values for custom fields?

---

##### Contributing

1. Fork it ( https://github.com/scharfie/custom_fields/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
