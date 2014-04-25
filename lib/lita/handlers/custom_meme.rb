require 'lita'


module Lita
  module Handlers
    class CustomMeme < Handler
      on :loaded, :define_routes

      route %r{^meme (.+)$}i, :meme_image, command: true, help: {'meme NAME' => "Displays the image for the specified meme."}

      def self.default_config(config)
        config.memes = {}
        config.command_only = false
      end

      def define_routes(payload)
        return if Lita.config.handlers.custom_meme.memes.empty?

        memelist = Lita.config.handlers.custom_meme.memes.keys.join("|")

        # This picks up the images in chat
        unless Lita.config.handlers.custom_meme.command_only
          self.class.route(
            %r{\((#{memelist})\)}i,
            :meme_image
          )
        end
      end

      def meme_image(response)
        output = []

        response.matches.each do |match|
          term = match[0].downcase

          if Lita.config.handlers.custom_meme.memes[term]
            output << Lita.config.handlers.custom_meme.memes[term]
          end

        end

        if output.size > 0
          response.reply *output
        end
      end

    end

    Lita.register_handler(CustomMeme)
  end
end
