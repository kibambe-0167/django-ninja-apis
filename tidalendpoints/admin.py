from django.contrib import admin
from tidalendpoints.models import CustomerRegister, UserAdminData, DeviceManufacturingInfo

# Register your models here.
admin.site.register(CustomerRegister)
admin.site.register(UserAdminData)
admin.site.register(DeviceManufacturingInfo)
