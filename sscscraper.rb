require "open-uri"
require "pathname"

unless ARGV[0]
  puts "Use ruby sscscraper.rb <url to skyscrapercity forum page>"
  exit
end

url = ARGV[0].strip

begin
  open(url, "User-Agent" => "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1468.0 Safari/537.36") do |source|
    source.each_line do |x|
      if x !~ /skyscrapercity.com/i && x !~ /googlesyndication.com/ && x !~ /doubleclick.net/
        if x =~ /<img src="(https?:\/\/.*\.(?:png|jpg))/i
        name = $1.split('"').first

        next if Pathname.new(name).absolute?

        copy = name.split('/').last
        puts "Image found: " + copy

        begin
          File.open(copy, 'wb') do |f|
            f.write(open(name).read)
          end
        rescue => e
          case e
            when OpenURI::HTTPError
              puts e
              next
            else
              puts "Error"
              puts e
          end
        end
      end
    end
    end
  end
end