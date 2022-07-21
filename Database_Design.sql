/****************************************************************************************************

SCRIPT TO CREATE TIDAL OBJECT FOR DATABASE INSEE
RDS: MySQL
Created by: Roel Jose Hernandez Chaudary
Created: 04/21/2022
Company: Tidal Medical Technologies

Modifiy: 05/11/2022
Date        Modify by   Description
05/11/2022  Roel J      Change table name "CustomerDelivery" to "CustomerPayment"
05/11/2022  Roel J      Add column "payent_due_date" to table "CustomerPayment"  
05/11/2022  Roel J      Table "UserAdminData", Modify column name "customer_status" to "user_status"
     
*****************************************************************************************************/


/* TABLES */
CREATE TABLE InSee.DeviceManufacturingInfo (
  device_id varchar(30) NOT NULL, 
  device_status decimal(1,0)  NULL,
  device_version decimal(3,1)  NULL, 
  device_manufactured_date datetime(6)  NULL,
  CONSTRAINT DeviceManufacturingInfo_PK PRIMARY KEY (device_id)
); 

CREATE TABLE InSee.GatewayManufacturingInfo (
  gateway_id varchar(20)  NOT NULL, 
  gateway_status decimal(1,0)  NULL,
  gateway_version decimal(3,1)  NULL, 
  gateway_manufactured_date datetime(6)  NULL,
  SIM_id varchar(30)  NULL,
  CONSTRAINT GatewayManufacturingInfo_PK PRIMARY KEY (gateway_id)
); 

CREATE TABLE InSee.CustomerRegister (
  customer_id DECIMAL(10,0) NOT NULL,
  customer_name varchar(100) NULL,
  email varchar(50) NULL,
  phone varchar(40) NULL,
  billing_address varchar(200) NULL,
  contact_person varchar(50) NULL,
  customer_status DECIMAL(1,0) NULL,
  CONSTRAINT CustomerRegister_PK PRIMARY KEY (customer_id)
); 

CREATE TABLE InSee.SpirometerDeviceRegistration (
  device_id varchar(30) NOT NULL,
  customer_id  decimal(10,0) NOT NULL,
  patient_name varchar(40)  NULL,
  tidal_target   decimal(5,0) NOT NULL,
  patient_section varchar(40)  NULL,
  patient_room varchar(10)  NULL,
  device_status  decimal(1,0)  NULL,
  last_used_date  datetime(6)  NULL,
  CONSTRAINT SpirometerDeviceReg_device_FK FOREIGN KEY (device_id) REFERENCES DeviceManufacturingInfo (device_id),
  CONSTRAINT SpirometerDeviceReg_customer_FK FOREIGN KEY (customer_id) REFERENCES CustomerRegister (customer_id)
);

CREATE TABLE InSee.CustomerPayment (
  purchace_id decimal(10,0) NOT NULL,
  customer_id decimal(10,0) NOT NULL,
  payment_amount decimal(15,2) NOT NULL,
  payment_date  datetime(6)  NULL,
  payment_due_date  datetime(6)  NULL,
  CONSTRAINT CustomerDelivery_PK PRIMARY KEY (purchace_id),
  CONSTRAINT CustomerDelivery_FK FOREIGN KEY (customer_id) REFERENCES CustomerRegister (customer_id)
);

CREATE TABLE InSee.CustomerDeliveryDetail (
  purchace_id decimal(10,0) NOT NULL,
  device_id varchar(30)  NULL,
  gateway_id varchar(20)  NULL,
  delivery_date datetime(6)  NULL,
  CONSTRAINT CustomerDeliveryDetail_purchace_FK FOREIGN KEY (purchace_id) REFERENCES CustomerPayment (purchace_id),
  CONSTRAINT CustomerDeliveryDetail_device_FK FOREIGN KEY (device_id) REFERENCES DeviceManufacturingInfo (device_id),
  CONSTRAINT CustomerDeliveryDetail_gateway_FK FOREIGN KEY (gateway_id) REFERENCES GatewayManufacturingInfo (gateway_id),
  UNIQUE KEY CustomerDeliveryDetail_UN (purchace_id,device_id,gateway_id)
);

CREATE TABLE InSee.SpirometerTelemetryData (
  data_received datetime(6)  NULL,
  device_id varchar(30)  NULL,
  tidal_volume decimal(5,0)  NULL,
  gateway_id varchar(20)  NULL,
  gateway_latitude decimal(10,3)  NULL,
  gateway_longitude  decimal(10,3)  NULL,
  gateway_altitude  decimal(10,3)  NULL,
  gateway_snr decimal(10,3)  NULL,
  charge_level decimal(10,3)  NULL,
  CONSTRAINT SpirometerTelemetryData_device_FK FOREIGN KEY (device_id) REFERENCES DeviceManufacturingInfo (device_id),
  CONSTRAINT SpirometerTelemetryData_gateway_FK FOREIGN KEY (gateway_id) REFERENCES GatewayManufacturingInfo (gateway_id),
  UNIQUE KEY SpirometerTelemetryData_UN (data_received,device_id,gateway_id)
);

CREATE TABLE InSee.UserAdminData (
  user_id varchar(50) NOT NULL,
  customer_id decimal(10,0) NOT NULL,
  user_password varchar(100) NOT NULL,
  date_created datetime(6) NULL,
  user_status decimal(1,0) NULL,
  roles decimal(1,0) NULL,
  last_seen datetime(6) NULL,
  user_IP varchar(15) NULL,
  CONSTRAINT UserAdminData_PK PRIMARY KEY (user_id),
  CONSTRAINT UserAdminData_FK FOREIGN KEY (customer_id) REFERENCES CustomerRegister (customer_id)
);

CREATE TABLE InSee.APILog (
  user_id varchar(50) NULL,
  API_name varchar(50) NOT NULL,
  access_date datetime(6) NULL,
  CONSTRAINT APILog_FK FOREIGN KEY (user_id) REFERENCES UserAdminData (user_id)
);

CREATE TABLE InSee.AutomationUser (
  name varchar(50)  NULL,
  token1 varchar(50) NULL,
  token2 varchar(50) NULL,
  token1Status decimal(1,0) NULL,
  token2Status decimal(1,0) NULL,
  token1LastUsed  datetime(6) NULL,
  token2LastUsed  datetime(6) NULL,
  customer_id decimal(10,0) NULL,
  CONSTRAINT AutomationUser_FK FOREIGN KEY (customer_id) REFERENCES CustomerRegister (customer_id)
);

/* VIEWS */
create view InSee.PatientPerforInfo as
select d.device_id,
       d.customer_id,
       c.customer_name,
       d.patient_name,
       d.tidal_target,
       d.patient_section,
       d.patient_room,
       t.data_received,
       t.tidal_volume,
       t.gateway_id,
       t.gateway_latitude,
       t.gateway_longitude,
       t.gateway_altitude,
       t.gateway_snr,
       t.charge_level
from SpirometerTelemetryData t,
     SpirometerDeviceRegistration d,
     CustomerRegister c
where d.device_id=t.device_id
  and d.customer_id=c.customer_id;

