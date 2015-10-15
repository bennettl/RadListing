require 'json'

namespace :db do
	desc 'Fill database with sample data'
	task populate: :environment do
		populate_listings
	end

	# Popupulate users bae on json file
	def populate_listings

		# Convert XML feed to hash
		listings = Hash.from_xml(File.read('config/data/code_challenge_listings.xml'))['properties']['property']
		
		# Iterate through each hash
		listings.each do |l|
			# puts "Creating listing #{l['details']['listing_title']}..."

			# Each listing is required to have a minimum of three photos. If the listing has less than three photos, it can be discarded.
			if l['pictures']['picture'].count < 3 || l['pictures']['picture'].class == Hash
				next
			end

			hash = {
					   title: 					l['details']['listing_title'],
					   price: 					l['details']['price'],
					   description:				l['details']['description'],
					   num_bedroom:				l['details']['num_bedrooms'],
					   num_bathroom:			l['details']['num_bathrooms'],
					   lp_url: 					l['landing_page']['lp_url'],
					   provider_listing_id:		l['details']['provider_listingid'],
					   street: 					l['location']['street_address'],
					   city: 					l['location']['city_name'],
					   state: 					l['location']['state_code'],
					   zip: 					l['location']['zipcode'],
					   longitude: 				l['location']['longitude'],
					   latitude: 				l['location']['latitude'],
			}

			# Reject nil and empty values
            hash.reject!{|k,v| v.blank?} 

			# Try to find listing by hash            
			listing = Listing.find_by_hash(hash)

			# If no listing is found, create one
			if listing.empty?
				puts "creating listing"
				listing = Listing.create!(hash)
			else
				puts "updating listing"
				listing = listing.first
				listing.update_attributes(hash)
				# Make sure listing photos are clear
				listing.photos.destroy_all
			end


			# Process listing photos
			l['pictures']['picture'].each do |p|
				hash_p  =  { 
								url: 			p['picture_url'],
								caption: 		p['picture_caption'],
								description: 	p['picture_description'],
								seq_number: 	p['picture_seq_number']
							}
				
				# Reject nil and empty values
	            hash_p.reject!{|k,v| v.blank?} 

				listing.photos.create!(hash_p)
			end

			# Landlords are made up of the contact information for each listing. When processing the listings in the feed, the contact information should be de-duplicated so that multiple listings can be associated to a single landlord.
			# Try finding a landlord
			landlord = Landlord.find_by(name: l['agent']['agent_name'])

			# If landlord exist
			if landlord.nil?
				# The phone number for listings should be stored in a non formatted state. eg: 000-000-0000 should be stored as 0000000000
				hash_l = {
							name: l['agent']['agent_name'],
							phone: l['agent']['agent_phone'].gsub(/[-() ]/, ''),
							email: l['agent']['agent_email'],
				}

				landlord = Landlord.create!(hash_l)
			end

			listing.landlord = landlord
			listing.save
		
		end
	end
end
