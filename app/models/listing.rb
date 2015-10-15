class Listing < ActiveRecord::Base
    
    ################################## ASSOCIATIONS #################################

    has_many :photos
    belongs_to :landlord

    ################################## CLASS METHODS ##################################

    # Return stats for facts
    def self.stats
        all_users   = Listing.all.count
        today       = Listing.where(created_at: 1.day.ago..Time.now).count
        week        = Listing.where(created_at: 1.week.ago..Time.now).count
        month       = Listing.where(created_at: 1.month.ago..Time.now).count
        return { Total: all_users, Today: today, Week: week, Month: month } 
    end

    ################################## JSON #################################
  
    # Will be use by to_json
    def as_json options={}

        # Markers view for google maps (index page)
        # i.e. ['London Eye, London', 51.503454,-0.119562]
        if options[:view] && options[:view] == 'marker'
            json = { title: title, lat: latitude, lon: longitude } 

        else
            json = { 
                        id:         id, 
                        title: title,
                        price: price,
                        description: description,
                        num_bedroom: num_bedroom,
                        num_bathroom: num_bathroom,
                        lp_url: lp_url,
                        provider_listing_id: provider_listing_id,
                        street: street,
                        city: city,
                        state: state,
                        zip: zip,
                        longitude: longitude,
                        latitude: latitude
       
                    }
        end

    end


end
