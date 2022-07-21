from tidalendpoints.models import CustomerRegister, UserAdminData, DeviceManufacturingInfo


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
  
  
  
# read data from devices
class DeviceModal:
  def __init__(self, id ):
    self.device_id = id
    
  def get_device(self):
    try:
      data = DeviceManufacturingInfo.objects.filter(device_id=self.device_id).values()
      if len( list( data ) ) > 0:
        data_ = list()
        return list( data )
        # for i in data:
        #   d = self.format_( i )
        #   data_.append( d )
        # return data_
      else:
        return "Devices not found"
    except Exception as e:
      print( e )
      return e
    
  def format_( self, data ):
    d = {
      "device_id": data.device_id,
      "device_status": data.device_status,
      "device_version": data.device_version,
      "device_manufacture_date": data.device_manufacture_date
    }
    
    return d