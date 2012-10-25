class ApplicationController < ActionController::Base
  def home
    puts 'called here ------------------------------ '
    render '/home.html.haml'
  end
end
