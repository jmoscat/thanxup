class OwnersController < ApplicationController
  load_and_authorize_resource except: [:index, :new, :create, :destroy]

  def show
  end

  def edit
  end

  def update
  end
end
