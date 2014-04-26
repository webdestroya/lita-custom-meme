# lita-custom-meme

[![Gem](http://img.shields.io/gem/v/lita-custom-meme.svg)](http://rubygems.org/gems/lita-custom-meme)
[![Build Status](https://travis-ci.org/webdestroya/lita-custom-meme.svg)](https://travis-ci.org/webdestroya/lita-custom-meme)
[![Coverage Status](http://img.shields.io/coveralls/webdestroya/lita-custom-meme.svg)](https://coveralls.io/r/webdestroya/lita-custom-meme)

**lita-custom-meme** is a handler for [Lita](http://lita.io/) that responds with images for a user defined set of "memes".

## Installation

Add lita-custom-meme to your Lita instance's Gemfile:

``` ruby
gem "lita-custom-meme"
```

## Configuration


``` ruby
Lita.configure do |config|
  # Set to true if you wish to restrict the custom memes
  # to only be given when a direct command is given to Lita
  config.handlers.custom_meme.command_only = false
end
```

## Usage

Any meme found in general room chat wrapped in parenthesis will cause Lita to respond with the URL to the corresponding image.

```text
You: blah blah (something)
Lita: http://image
```

*Note:* If you do not wish to have this functionality, then you can set the `command_only` configuration option to `true`.

### Command Usage

To view the image associated with a specific meme:

```text
Lita: meme show NAME
> http://image/xxxxx.jpg
```

To get a list of all available memes:

```text
Lita: meme list
> Available memes: troll, rage, tableflip
```

## Admin Commands

To add or update a meme:

```text
Lita: meme add NAME IMAGE
```

To delete a meme from the list:

```text
Lita: meme delete NAME
```

*Note:* The above admin commands require that the user be a member of the `:custom_meme_admins` authorization group.


## License

[MIT](http://opensource.org/licenses/MIT)
