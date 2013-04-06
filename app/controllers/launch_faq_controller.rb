class LaunchFaqController < ApplicationController
  layout "black"

  def show
    @app = App.lulcards
    @title = "lulcards Launch FAQ"
  end
end
