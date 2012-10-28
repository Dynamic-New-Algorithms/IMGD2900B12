class ApplicationController < ActionController::Base
  def home
    render '/home.html.haml'
  end

  def rorschach
    render '/rorscharch.html.haml'
  end

  def flowers
    render '/flowers.html.haml'
  end

  def rubik
    render '/rubik.html.haml'
  end
end
