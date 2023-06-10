class PerformancesController < ApplicationController
  def index
    render json: { posts: Post.limit(50) }
  end
end