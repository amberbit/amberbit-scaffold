module NamedScopes
  def self.included(klass)
    if klass.respond_to? :named_scope
      klass.named_scope :order, lambda { |*args|
        order = args.first
        {:order => order || 'name ASC'}
      }
    end
  end
end
