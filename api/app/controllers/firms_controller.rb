class FirmsController < ApplicationController
  def index
  end

  def search
    @status = params[:status]
    @firm_name = params[:firmName]
    @address = params[:address]
    @sales_max = params[:salesMax]
    @sales_min = params[:salesMin]
    @profits_max = params[:profitsMax]
    @profits_min = params[:profitsMin]
    @search_pattern = prarams[:searchPattern]

    case @search_pattern
    when 'and' then
      firms = and_search()
    when 'or' then
      firms = or_search()
    end

    firms
  end

  private

  def and_search()
    firms = Firm.includes(:performances)
                .yield_self{|firms| @status.present? ? firms.where(status: @status.to_i) : firms}
                .yield_self{|firms| @firm_name.present? ? firms.where(firm_name: @firm_name) : firms}
                .yield_self{|firms| @address.present? ? firms.where(address: @address) : firms}
                .yield_self{|firms| @sales_max.present? ? firms.where(performances: {sales: ..@sales_max.to_i, year: "2022"}) : firms}
                .yield_self{|firms| @sales_min.present? ? firms.where(performances: {sales: @sales_min.to_i.., year: "2022"}) : firms}
                .yield_self{|firms| @profits_max.present? ? firms.where(performances: {profits: ..@profits_max.to_i, year: "2022"}) : firms}
                .yield_self{|firms| @profits_min.present? ? firms.where(performances: {profits: @profits_min.to_i.., year: "2022"}) : firms}
                .all
    firms
  end

  def or_search()
    firms = Firm.includes(:performances)
                .none
                .yield_self{|firms| @status.present? ? firms.or(Firm.where(status: @status.to_i)) : firms}
                .yield_self{|firms| @firm_name.present? ? firms.or(Firm.where(firm_name: @firm_name)) : firms}
                .yield_self{|firms| @address.present? ? firms.or(Firm.where(address: @address)) : firms}
                .yield_self{|firms| @sales_max.present? ? firms.or(Firm.includes(:performances).where(performances: {sales: ..@sales_max.to_i, year: "2022"})) : firms}
                .yield_self{|firms| @sales_min.present? ? firms.or(Firm.includes(:performances).where(performances: {sales: @sales_min.to_i.., year: "2022"})) : firms}
                .yield_self{|firms| @profit_max.present? ? firms.or(Firm.includes(:performances).where(performances: {profits: ..@profits_max.to_i, year: "2022"})) : firms}
                .yield_self{|firms| @profits_min.present? ? firms.or(Firm.includes(:performances).where(performances: {profits: @profits_min.to_i.., year: "2022"})) : firms}
                
    firms
  end
end