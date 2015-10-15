class CreateListings < ActiveRecord::Migration
    def change

# - contact information (phone, email)
# - bedroom and bathroom count
# - latitude/longitude values
# - street, city, state, zipcode
# - price
# - photos
# - listing source url (lp-url)
# - listing id (provider-listingid)
# - title
# - description

        create_table :listings do |t|

            t.belongs_to    :landlord
            t.string        :title
            t.integer       :price
            t.text          :description
            t.integer       :num_bedroom
            t.integer       :num_bathroom
            t.string        :lp_url
            t.string        :provider_listing_id
            # Location
            t.string        :street
            t.string        :city
            t.string        :state
            t.string        :zip
            t.float         :longitude
            t.float         :latitude
            t.timestamps
        end

        create_table :photos do |t|
            t.belongs_to    :listing
            t.string        :url
            t.string        :caption
            t.string        :description
            t.string        :seq_number
            t.timestamps
        end

        create_table :landlords do |t|
            t.string        :name
            t.string        :phone
            t.string        :email
            t.timestamps
        end

    end
end
