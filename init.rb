module ::ApplicationHelper
  include Sortable::Helper
  include Searchable::Helper

  def pagination
    will_paginate :next_label => t('next') + ' »',
                  :previous_label => '« ' + t('previous')
  end
end

# include NamedScopes when we inherit from AR::Base
class ::ActiveRecord::Base
  class << self
    alias_method :amberbit_scaffold_original_inherited, :inherited
  end

  def self.inherited(subclass)
    amberbit_scaffold_original_inherited(subclass)

    subclass.instance_eval do
      include NamedScopes
    end
  end
end

# include Sortable and Searchable into all controllers
class ::ApplicationController < ActionController::Base
  class << self
    alias_method :amberbit_scaffold_original_inherited, :inherited
  end

  def self.inherited(subclass)
    amberbit_scaffold_original_inherited(subclass)

    subclass.instance_eval do
      include Sortable::Controller
      include Searchable::Controller
    end
  end
end
