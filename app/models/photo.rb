class Photo < ActiveRecord::Base
    
    ################################## ASSOCIATIONS #################################
    belongs_to :listing
    
end
