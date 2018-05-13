class TournamentSearch
  attr_reader :date_from, :city

  def initialize(params)
    params ||= {}
    # 7.days.future.to_d
    #     ago.to_date.to_s
    @date_from = parsed_date(params[:date_from], Date.today.to_s)
    @city = params[:city]
    # @date_to = parsed_date(params[:date_to], Date.today.to_s)
  end

  def scope
    if @city.nil? || @city.empty?
      Tournament.where('date_from >= ?', @date_from)
    else
      Tournament.where('date_from >= ? AND city LIKE ?', @date_from, "%#{@city}%")
    end
    # Tournament.where('date_from >= ? AND date_to <= ?', @date_from, @date_to)

  end

  private

  def parsed_date(date_string, default)
    Date.parse(date_string).strftime('%Y-%m-%d')
  rescue => ex
    Date.parse(default).strftime('%Y-%m-%d')
  end
end