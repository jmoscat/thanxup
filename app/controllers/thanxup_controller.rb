class ThanxupController < ApplicationController
  skip_authorization_check

  def home
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def terms
  end

  def unauthorized
  end

  def subregion_options
    render partial: '/layouts/subregion_select'
  end
end
