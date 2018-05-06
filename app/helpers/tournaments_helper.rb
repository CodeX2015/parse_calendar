require 'open-uri'
require 'nokogiri'
module TournamentsHelper
  $download_path = nil
  $file_path = nil
  $max_pages_listing = 5

  def parse_rg4u()
    start = Time.now
    for i in 2011..2018
      puts "Parsing data at #{i} #{start}"
      $year = i
      $download_path = "E:\\Ruby\\WorkSpace\\downloads\\#{$year}\\"
      parse_calendar("http://rg4u.clan.su/tournaments/RU/List_IRGT_RU_#{$year}.htm")
    end
    finish = Time.now
    result_time = finish - start
    result_time = Time.at(result_time).utc.strftime("%H:%M:%S")
    puts "spent time: #{result_time}"
  end

  def parse_calendar(url)
    # получаем содержимое веб-страницы в объект
    page = Nokogiri::HTML(open(url.to_s))

    # производим поиск по элементам с помощью css-выборки
    table = page.css("table[style='border-collapse: collapse;']")
    tr_i = 0
    table.css('tr').each do |tr|
      puts "row=#{tr_i}"
      tournament = nil
      td_i = 0
      link_i = 0
      tr_i += 1
      tds = tr.css('td')
      date = date_from = date_to = city = event_name = nil
      if tds.count == 4 && !tds.to_s.include?('Дата')
        tds.each do |td|
          puts "  column=#{td_i}"
          # td.text && !td.text.strip.empty? &&
          # if td.css('a[href]').count == 0
          puts "    #{td.text.delete('↑').strip}"
          case td_i
          when 0 # date
            date = fix_date(td.text)
            if date && date.include?('-')
              date_from = date.split('-')[0]
              date_to = date.split('-')[1]
            else
              date_from = date ? date : '-'
              date_to = date_from
            end
          when 1 # city
            city = td.text ? td.text : '-'
          when 2 # event_name
            event_name = td.text
            tournament = Tournament.create(organizer: '---',
                                           date_from: date_from,
                                           date_to: date_to,
                                           city: city,
                                           event_name: event_name,
                                           condition_link: '',
                                           forum_link: '',
                                           is_photo_report: false,
                                           is_video_report: false)
            tournament.save


            # links
            # elsif td.css('a[href]')
          when 3
            td.css('a').each do |link|
              puts "    link=#{link_i} #{link['href'].strip}"
              next if !link['href'].include?('http://rg4u.clan.su')
              link_i += 1

              raise 'Object tournament is not set' if tournament.nil?

              if link['href'].strip.to_s.include?('/news/')
                tournament.update(condition_link: link['href'].strip)
                # parse_news(link['href'].strip)
              elsif link['href'].strip.to_s.match(/(?=\/\d{2}\-\d{3}\-\d{5})/)
                tournament.update(condition_link: link['href'].strip)
                # parse_post(link['href'.strip])
              else
                tournament.update(forum_link: link['href'].strip)
                link.to_s.include?('фото') || link.to_s.include?('photo') ?
                    tournament.update(is_photo_report: true) : tournament.update(is_photo_report: false)
                link.to_s.include?('видео') || link.to_s.include?('video') ?
                    tournament.update(is_video_report: true) : tournament.update(is_video_report: false)
                #parse_forum(link['href'].strip)
              end
            end
          end
          td_i += 1
          # end
        end
      else
        puts tds
      end
      # for debug
      # break if tr_i == 8
    end
  end

  def fix_date(date)
    if date.include?('-')
      a_d = date.split('-')
      case a_d[0].to_s.length
      when 2
        return "#{a_d[0]}#{a_d[1].to_s[2..-1]}-#{a_d[1]}"
      when 5
        return "#{a_d[0]}#{a_d[1].to_s[5..-1]}-#{a_d[1]}"
      end
    elsif date.to_s.length > 10
      return "#{date[0..9]}-#{date[10..-1]}"
    else
      return date
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