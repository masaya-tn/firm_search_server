class FirmsController < ApplicationController
  def index
    posts = {'message' => 'ンゴ'}
    res = posts
    render json: { status: 'SUCCESS', message: 'Loaded posts', data: res }
  end

  def search
    @status = params[:status]
    @firm_name = params[:firm_name]
    @address = params[:address]
    @sales_upper_limit = params[:sales_upper_limit]
    @sales_lower_limit = params[:sales_lower_limit]
    @profits_upper_limit = params[:profits_upper_limit]
    @profits_lower_limit = params[:profits_lower_limit]


    # AND検索
    firms = Firm.includes(:performances)
                .yield_self{|firms| @status.present? ? firms.where(status: @status.to_i) : firms}
                .yield_self{|firms| @firm_name.present? ? firms.where(firm_name: @firm_name) : firms}
                .yield_self{|firms| @address.present? ? firms.where(address: @address) : firms}
                .yield_self{|firms| @sales_upper_limit.present? ? firms.where(performances: {sales: ..@sales_upper_limit.to_i, year: "2022"}) : firms}
                .yield_self{|firms| @sales_lower_limit.present? ? firms.where(performances: {sales: @sales_lower_limit.to_i.., year: "2022"}) : firms}
                .yield_self{|firms| @profits_upper_limit.present? ? firms.where(performances: {profits: ..@profits_upper_limit.to_i, year: "2022"}) : firms}
                .yield_self{|firms| @profits_lower_limit.present? ? firms.where(performances: {profits: @profits_lower_limit.to_i.., year: "2022"}) : firms}
                .all
    p firms

    # OR検索
    firms = Firm.includes(:performances)
                .none
                .yield_self{|firms| @status.present? ? firms.or(Firm.where(status: @status.to_i)) : firms}
                .yield_self{|firms| @firm_name.present? ? firms.or(Firm.where(firm_name: @firm_name)) : firms}
                .yield_self{|firms| @address.present? ? firms.or(Firm.where(address: @address)) : firms}
                .yield_self{|firms| @sales_upper_limit.present? ? firms.or(Firm.includes(:performances).where(performances: {sales: ..@sales_upper_limit.to_i, year: "2022"})) : firms}
                .yield_self{|firms| @sales_lower_limit.present? ? firms.or(Firm.includes(:performances).where(performances: {sales: @sales_lower_limit.to_i.., year: "2022"})) : firms}
                .yield_self{|firms| @profits_upper_limit.present? ? firms.or(Firm.includes(:performances).where(performances: {profits: ..@profits_uppper_limit.to_i, year: "2022"})) : firms}
                .yield_self{|firms| @profits_lower_limit.present? ? firms.or(Firm.includes(:performances).where(performances: {profits: @profits_lower_limit.to_i.., year: "2022"})) : firms}
                
    p firms


  end
end