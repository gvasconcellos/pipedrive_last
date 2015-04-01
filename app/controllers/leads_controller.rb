class LeadsController < ApplicationController
  before_filter :authorize_user
  before_action :set_lead, only: [:show, :edit, :update, :destroy]

  # GET /leads
  # GET /leads.json
  def index
    @leads = current_user.leads.all
    #@leads = Lead.where(user_id: current_user.id)
    #@leads = Lead.all
  end

  # GET /leads/1
  # GET /leads/1.json
  def show
    @lead = current_user.leads.find(params[:id])
  end

  # GET /leads/new
  def new
    @lead = current_user.leads.build
  end

  # GET /leads/1/edit
  def edit
    @lead = current_user.leads.find(params[:id])
  end

  # POST /leads
  # POST /leads.json
  def create
    @lead = current_user.leads.build(lead_params)

    respond_to do |format|
      if @lead.save
        format.html { redirect_to @lead, notice: 'Lead was successfully created.' }
        format.json { render :show, status: :created, location: @lead }
      else
        format.html { render :new }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leads/1
  # PATCH/PUT /leads/1.json
  def update
    @lead = current_user.leads.find(params[:id])

    respond_to do |format|
      if @lead.update(lead_params)
        format.html { redirect_to @lead, notice: 'Lead was successfully updated.' }
        format.json { render :show, status: :ok, location: @lead }
      else
        format.html { render :edit }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leads/1
  # DELETE /leads/1.json
  def destroy
    @lead = current_user.leads.find(params[:id])

    @lead.destroy
    respond_to do |format|
      format.html { redirect_to leads_url, notice: 'Lead was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def authorize_user
      unless current_user
        redirect_to root_path, alert: "You need to login"
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      #@lead = Lead.find(params[:id])
      @lead = current_user.leads.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lead_params
      params.require(:lead).permit(:name, :last_name, :email, :company, :job_title, :phone, :website)
    end
end
