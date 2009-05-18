module Searchable::Controller
  def self.included(klass)
    klass.extend ClassMethods
    klass.cattr_accessor :searchable_columns, :searchable_conditions_sql
  end

  protected

  def searchable_conditions
    query = params[:query]
    return [] if query.blank?
    query = query.mb_chars.downcase!

    conditions = Array.new(self.searchable_columns.length, "%#{query}%")
    conditions.unshift self.searchable_conditions_sql
    conditions
  end

  module ClassMethods
    def searchable(options)
      self.searchable_columns = options[:columns]
      self.searchable_conditions_sql = self.searchable_columns.map do |c|
        "LOWER(`#{c}`) LIKE ?"
      end.join(' OR ')
    end
  end
end
