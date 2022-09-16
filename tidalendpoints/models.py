from django.db import models


## Create your models here.

## users
class CustomerRegister( models.Model ):
  customer_id = models.DecimalField( max_digits=10, primary_key=True, decimal_places=0 )
  customer_name = models.CharField( max_length= 100 )
  email = models.CharField( max_length=50) 
  phone = models.CharField(max_length=40)
  billing_address = models.CharField( max_length=200)
  contact_person = models.CharField(max_length=50)
  customer_status = models.DecimalField( max_digits=1, decimal_places=0)

## user admin
class UserAdminData( models.Model):
  user_id = models.CharField(max_length=50, primary_key=True )
  customer_id = models.DecimalField(max_digits=10, decimal_places=0 )
  user_password = models.CharField(max_length=100)
  date_created = models.DateTimeField( auto_now_add=True )
  user_status = models.DecimalField(max_digits=6, decimal_places=0)
  roles = models.DecimalField(max_digits=1, decimal_places=0)
  last_seen = models.DateTimeField( auto_now_add=True )
  user_IP = models.CharField(max_length=15)
  
  
## device schema
class DeviceManufacturingInfo(models.Model ):
  device_id = models.IntegerField(primary_key=True)
  device_status = models.IntegerField()
  device_version = models.DecimalField(max_digits=20, decimal_places=2)
  device_manufacture_date = models.DateTimeField(auto_created=True)
   