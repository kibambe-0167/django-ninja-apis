"""tidalapi URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from ninja import NinjaAPI, Schema
# 
# models logics
from tidalapi.logic import LoginModal, DeviceModal

# class
api = NinjaAPI()



@api.get("/")
def home( request ):
    
    return {"Home": "default end point" }


# login schema, parent is ninja.Schema
class loginSchema( Schema ):
    email: str; password: str
    
# login user, receive data
@api.post("/login" )
def login( request, data: loginSchema ):
    d = data.dict() ; print( d )
    loginObj = LoginModal(d['email'], d['password'])
    res = loginObj.login()
    return {"loginendpoint": res }
    return {"loginendpoint": "result here" }


class DeviceSchema( Schema ):
    id: int
# get devices
@api.post("/devices")
def devices( request, data: DeviceSchema ):
    d = data.dict()
    print( d )
    obj = DeviceModal(d['id'])
    data = obj.get_device()
    print( data )
    return {"Devices": data }
    return {"Devices": "data result" }


# base urls
urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', api.urls),
]






#  from customer table
# customer_id = 1
# customer_name = tidal
# phone = 0987654321
# billing address = uj bunting road auckland park
# contact person = tidal
# customer status = 1
# 
# from user admin data
# user_id = 1
# customer_id = 1
# pw = 123456
# user_status = 1
# roles = 1
# user ip = 1



