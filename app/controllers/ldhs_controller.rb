class LdhsController < ApplicationController

  def new
    ld = Ldhs.find(:all, :order => 'difficulty DESC',:limit => 17)
    lp = Ldhs.find(:all, :order => 'points DESC',:limit => 17)
    if params[:difficulty].to_i >= ld.last.difficulty or params[:points].to_i >= lp.last.points
      l = Ldhs.new()
      l.name = params[:name]
      l.points = params[:points]
      l.difficulty = params[:difficulty]
      l.save()
      render json: l
    else
      render json: 'nothing'
    end

  end

  def topten
    l = Ldhs.find(:all, :order => params[:order] + ' DESC',:limit => 17)
    render json: l
  end
end
