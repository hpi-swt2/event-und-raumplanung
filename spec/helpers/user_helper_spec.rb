 module UserHelper
  def testUser
  	@user = User.where(email:'test@test.de').first
  	unless @user 
  	  @user = User.create! email: 'test@test.de', password:'test1234' #Nur solange es keine Authentifikation gibt frag Micha
  	end 
  	@user
  end
end