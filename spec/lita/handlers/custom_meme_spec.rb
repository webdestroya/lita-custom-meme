require "spec_helper"

describe Lita::Handlers::CustomMeme, lita_handler: true do
  let(:payload) { double("payload") }
  before do
    Lita.config.handlers.custom_meme.memes = {
      'something' => 'blah',
      'rarara' => "nathan"
    }
    described_class.routes.clear
    subject.define_routes(payload)
  end

  it { routes("blah blah (something) blah").to(:meme_image) }

  describe "#meme_image" do
    it "responds with single image" do
      send_message("blah blah (rarara)")
      expect(replies.last).to eq("nathan")
    end

    it "responds with multiple images" do
      send_message("blah blah (rarara) and (something)")
      expect(replies.size).to eq(2)
      expect(replies).to include("nathan")
      expect(replies).to include("blah")
    end

    it "does not respond when no meme" do
      send_message("some random text")
      expect(replies.size).to eq(0)
    end

  end

end
