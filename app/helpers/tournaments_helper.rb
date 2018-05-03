require 'open-uri'
require 'nokogiri'
module TournamentsHelper
  def parse_calendar(url)
    # получаем содержимое веб-страницы в объект
    page = Nokogiri::HTML(open(url.to_s))

    # производим поиск по элементам с помощью css-выборки
    table = page.css("table[style='border-collapse: collapse;']")
    tr_i = 0
    table.css('tr').each do |tr|
      puts "line=#{tr_i}"
      tournament = nil
      td_i = 0
      link_i = 0
      tr_i += 1
      tds = tr.css('td')
      if tds.count == 4
        date = city = event_name = nil
        tds.each do |td|
          puts "  column=#{td_i}"
          if td.text && !td.text.strip.empty?
            break if td.text.include?('↑')
            puts "    #{td.text.delete('↑').strip}"
            case td_i
            when 0 # date
              date = td.text
            when 1 # city
              city = td.text
            when 2 # event_name
              event_name = td.text
              tournament = Tournament.create(year: @year, date: date, city: city, event_name: event_name)
              tournament.save
            end
            td_i += 1
          end
        end

        if tr.css('a[href]')
          tr.css('a').each do |link|
            puts "    link=#{link_i}"
            link_i += 1
            puts "      #{link['href'].strip}"
            #parse_files(link['href'].strip)
            tournament.link.create(url: link['href'].strip) if !tournament.nil?
          end
        end
      end
      # break if tr_i == 8
    end
  end

  def get_links_calendar_by_year(url)
    @year = 2011
    page = Nokogiri::HTML(open(url.to_s))
    forum = page.css("font[color='#800000']")
    forum.css("a[href]").each do |link|
      if link['href'].include?('tournaments/RU/List_IRGT_RU')
        parse_calendar(link['href'])
        @year += 1
      end
    end
  end

  def convert_date
    tournaments = Tournament.all
    tournaments.each do |tournament|
      date = tournament.date
      if date.include?('-')
        a_d = date.split('-')
        case a_d[0].to_s.length
        when 2
          date = "#{a_d[0]}#{a_d[1].to_s[2..-1]}-#{a_d[1]}"
        when 5
          date = "#{a_d[0]}#{a_d[1].to_s[5..-1]}-#{a_d[1]}"
        end
      elsif date.to_s.length > 10
        date = "#{date[0..9]}-#{date[10..-1]}"
      else
        puts date
      end
      puts date
      tournament.update(date: date)
    end
  end
end