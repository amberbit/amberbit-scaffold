module Sortable::Controller
  def self.included(klass)
    klass.extend ClassMethods
    klass.cattr_accessor :sortable_default_column, :sortable_columns, :sortable_default_order, :table
  end

  protected

  def sortable_by?(column)
    !column.blank? && sortable_columns.include?(column)
  end

  def sortable_order_sql
    params[:order] =~ /^([\w\d_.]+)(-(asc|desc))?$/i
    @sort_by = $1
    @sort_order = $3

    Rails.logger.info  @sort_by.inspect
    Rails.logger.info  @sort_order.inspect

    if @sort_by.blank? || !sortable_by?(@sort_by)
      @sort_by = sortable_default_column
    end

    if @sort_order.blank?
      @sort_order = sortable_default_order.to_s.upcase
    else
      @sort_order.upcase!
    end
    if self.table
      order_sql = "LOWER(#{self.table}.#{@sort_by}) #{@sort_order}"
    else
      order_sql = "LOWER(#{@sort_by}) #{@sort_order}"
    end
  end

  module ClassMethods
    def sortable(options)
      self.sortable_default_column =
      if !options[:default_column].blank?
        options[:default_column].to_s
      else
        options[:columns].first
      end

      if options[:default_order] == :desc
        self.sortable_default_order = :desc
      else
        self.sortable_default_order = :asc
      end

      self.sortable_columns = options[:columns]
      self.table = options[:table]
    end
  end
end

