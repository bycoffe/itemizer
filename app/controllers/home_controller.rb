class HomeController < ApplicationController

  caches_action :show

  def index
    @fec_filings = Filing.today
    @today = Date.today
    @yesterday = @today - 1
    @tomorrow = @today + 1
  end

  def form_types
    @form_type = params[:id].upcase
    @fec_filings = Filing.by_type(2014, params[:id])
  end

  def date
    @today = Date.parse("#{params[:month]}/#{params[:day]}/#{params[:year]}")
    @yesterday = @today - 1
    @tomorrow = @today + 1
    @fec_filings = Filing.date(params[:year], params[:month], params[:day])
    render :template => "home/index"
  end

  def show
    @filing_id = params[:id]
    @filing = Fech::Filing.new(@filing_id, :csv_parser => Fech::CsvDoctor)
    @filing.download
    @name = @filing.summary.committee_name.nil? ? @filing.summary.organization_name : @filing.summary.committee_name
    @sked = params[:sked]
    @line = params[:line].to_s
    @itemizations = @filing.rows_like(Regexp.new(@sked + @line))

    respond_to do |format|
      format.html
    end
  end

  def manifest
    render :json => { "name" => "Itemizer", "description" => "Track electronic filings from the Federal Election Commission", "launch_path" =>"/", "icons" => {
    "128" => "http://forjournalists.com/media/icon-128.png", "120" => "http://forjournalists.com/media/icon-120.png", "90" => "http://forjournalists.com/media/icon-90.png", "60"=> "http://forjournalists.com/media/icon-60.png" }, "developer"=> { "name"=> "Derek Willis",
    "url"=> "http://thescoop.org" }, "default_locale"=> "en" }, :content_type => 'application/x-web-app-manifest+json'
  end

end
