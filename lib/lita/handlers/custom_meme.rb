require 'lita'


module Lita
  module Handlers
    class CustomMeme < Handler
      REDIS_KEY = "cmeme"

      # The global handler
      route %r{\(([\w\._]+)\)}i, :meme_image, command: false

      route %r{^meme show ([\w\._]+)$}i, :meme_image,
        command: true,
        help: {'meme show NAME' => "Displays the image for the specified meme."}

      route %r{^meme list$}i, :meme_list,
        command: true,
        help: {'meme list' => "Displays a list of available memes."}

      # Admin commands
      route %r{^meme add ([\w\._]+) (http.+)$}i, :meme_add,
        command: true,
        restrict_to: :custom_meme_admins,
        help: {'meme add NAME IMAGE' => "Adds a meme to the list"}

      route %r{^meme delete ([\w\._]+)$}i, :meme_delete,
        command: true,
        restrict_to: :custom_meme_admins,
        help: {'meme delete NAME' => "Deletes a meme from the list"}


      def self.default_config(config)
        config.command_only = false
      end

      def meme_image(response)
        # If command only is desired, then bail if general message
        return if config.command_only && !response.message.command?

        output = []

        response.matches.each do |match|
          term = normalize_key(match[0])

          image = redis.hget(REDIS_KEY, term)

          if image
            output << image
          end

        end

        if output.size > 0
          response.reply *output
        elsif response.message.command?
          response.reply "Meme not found"
        end
      end

      def meme_add(response)
        name, image = response.matches.first

        name = normalize_key(name)
        redis.hset(REDIS_KEY, name, image)

        response.reply "Meme '#{name}' has been added."
      end

      def meme_delete(response)
        key = normalize_key(response.matches.first.first)

        if redis.hdel(REDIS_KEY, key) >= 1
          response.reply "Deleted meme '#{key}'."
        else
          response.reply "Meme '#{key}' was not found."
        end
      end

      def meme_list(response)
        keys = redis.hkeys(REDIS_KEY)

        if keys.empty?
          response.reply "No memes have been added"
        else
          response.reply "Available memes: #{keys.sort.join(', ')}"
        end
      end

      private

      def config
        Lita.config.handlers.custom_meme
      end

      def normalize_key(key)
        key.to_s.downcase.strip
      end

    end

    Lita.register_handler(CustomMeme)
  end
end
