class Listing < ActiveRecord::Base
    
    ################################## ASSOCIATIONS #################################

    has_many :photos
    belongs_to :landlord

    ################################## CLASS METHODS ##################################

    # Trying to find a listing by the hash
    def self.find_by_hash(hash)
        Listing.where("lp_url = '#{hash[:lp_url]}' OR (longitude = '#{hash[:longitude]}' AND latitude = '#{hash[:latitude]}')").limit(1)
    end

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
        # Info window view for google maps
        # i.e. '[<div class="info_content"><h3>London Eye</h3><p>The London Eye is a giant Ferris wheel situated on the banks of the River Thames. The entire structure is 135 metres (443 ft) tall and the wheel has a diameter of 120 metres (394 ft).</p></div>]'
        elsif options[:view] && options[:view] == 'info_window'
            info_window = '<div class=\"info_content\"><h3>' + title + '</h3><p>$ ' + "#{price}" + '</p></div>'
            json        = [info_window]
        else
            json = { 
                        id:                     id, 
                        title:                  title,
                        price:                  price,
                        description:            description,
                        num_bedroom:            num_bedroom,
                        num_bathroom:           num_bathroom,
                        lp_url:                 lp_url,
                        provider_listing_id:    provider_listing_id,
                        street:                 street,
                        city:                   city,
                        state:                  state,
                        zip:                    zip,
                        longitude:              longitude,
                        latitude:               latitude
                    }
        end

    end

end
