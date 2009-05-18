class <%= controller_class_name %>Controller < ApplicationController
  # GET /<%= plural_name %>
  def index
    @<%= plural_name %> = <%= class_name %>.paginate(:page => params[:page], :per_page => 10)
  end

  # GET /<%= plural_name %>/1
  def show
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
  end

  # GET /<%= plural_name %>/new
  def new
    @<%= singular_name %> = <%= class_name %>.new
  end

  # GET /<%= plural_name %>/1/edit
  def edit
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
  end

  # POST /<%= plural_name %>
  def create
    @<%= singular_name %> = <%= class_name %>.new(params[:<%= singular_name %>])

    if @<%= singular_name %>.save
      flash[:notice] = t('<%= singular_name %>.flash.saved')
      redirect_to <%= singular_name %>_path(@<%= singular_name %>)
    else
      render :action => 'new'
    end
  end

  # PUT /<%= plural_name %>/1
  def update
    @<%= singular_name %> = <%= class_name %>.find(params[:id])

    if @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])
      flash[:notice] = t('<%= singular_name %>.flash.saved')
      redirect_to <%= singular_name %>_path(@<%= singular_name %>)
    else
      render :action => 'edit'
    end
  end

  # DELETE /<%= plural_name %>/1
  def destroy
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
    @<%= singular_name %>.destroy
    flash[:notice] = t('<%= singular_name %>.flash.deleted')
    redirect_to <%= plural_name %>_path
  end
end
