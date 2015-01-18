module FilteringModule 

  def self.included(base)
    base.class_eval do
      scope :search_query, lambda { |query|
       terms = query.downcase.split(/\s+/)
       table_name = self.name.underscore.downcase.pluralize
       terms = terms.map { |e| (e.gsub('*', '%') + '%').gsub(/%+/, '%')}
       where( terms.map { |term| "LOWER(#{table_name}.name) LIKE ?"}.join(' AND '), *terms.map { |e| [e]} )
      }
    end
  end
end