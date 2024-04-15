class BillsController < ApplicationController
  before_action :set_bill, only: %i[ show edit update destroy ]

  # GET /bills or /bills.json
  def index
    @bills = Bill.includes(:account).all
    @bills_in = Bill.includes(:account).where(status: 'in')
      
      @balance_in = GetTotalAmount(@bills_in)
      
      @bills_out = Bill.includes(:account).where(status: 'out')
      @balance_out = GetTotalAmount(@bills_out)
    @accounts = Account.all
  end


  def GetTotalAmount(bills)
    total = 0
    bills.each do |bill|
      total += bill.amount
      total = total.round(2)
    end
    total
  end
  
  


  def filter
    if params[:from_date].present? && params[:to_date].present?
      @bills =  Bill.includes(:account).where(created_at: params[:from_date]..params[:to_date])
      @bills_in = Bill.includes(:account).where(status: 'in')
      
      @balance_in = GetTotalAmount(@bills_in)
      
      @bills_out = Bill.includes(:account).where(status: 'out')
      @balance_out = GetTotalAmount(@bills_out)
      @accounts = Account.all
  
      
    else
      # Want to show a flash message that nothing found for these dates
      # flash[:error] = "No bills found for these dates"
      @bills = Bill.all
      @bills_in = Bill.includes(:account).where(status: 'in')
      @balance_in = GetTotalAmount(@bills_in)
      
      @bills_out = Bill.includes(:account).where(status: 'out')
      @balance_out = GetTotalAmount(@bills_out)
      @accounts = Account.all
    end
  
    if @bills.empty?
      flash[:error] = "No Data is present for these dates"
    end
    # render :index
  end
  

  # GET /bills/1 or /bills/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "bill_#{params[:id]}", template: "bills/show", formats: [:html]  # Excluding ".pdf" extension.
      end
    end
  end
  
  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # GET /bills/1/edit
  def edit
  end

  def create
    @bill = Bill.new(bill_params)
    respond_to do |format|
      account_title = params[:bill][:account_type]
      account = Account.find_or_create_by(account_title: account_title)          
      
      @bill.account = account

      if @bill.save
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully created." }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully updated." }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1 or /bills/1.json
  def destroy
  @bill.destroy
    respond_to do |format|
      format.html { redirect_to bills_url, notice: "Bill was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bill_params
      params.require(:bill).permit(:amount, :description, :status, :bill_reference, :image)
    end
end
