require 'json'

namespace :db do
	desc 'Fill database with sample data'
	task populate: :environment do
		populate_listings

	end

	# Popupulate users bae on json file
	def populate_listings
		listings = Hash.from_xml(File.read('config/data/code_challenge_listings.xml'))['properties']['property']
		
		listings.each do |l|
			# puts "Creating listing #{l['details']['listing_title']}..."

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
			listing = Listing.create!(hash)

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

			# Try finding a landlord
			landlord = Landlord.find_by(name: l['agent']['agent_name'])

			# If landlord exist
			if landlord.nil?
				hash_l = {
							name: l['agent']['agent_name'],
							phone: l['agent']['agent_phone'],
							email: l['agent']['agent_email'],
				}

				landlord = Landlord.create!(hash_l)
			end

			listing.landlord = landlord
			listing.save
		
		end
	end
end




















