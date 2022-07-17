from tidalendpoints.models import CustomerRegister, UserAdminData


# when login, first get user email from customer register
# use that email and customer id to cross-check with customer_id
class LoginModal:
  def __init__(self, email, password):
    self.email = email
    self.password = password
    
  def login(self):
    try:
      lyst = []
      cusRes = CustomerRegister.objects.filter(email=self.email).values()
      if len( list( cusRes ) )> 0:
        cusData = list(cusRes)[0]
        # print( "here -> ", cusData )
        adminData = UserAdminData.objects.filter(
          customer_id=cusData['customer_id'],user_password=self.password ).values()
        # if user email is wrong.
        if len( list(adminData) ) > 0:
          data = cusData | list(adminData)[0] 
          data.pop("user_password", None)
          print( data )
          return  data
        else:
          print("Wrong Password")
          return "Wrong Password"
      else: 
        print( "email not found" )
        return "email not found"
    except Exception as e:
      print( e )
      return e
  