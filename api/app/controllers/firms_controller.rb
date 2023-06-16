class FirmsController < ApplicationController
  def show
    firm = Firm.left_joins(:performances).find(params[:id])
    firm_performances = Performance.where(firm_id: firm.id)

    render json: {firm: firm, performance: firm_performances}
  end

  def update
    @firm = Firm.find(params[:firm][:id])
    @firm.update(params.require(:firm).permit(:code, :firm_name, :firm_name_kana, :status, :post_code, :address, :representive, :representive_kana, :phone_number))
    @sales_param = params.require(:sales).permit("2022", "2021", "2020")
    @profits_param = params.require(:profits).permit("2022", "2021", "2020")

    for year in @sales_param.keys do
      @performance = Performance.find_by(firm_id: @firm.id, year: year)
      @performance.update!(sales: @sales_param[year])
    end

    for year in @profits_param.keys do
      @performance = Performance.find_by(firm_id: @firm.id, year: year)
      @performance.update!(profits: @profits_param[year])
    end
    
    render json: {message: 'success'}
  end

  def destroy
    @firm = Firm.find(params[:id])
    @firm.destroy!
    render json: {message: 'success'}
  end

  def search
    @status = params[:status]
    @firm_name = params[:firmName]
    @address = params[:address]
    @sales_max = params[:salesMax]
    @sales_min = params[:salesMin]
    @profits_max = params[:profitsMax]
    @profits_min = params[:profitsMin]
    @search_pattern = params[:searchPattern]
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
                .yield_self{|firms| @address.present? ? firms.where("address LIKE ?", "%#{@address}%") : firms}
                .yield_self{|firms| @sales_max.present? ? firms.where(performances: {sales: ..@sales_max.to_i, year: "2022"}) : firms}
                .yield_self{|firms| @sales_min.present? ? firms.where(performances: {sales: @sales_min.to_i.., year: "2022"}) : firms}
                .yield_self{|firms| @profits_max.present? ? firms.where(performances: {profits: ..@profits_max.to_i, year: "2022"}) : firms}
                .yield_self{|firms| @profits_min.present? ? firms.where(performances: {profits: @profits_min.to_i.., year: "2022"}) : firms}
                .all
    render json: { firms: firms }
  end

  def or_search()
    p @profits_max
    firms = Firm.includes(:performances)
                .none
                .yield_self{|firms| @status.present? ? firms.or(Firm.includes(:performances).where(status: @status.to_i)) : firms}
                .yield_self{|firms| @firm_name.present? ? firms.or(Firm.includes(:performances).where(firm_name: @firm_name)) : firms}
                .yield_self{|firms| @address.present? ? firms.or(Firm.includes(:performances).where("address LIKE ?", "%#{@address}%")) : firms}
                .yield_self{|firms| @sales_max.present? ? firms.or(Firm.includes(:performances).where(performances: {sales: ..@sales_max.to_i, year: "2022"})) : firms}
                .yield_self{|firms| @sales_min.present? ? firms.or(Firm.includes(:performances).where(performances: {sales: @sales_min.to_i.., year: "2022"})) : firms}
                .yield_self{|firms| @profits_max.present? ? firms.or(Firm.includes(:performances).where(performances: {profits: ..@profits_max.to_i, year: "2022"})) : firms}
                .yield_self{|firms| @profits_min.present? ? firms.or(Firm.includes(:performances).where(performances: {profits: @profits_min.to_i.., year: "2022"})) : firms}
                
      render json: { firms: firms }
  end

  def firm_update_params
    params.permit(firm:[:id, :code, :firm_name, :firm_name_kana, :status, :post_code, :address, :representive, :representive_kana, :phone_number], 
                  sales:["2022", "2021", "2020"],
                  profits:["2022", "2021", "2020"]
                )
  end

end