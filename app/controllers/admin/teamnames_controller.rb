class Admin::TeamnamesController < ApplicationController
  def index
    if params[:bookmaker_id].nil?
      @names = Teamname.order("bookmaker_id").all
    else
      @names = Teamname.where("bookmaker_id = ?", params[:bookmaker_id]).order("name").all
    end
    @mainnames = Teamname.order(:name).where(:main => true).all
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
end
