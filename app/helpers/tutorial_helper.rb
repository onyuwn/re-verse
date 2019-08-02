module TutorialHelper
  def get_dummy_track(playlist_name)
    if playlist_name.eql? 'Die Lit but in order of best song to worst'
      return {
        :playlist_name => playlist_name,
        :title => "Foreign",
        :memory => "This song slaps uwu",
        :imageurl => "https://drive.google.com/open?id=1uj1Q_LkPQ17pl00EQhRosE5Ir_Ehiqbb",
        :memory_date => Date.new(2018, 4, 22),
        :username => "jakeherman-3tutorial",
        :timeline_id => 1
      }
    elsif playlist_name.eql? 'shirt off'
      return {
        :playlist_name => playlist_name,
        :title => "Walking The Cow",
        :memory => "uhhHh this song was in a skate vide o .. :)",
        :imageurl => "https://drive.google.com/open?id=1xNVScdiJK5O1MNgA7hVWrkE_-NNPDVh6",
        :memory_date => Date.new(2019, 12, 7),
        :username => "jakeherman-3tutorial",
        :timeline_id => 1
      }
    elsif playlist_name.eql? 'Louis V Crotch Rocket'
      return {
        :playlist_name => playlist_name,
        :title => "Why @",
        :memory => "wyatt <3",
        :imageurl => "https://drive.google.com/open?id=1JZ5tGh_MrAoMBEgjus2engulFRVahAGz",
        :memory_date => Date.new(2019, 1, 23),
        :username => "jakeherman-3tutorial",
        :timeline_id => 1
      }
    elsif playlist_name.eql? 'Promo Video'
      return {
        :playlist_name => playlist_name,
        :title => "Vomit",
        :memory => "angry song :(/jake's b day :)",
        :imageurl => "https://drive.google.com/open?id=1y3RnzskNbgbG3HEysKfuFdZEZyT_-U1x",
        :memory_date => Date.new(2019, 2, 17),
        :username => "jakeherman-3tutorial",
        :timeline_id => 1
      }
    end
  end

  def get_dummy_moment
    return {
      :name => 'tutorial',
      :description => "this is for tha tutorial",
      :start_date => Date.new(2018, 4, 19),
      :end_date => Date.new(2018, 4, 30),
      :user => "jakeherman-3tutorial",
      :timeline_id => 1
    }
  end

end
