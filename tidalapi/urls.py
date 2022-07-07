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
from tidalendpoints.models import CustomerRegister, UserAdminData

api = NinjaAPI()

def getData():
    lyst = []
    data = CustomerRegister.objects.all()
    d = CustomerRegister.objects.get(email="hbk@gmail.com")
    print( d )
    for i in data:
        lyst.append( {
            'customerId': i.customer_id, 
            "customerName": i.customer_name,
            'email': i.email, 
            'phone': i.phone, 
            'billingAddr': i.billing_address, 
            'contactPerson': i.contact_person, 
            'customerStatus': i.customer_status 
        } )
    return lyst

# def getAdminEmail(email):
#     lyst = []
#     data = CustomerRegister.objects.get(email=email)
#     return data
    # print( data )
    # for i in data:
    #     lyst.append( {
    #         'customerId': i.customer_id, 
    #         "customerName": i.customer_name,
    #         'email': i.email, 
    #         'phone': i.phone, 
    #         'billingAddr': i.billing_address, 
    #         'contactPerson': i.contact_person, 
    #         'customerStatus': i.customer_status 
    #     } )
    # return lyst

# def getAdmin(password, email):
#     cus_res = getAdminEmail( email )
    # lyst = []
    # data = UserAdminData.objects.get(email="hbk@gmail.com")
    # for i in data:
    #     lyst.append( {
    #         'customerId': i.customer_id, 
    #         "customerName": i.customer_name,
    #         'email': i.email, 
    #         'phone': i.phone, 
    #         'billingAddr': i.billing_address, 
    #         'contactPerson': i.contact_person, 
    #         'customerStatus': i.customer_status 
    #     } )
    # return lyst



@api.get("/")
def home( request ):
    d = getData()
    return {"Home": d }


# login schema, parent is ninja.Schema
class loginSchema( Schema ):
    email: str; password: str
    
# login user, receive data
@api.post("/login" )
def login( request, data: loginSchema ):
    print( data.dict() )
    return {"loginendpoint": "Ola" }



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
