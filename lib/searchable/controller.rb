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
          c = c.to_s.split('.')
          if c.size == 1
            "LOWER(`#{c[0]}`) LIKE ?"
          else
            "LOWER(#{c[0]}.`#{c[1]}`) LIKE ?"
          end

      end.join(' OR ')
    end
  end
end

