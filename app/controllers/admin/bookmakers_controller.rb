class Admin::BookmakersController < ApplicationController
  def new
    @bookie = Bookmaker.new
  end

  def create
    @bookie = Bookmaker.new(params[:bookmaker])

    if @bookie.save
      flash[:notice] = 'Bookmaker succesfully created!'
      redirect_to :controller => "/admin", :action => "index"
    else
      render :action => "new"
    end
  end

  def show
    @bookie = Bookmaker.find(params[:id])
  end

  def destroy
    @bookie = Bookmaker.find(params[:id])

    flash[:notice] = "\'#{@bookie.name}\' has been deleted!"
    @bookie.destroy
    
    redirect_to :controller => "/admin", :action => "index"
  end

  def edit
    @bookie = Bookmaker.find(params[:id])
  end

  def update
    @bookie = Bookmaker.find(params[:id])

    if @bookie.update_attributes(params[:bookmaker])
      flash[:notice] = "#{params[:post]} \'#{@bookie.name}\' was successfully updated!"
      redirect_to :controller => '/admin', :action => 'index'
    else
      render :action => "edit"
    end
  end
end
