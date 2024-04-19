# require_relative '../sidekiq/mail/send_mail_job.rb'

# require 'rubygems'
# require 'bundler/setup'

# require File.expand_path('../config/environment',  __FILE__)


class BillsController < ApplicationController
  before_action :set_bill, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /bills or /bills.json
  def index
    @user_accounts = current_user.accounts.includes(:bills)
    
    # Collect all bills associated with the user's accounts
    @bills = @user_accounts.flat_map(&:bills)
    
    # Filter bills for 'in' and 'out' statuses
    @bills_in = @bills.select { |bill| bill.status == 'in' }
    @bills_out = @bills.select { |bill| bill.status == 'out' }
    
    # Calculate balances
    @balance_in = GetTotalAmount(@bills_in)
    @balance_out = GetTotalAmount(@bills_out)
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
      @from_date = params[:from_date]
      @to_date = params[:to_date]

      # Get accounts of the current_user
      @user_accounts = current_user.accounts.includes(:bills)

      # Get bills which are attached to these accounts
      @bills = @user_accounts.flat_map(&:bills)

      # Filter bills for 'in' and 'out' statuses
      @bills_in = @bills.select { |bill| bill.status == 'in' }
      @bills_out = @bills.select { |bill| bill.status == 'out' }

      # Balance 'in' and 'out'
      @balance_in = GetTotalAmount(@bills_in)
      @balance_out = GetTotalAmount(@bills_out)



      # @bills =  Bill.includes(:account).where(created_at: params[:from_date]..params[:to_date])
      # @bills_in = @bills.includes(:account).where(status: 'in')
      
      # @balance_in = GetTotalAmount(@bills_in)
      
      # @bills_out = @bills.includes(:account).where(status: 'out')
      # @balance_out = GetTotalAmount(@bills_out)
      # @accounts = Account.all
  
      
    else
      # Redirect to index with error message
      flash[:error] = "Please Enter To and From Dates"
      redirect_to bills_url
      return
    end
    
  
    if @bills.empty?
      flash[:error] = "No Data is present for these dates"
    end
    # render :index



    respond_to do |format|
      format.html { render :index }
      format.pdf do
        render pdf: "Bill_at_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}", template: "bills/filtered_bills", formats: [:html]
      end
    end
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
    # debugger
  end

  # GET /bills/1/edit
  def edit
  end

  def create
    @bill = Bill.new(bill_params)
    
    respond_to do |format|
      account_title = params[:bill][:account_type]
      account = current_user.accounts.find_or_create_by(account_title: account_title)          
      
      @bill.account = account
      
      if @bill.save
        # 
        SendMailJob.perform_in(5.seconds, current_user.id, @bill.id)
        # I want to perform the job in 5 seconds and also want to send the current_user and bill to the job as arguments
        # SendMailJob.perform_later(current_user, @bill)
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
