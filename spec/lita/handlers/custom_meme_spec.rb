require "spec_helper"

describe Lita::Handlers::CustomMeme, lita_handler: true do
  before do
    robot.auth.add_user_to_group!(user, :custom_meme_admins)
  end

  it { is_expected.to route_command("meme show something").to(:meme_image) }

  it { is_expected.to route_command("meme list").to(:meme_list) }

  it do
    is_expected.to route_command(
      "meme add name http://image.com/img.jpg"
    ).to(:meme_add).with_authorization_for(:custom_meme_admins)
  end
  it do
    is_expected.to route_command(
      "meme delete name"
    ).to(:meme_delete).with_authorization_for(:custom_meme_admins)
  end

  it 'sets and shows memes' do
    send_command("meme add testing http://blah.com")
    expect(replies.last).to eq("Meme 'testing' has been added.")

    send_command("meme show testing")
    expect(replies.last).to eq("http://blah.com")
  end

  describe '#meme_delete' do
    it 'indicates meme not found' do
      send_command("meme delete deltest")
      expect(replies.last).to eq("Meme 'deltest' was not found.")
    end

    it 'deletes meme' do
      send_command("meme add deltest http://blah.com")
      send_command("meme delete deltest")
      send_command("meme show deltest")
      expect(replies.last).to eq("Meme not found")
    end
  end

  describe '#meme_list' do
    it 'indicates there are no memes' do
      send_command("meme list")
      expect(replies.last).to eq("No memes have been added")
    end

    it 'lists available memes' do
      send_command("meme add test1 http://blah")
      send_command("meme add test2 http://blah")

      send_command("meme list")
      expect(replies.last).to eq("Available memes: test1, test2")
    end
  end

  describe "#meme_image" do

    it 'responds to show command when not found' do
      send_command("meme show fake")
      expect(replies.last).to eq("Meme not found")
    end

    it 'does not respond to show in general chat' do
      send_message("(fake)")
      expect(replies.last).to be_nil
    end

    it "responds with multiple images" do
      send_command("meme add rarara http://nathan.com")
      send_command("meme add rage http://mitch.com")
      replies.clear
      send_message("blah blah (rarara) and (rage)")
      expect(replies.size).to eq(2)
      expect(replies).to include("http://nathan.com")
      expect(replies).to include("http://mitch.com")
    end

  end

end
