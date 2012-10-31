class ApplicationController < ActionController::Base
  def home
    render '/home.html.haml'
  end

  def rorschach
    render '/Assig3/rorscharch.html.haml'
  end

  def flowers
    render '/Assig3/flowers.html.haml'
  end

  def rubik
    render '/Assig3/rubik.html.haml'
  end

  def composer
    render '/Assig3/composer.html.haml'
  end

  def letterpop
    render '/Assig3/letterpop.html.haml'
  end

  def fol
    render '/Assig3/fountainoflife.html.haml'
  end

  def peterstoy
    render '/Assig3/peterstoy.html.haml'
  end
end
