# lita-custom-meme

This plugin responds with images for a set of user defined memes contained within parenthesis

## Installation

Add lita-custom-meme to your Lita instance's Gemfile:

``` ruby
gem "lita-custom-meme"
```

## Configuration


``` ruby
Lita.configure do |config|
  config.handlers.custom_meme.memes = [
    'something' => "http://image"
  ]
end
```

## Usage

* `blah blah (something)`
* `http://image`

## License

[MIT](http://opensource.org/licenses/MIT)