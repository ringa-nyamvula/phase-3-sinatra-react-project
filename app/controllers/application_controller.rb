class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  configure do 
    enable :cross_origin
  end

    # returns all the users
  get "/" do 
    all_users = User.all
    all_users.to_json
  end
  
   #returns all the pets for a specific user
   get "/pets/:username" do
    single_user = User.find_by(username:params[:username])
    single_user.pets.to_json 
  end
   
    #Searches through the list of all the pets and returns the pets that match
    post '/pets/search_all' do
      search_request = JSON.parse(request.body.read)
      search_response = Pet.where('name LIKE ? OR breed LIKE ?', "%#{search_request['query']}%", "%#{search_request['query']}%")
      search_response.to_json
    end 

      #Searches through a list of all the pets of a speific user and returns the pets that match
      post '/pets/search/:username' do
        search_request = JSON.parse(request.body.read)
        my_pets = User.find_by(username:params[:username])
        search_response = my_pets.pets.where('name LIKE ? OR breed LIKE ?', "%#{body['query']}%", "%#{body['query']}%")
        search_response.to_json
      end 

     #returns a list of all the pets in the database
     get "/pets"  do
      all_pets = Pet.all
      all_pets.to_json
    end

      #adds a new pet into the database
  post "/pet" do
    new_pet = Pet.create(JSON.parse(request.body.read))
    new_pet.to_json
  end

    #removes a pet from the database
    delete "/pets/:id" do
      find_pet = Pet.find(params[:id])
      find_pet.destroy
    end
      #changes the details of a single pet
  put "/pets/:id" do 
    new_details = JSON.parse(request.body.read)
        find_pet = Pet.find(params[:id])
        find_pet.update(new_details)
        find_pet.to_json
  end

  post "/user" do
    new_user = User.create(JSON.parse(request.body.read))
    new_user.to_json
  end

end