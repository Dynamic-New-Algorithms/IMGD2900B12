class ApplicationController < ActionController::Base
  def home
    render '/home.html.haml'
  end

  def psdna
    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/ps2.2.dna.js'
    else
      render '/PS_dna_Change_Log.html.haml'
    end
  end

  def rorschach
    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Toys/Rorschach.js',:layout => false
    else
      render '/Toys/rorscharch.html.haml'
    end
  end

  def flowers
    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Toys/flowers.js'
    else
      render '/Toys/flowers.html.haml'
    end
  end

  def rubik
    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Toys/ribik.js'
    else
      render '/Toys/rubik.html.haml'
    end
  end

  def composer
    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Toys/composer.js'
    else
      render '/Toys/composer.html.haml'
    end
  end

  def letterpop
    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Toys/letterpop.js'
    else
      render '/Toys/letterpop.html.haml'
    end
  end

  def fol

    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Toys/fountainoflife.js'
    else
      render '/Toys/fountainoflife.html.haml'
    end
  end

  def peterstoy

    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Toys/peterstoy.js'
    else
      render '/Toys/peterstoy.html.haml'
    end
  end

  def labyrinth

    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Puzzles/TheLabyrinthp' + params[:patch] + '.js'
    else
      render '/Puzzles/TheLabyrinthp' + params[:patch] + '.html.haml'
    end
  end
end
