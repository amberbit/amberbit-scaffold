module Sortable::Controller
  def self.included(klass)
    klass.extend ClassMethods
    klass.cattr_accessor :sortable_default_column, :sortable_columns
  end

  protected

  def sortable_by?(column)
    !column.blank? && sortable_columns.include?(column.to_sym)
  end

  def sortable_order_sql
    params[:order] =~ /^([\w\d_]+)(-(asc|desc))?$/i
    @sort_by = $1
    @sort_order = $3

    if @sort_by.blank? || !sortable_by?(@sort_by)
      @sort_by = sortable_default_column
    end

    if @sort_order.blank?
      @sort_order = 'ASC'
    else
      @sort_order.upcase!
    end

    order_sql = "LOWER(#{@sort_by}) #{@sort_order}"
  end

  module ClassMethods
    def sortable(options)
      self.sortable_default_column =
      if !options[:default_column].blank?
        options[:default_column].to_s
      else
        options[:columns].first
      end

      self.sortable_columns = options[:columns]
    end
  end
end

