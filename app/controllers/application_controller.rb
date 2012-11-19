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
      @game = "Rorschach"
      @script = '/rorschach.js?body=1'
      render '/game.html.haml',:layout => false
    end
  end

  def flowers
    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Toys/flowers.js'
    else
      @game = "Flowers"
      @script = '/flowers.js?body=1'
      render '/game.html.haml',:layout => false
    end
  end

  def rubik
    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Toys/Rubik.js'
    else
      @game = "Rubik's Cube"
      @script = '/rubik.js?body=1'
      render '/game.html.haml',:layout => false
    end
  end

  def composer
    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Toys/composer.js'
    else
      @game = "Composer"
      @script = '/composer.js?body=1'
      render '/game.html.haml',:layout => false
    end
  end

  def letterpop
    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Toys/letterpop.js'
    else
      @game = "Letter Pop"
      @script = '/letterpop.js?body=1'
      render '/game.html.haml',:layout => false
    end
  end

  def fol

    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Toys/fountainoflife.js'
    else
      @game = "The Fountain of Life"
      @script = '/fol.js?body=1'
      render '/game.html.haml',:layout => false
    end
  end

  def peterstoy

    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Toys/peterstoy.js'
    else
      @game = "Peter's Toy"
      @script = '/peterstoy.js?body=1'
      render '/game.html.haml',:layout => false
    end
  end

  def labyrinth

    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Puzzles/TheLabyrinthp' + params[:patch] + '.js'
    else
      @patch = params[:patch]
      @game = 'The Labyrinth'
      @script = '/labyrinth/' + params[:patch] + '.js?body=1'
      render '/game.html.haml',:layout => false
    end
  end
  def wordwars
    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Games/WordWars.' + params[:patch] + '.js'
    else
      @patch = params[:patch]
      @game = 'ASCii Wars'
      @script = '/wordwars/' + params[:patch] + '.js?body=1'
      render '/game.html.haml',:layout => false
    end
  end

  def dictionary
    render '/Games/dict.txt',:layout => false
  end

  def word_wars_ai_script
    render '/Games/' + params[:script] + '.txt',:layout => false
  end

  def stcukinthevoid
    if params[:format] == 'js'
      render :file => 'app/assets/javascripts/Games/StuckInTheVoid.' + params[:patch] + '.js'
    else
      @patch = params[:patch]
      @game = 'Stuck in the Void'
      @script = '/stuckinthevoid/' + params[:patch] + '.js?body=1'
      render '/game.html.haml',:layout => false
    end
  end

  def trappedinthevoid
    render '/TrappedInTheVoid.html.haml'
  end
end
