class AnalyzerController < ApplicationController
  def index
    if params[:bookie_id].nil? then
      @bets = Game.best_bets
    else
      @bets = Game.best_bets_by_bookie(Bookmaker.find(params[:bookie_id]))
    end
    @bets.sort_by! { |b| b[:per] }.reverse!
    @bets.delete_if { |b| b[:per] < 97.5 }
    Time.zone = "CET"
  end
end
