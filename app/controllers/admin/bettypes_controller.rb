class Admin::BettypesController < ApplicationController
  def index
    @bettypes = Bettype.order("bookmaker_id").all

    @maintypes = Bettype.where(:main => true).all
  end

  def update_all
    @bettypes = Bettype.all
    @bettypes.each do |b|
      b.maintype = Bettype.find(params[:type][b.id.to_s]) unless params[:type][b.id.to_s].blank?
      b.main = params[:maintype][b.id.to_s] unless params[:maintype][b.id.to_s].blank? unless params[:maintype].blank?
    end

    @bettypes.each { |b| b.save }

    redirect_to :action => 'index'
  end

end
