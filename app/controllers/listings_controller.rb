class ListingsController < ApplicationController

    ##################################################### FILTERS #####################################################

    # Include sorting params for sortable headers on index page
    include HeaderFiltersHelper

    ##################################################### RESOURCES #####################################################

    # Show all listings
    def index
       
        # Default sort parameter is created_at
        if params[:sort].blank?
            params[:sort] = { name: 'created_at', direction: '' }
        end

        @listings = Listing.order("#{sort_name_param} #{sort_direction_param}").paginate(per_page: 5, page: params[:page])

        # Respond to different formats
        respond_to do |format|
          format.html # index.html.erb
          format.js  # index.js.erb
          format.json { render json: @listings }
        end
    end 

    # Show an individual listing
    def show

        if @listing = Listing.find_by(id: params[:id])
            # Respond to different formats
            respond_to do |format|
              format.html # show.html.erb
              format.js # show.js.erb
              format.json { render json: @listing }
            end
        else
            flash[:success] = 'Listing does not exist'
            # Respond to different formats
            respond_to do |format|
              format.html { safe_redirect_to_back }
              format.json { render json: { message: "Listing does not exist" } }
            end
        end
    end

    # Create a form for new sensor
    def new
        @listing = Listing.new
    end

    # Create a new listing
    def create
        @listing = Listing.new(listing_params)
        
        if @listing.save

            flash[:success] = "Listing Sucessfully Created"
            
            # Respond to different formats
            respond_to do |format|
              format.html { redirect_to @listing }
              format.json { render json: { message: "Listing Sucessfully Created", listing: @listing } }
            end
        else
            flash[:error] = @listing.errors.full_messages
            # Respond to different formats
            respond_to do |format|
              format.html { render 'new' }
              format.json { render json: { message: "Listing Was Not Sucessfully Created", error: flash[:error] } }
            end
            
        end
    end 

    # Display form for updating an existing listing
    def edit

        @listing = Listing.find(params[:id])

        # If listing has not been approved yet and listing is owner, or listing is administrator, he can edit it
        if signed_in? && (@listing.id == current_listing.id) || current_listing.admin?
            # Show edit page
        else
            redirect_to root_path
            return
        end

    end

    # Update an existing listing
    def update

        @listing = Listing.find(params[:id])
        
        # If update is sucessful, redirect to listing page, else render edit page
        if @listing.update_attributes(listing_params)
            flash[:success] = "Update Is Successful"

            # If listing updated listing param's status, send them a confirmation email
            # if !listing_params[:o_status].nil? && @listing.active?
            #     ListingMailer.listing_approved({ name: @listing.listing.name, email: @listing.listing.email }).deliver
            # end

            # Respond to different formats
            respond_to do |format|
              format.html { redirect_to @listing }
              format.json { render json: { message: flash[:success] , listing: @listing } }
            end
        else
            flash[:error] = @listing.errors.full_messages
            # Respond to different formats
            respond_to do |format|
              format.html { render 'show' }
              format.json { render json: { message: "Listing Update Not Sucessful ", error: flash[:error] } }
            end
            
        end
    end 
    
    # Destroy an existing listing
    def destroy
        # Only admins have access
        unless is_admin?
            redirect_to root_path
            return
        end

        if @listing = Listing.find_by(id: params[:id])
            @listing.destroy

            flash[:success] = "Listing Successfully Destroyed"

            # Respond to different formats
            respond_to do |format|
              format.html { redirect_to listings_path }
              format.json { render json: @listing }
            end

        else
            render json: { message: "Listing Not Found" }
        end
    end


    ##################################################### PRIVATE #####################################################

    private
    
    # Strong Parameters
    def listing_params
        params.require(:listing).permit()
    end

    # Serach params (filter_data)
    def search_params
        params.permit(:id, :price)
    end
end
