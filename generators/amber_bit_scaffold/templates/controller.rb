<%
  associations = attributes.
    select { |atr| atr.column.name =~ /_id\Z/ }.
    map { |atr| atr.column.name.sub(/_id\Z/, '') }
-%>
class <%= controller_class_name %>Controller < ApplicationController
  include Sortable::Controller
  include Searchable::Controller
  sortable :columns => [:<%= attributes.first.column.name %>]
  searchable :columns => [:<%= attributes.first.column.name %>]
<% associations.each do |assoc| -%>
  before_filter :find_<%= assoc.pluralize %>, :only => [:new, :edit, :create, :update]
<% end -%>

  # GET /<%= plural_name %>
  def index
    @<%= plural_name %> = <%= class_name %>.order(sortable_order_sql).
      paginate(:page => params[:page], :per_page => 10,
<%
  unless associations.empty?
    includes = associations.map { |a| ":#{a}"}.join(', ')
    includes = "[#{includes}]" if associations.size > 1
-%>
               :include => <%= includes %>,
<% end -%>
               :conditions => searchable_conditions)
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
<% unless associations.empty? -%>

  private

<% associations.each do |assoc| -%>
  def find_<%= assoc.pluralize %>
<%
  klass = assoc.camelize.constantize
  order = klass.column_names.include?('name') ? 'name' : 'id'
-%>
    @<%= assoc.pluralize %> = <%= klass %>.order('<%= order %>').all
  end
<% end -%>
<% end -%>
end

