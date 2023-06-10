class FirmsController < ApplicationController
  def index
    posts = {'message' => 'ンゴ'}
    res = posts
    render json: { status: 'SUCCESS', message: 'Loaded posts', data: res }
  end

  def search
    @code = params[:code]
    @status = params[:status]
    @firm_name = params[:firm_name]
    @firm_name_kana = params[:firm_name_kana]
    @post_code = params[:post_code]
    @address = params[:address]
    @representive = params[:representive]
    @representive_kana = params[:representive_kana]
    @phone_number = params[:phone_number]

    
  end
end