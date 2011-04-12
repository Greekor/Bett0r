class Admin::TeamnamesController < ApplicationController
  def index
    if params[:bookmaker_id].nil?
      @names = Teamname.order("bookmaker_id").all
    else
      @names = Teamname.where("bookmaker_id = ?", params[:bookmaker_id]).order("name").all
    end
    @mainnames = Teamname.order(:name).where(:main => true).all
    @token_occurences = get_token_occurences
  end

  def update_all
    @names = Teamname.all
    @names.each do |n|
      n.mainname = Teamname.find(params[:name][n.id.to_s]) unless params[:name][n.id.to_s].blank?
      n.main = params[:mainname][n.id.to_s] unless params[:mainname][n.id.to_s].blank? unless params[:mainname].blank?
    end

    @names.each { |n| n.save }

    redirect_to :action => 'index'
  end

  private

  def get_token_occurences
    mainnames = @mainnames.map { |mainname| { :name => mainname.name, :id =>     mainname.id, :points => 0 } }
        
    # to lowercase und akzente etc rausstrippen...
    token_occurences = {}
    mainnames.each do |mainname|
      mainname_tokens = mainname[:name].split(/\s+/)
      mainname_tokens.each do |mnt|
        if token_occurences.has_key? mnt
          token_occurences[mnt] += 1.0
        else
          token_occurences[mnt] = 1.0
        end
      end
    end
    token_occurences
   end

end
