module PlaylistsHelper

  def color_mind(tlhash)
    @month_color_scheme = {}
    #get a color scheme for each month in the tlhash..
    image = Magick::ImageList.new
    tlhash.keys.each do |k|
      pixels = [] #pixels to be dumped into colormind
      tlhash[k].each do |t|
        if t.class != RSpotify::Playlist
          urlimage = open(t[1].album.images[0]['url'])
          image.from_blob(urlimage.read)
          count = 0
          image.each_pixel do |pixel, c, r|
            begin
              pixels << [pixel.to_color[1..2].to_i(16), pixel.to_color[3..4].to_i(16), pixel.to_color[5..6].to_i(16)]
              count = count + 1
              if count > 100
                break
              end
            rescue ArgumentError => e
              Rails.logger.info "oopsies!"
              break
            end
          end
        end
      end

      data = {
        :model => "default",
        :input => pixels
      }

      url = URI.parse('http://colormind.io/api/')
      req = Net::HTTP::Get.new(url.to_s, {'Content-Type': 'text/json'})
      req.body = data.to_json
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      color_results = JSON.parse(res.body)['result'] #2d array of 5 rgb values [[r,g,b], [], ...]
      @month_color_scheme[k] = color_results
    end

    Rails.logger.info @month_color_scheme.inspect
  end
  
end
