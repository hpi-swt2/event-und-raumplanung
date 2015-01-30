module PaginationModule
	def self.included(base)
    	base.extend(ClassMethods)
  	end

  	module ClassMethods
		def options_for_per_page
  		[
    		[5,5],
    		[10,10],
    		[15,15],
    		[25,25],
    		[50,50],
    		[100,100],
    		[500,500]
  		]
  		end
  	end
end 