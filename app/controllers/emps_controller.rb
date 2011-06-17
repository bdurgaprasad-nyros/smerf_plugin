class EmpsController < ApplicationController
  # GET /emps
  # GET /emps.xml
 include Smerf
 def index
     
  self.smerf_user_id = 1
  
    @emps = Emp.all
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @emps }
    end
  end

  # GET /emps/1
  # GET /emps/1.xml
  def show
    @emp = Emp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @emp }
    end
  end

  # GET /emps/new
  # GET /emps/new.xml
  def new
    @emp = Emp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @emp }
    end
  end

  # GET /emps/1/edit
  def edit
    @emp = Emp.find(params[:id])
  end

  # POST /emps
  # POST /emps.xml
  def create
    @emp = Emp.new(params[:emp])

    respond_to do |format|
      if @emp.save
        format.html { redirect_to(@emp, :notice => 'Emp was successfully created.') }
        format.xml  { render :xml => @emp, :status => :created, :location => @emp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @emp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /emps/1
  # PUT /emps/1.xml
  def update
    @emp = Emp.find(params[:id])

    respond_to do |format|
      if @emp.update_attributes(params[:emp])
        format.html { redirect_to(@emp, :notice => 'Emp was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @emp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /emps/1
  # DELETE /emps/1.xml
  def destroy
    @emp = Emp.find(params[:id])
    @emp.destroy

    respond_to do |format|
      format.html { redirect_to(emps_url) }
      format.xml  { head :ok }
    end
  end
end
