class ApplicationController < ActionController::Base
  def home
    render '/home.html.haml'
  end

  def rorschach
    render '/rorscharch.html.haml'
  end
end
