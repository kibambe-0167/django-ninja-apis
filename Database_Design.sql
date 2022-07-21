/****************************************************************************************************

SCRIPT TO CREATE TIDAL OBJECT FOR DATABASE INSEE
RDS: MySQL
Created by: Roel Jose Hernandez Chaudary
Created: 04/21/2022
Company: Tidal Medical Technologies

Date        Modify by   Description
05/11/2022  Roel J      Change table name "CustomerDelivery" to "CustomerPayment"
05/11/2022  Roel J      Add column "payent_due_date" to table "CustomerPayment"  
05/11/2022  Roel J      Table "UserAdminData", Modify column name "customer_status" to "user_status"
07/05/2022  Roel J      Modify table SpirometerDeviceRegistration to include new fields
                        Added new table "PatientInformation"
                        Modify the view "PatientPerforInfo"
07/08/2022  Roel J      Added View "SpirometerTelemetryStats"
07/21/2022  Roel J      Modify the structure of table "SpirometerTelemetryData"
07/21/2022  Roel J      Table SpirometerDeviceRegistration change column name "last_used_date" to "date_device_assigned"
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

CREATE TABLE PatientInformation (
  patient_id   decimal(10,0) not null,
  customer_id  decimal(10,0) not null,
  patient_first_name varchar(100),
  patient_last_name varchar(100),
  CONSTRAINT PatientInformation_PK PRIMARY KEY (patient_id),
  CONSTRAINT PatientInformation_customer_FK FOREIGN KEY (customer_id) REFERENCES  CustomerRegister (customer_id)
);

CREATE TABLE InSee.SpirometerDeviceRegistration (
  device_id varchar(30) NOT NULL,
  customer_id  decimal(10,0) NOT NULL,
  patient_id   decimal(10,0) NOT NULL,
  tidal_target   decimal(5,0) NOT NULL,
  patient_section varchar(40)  NULL,
  patient_room varchar(10)  NULL,
  device_status  decimal(1,0)  NULL,
  date_device_assigned  datetime(6)  NULL,
  alarm_setting   decimal(2,0)  NULL,
  hourly_average_setting decimal(2,0) default 10,
  CONSTRAINT SpirometerDeviceReg_device_FK FOREIGN KEY (device_id) REFERENCES DeviceManufacturingInfo (device_id),
  CONSTRAINT SpirometerDeviceReg_customer_FK FOREIGN KEY (customer_id) REFERENCES CustomerRegister (customer_id)
  CONSTRAINT SpirometerDeviceReg_patient_FK FOREIGN KEY (patient_id) REFERENCES PatientInformation (patient_id)
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
 
CREATE TABLE SpirometerTelemetryData (
  data_received datetime(6) DEFAULT NULL,
  devEui varchar(30) DEFAULT NULL,
  tidal_volume decimal(5,0) DEFAULT NULL,
  fPort decimal(2,0) DEFAULT NULL,
  freq varchar(15) DEFAULT NULL,
  datarate varchar(3) DEFAULT NULL,
  snr decimal(10,3) DEFAULT NULL,
  nid decimal(10,0) DEFAULT NULL
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
       d.patient_id,
       p.patient_first_name,
       p.patient_last_name,
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
     CustomerRegister c,
     PatientInformation p
where d.device_id=t.device_id
  and d.customer_id=c.customer_id
  and d.customer_id=p.customer_id
  and d.patient_id=p.patient_id;

create view InSee.SpirometerTelemetryStats as
select p.patient_id,
       p.patient_first_name,
       p.patient_last_name,
       s1.total_alltime_attempts,
       s2.average_alltime_attempts,
       s4.total_alltime_success,
       s5.average_alltime_success,
       s4.total_alltime_success/s1.total_alltime_attempts as total_alltime_treatment_compliance,
       s8.average_alltime_compliance,
       s9.max_alltime_volume,
       s10.max_compliance,
       s11.last_volume_recorded,
       s12.last_volume_compliance,
       s13.last_hour_attempt,
       s14.last_hour_success,
       s14.last_hour_success/s13.last_hour_attempt as last_hour_compliance,
       s16.last_hour_average_volume,
       s17.last_hour_average_volume_compliance
  from PatientInformation p
  left join (select patient_id,
                    count(data_received) as total_alltime_attempts
               from SpirometerTelemetryData sd,
                    SpirometerDeviceRegistration sr
              where sr.device_id = sd.devEui 
                and tidal_volume>250
              group by patient_id) s1 
       on s1.patient_id = p.patient_id 
  left join (select patient_id,
       			    avg(tidal_volume) as average_alltime_attempts
			   from SpirometerTelemetryData sd,
			        SpirometerDeviceRegistration sr
			  where sr.device_id = sd.devEui 
			    and tidal_volume>250
			  group by patient_id) s2
       on s2.patient_id = p.patient_id 
  left join (select patient_id,
			        count(data_received) as total_alltime_success
			   from SpirometerTelemetryData sd,
			        SpirometerDeviceRegistration sr
			  where sr.device_id = sd.devEui 
			    and sd.tidal_volume >= sr.tidal_target 
			  group by patient_id) s4
       on s4.patient_id = p.patient_id
  left join (select patient_id,
			        avg(tidal_volume) as average_alltime_success
			   from SpirometerTelemetryData sd,
			        SpirometerDeviceRegistration sr
			  where sr.device_id = sd.devEui 
			    and sd.tidal_volume >= sr.tidal_target 
			  group by patient_id) s5
       on s5.patient_id = p.patient_id    
  left join (select patient_id,
			        avg(tidal_volume)/sr.tidal_target  as average_alltime_compliance
			   from SpirometerTelemetryData sd,
			        SpirometerDeviceRegistration sr
			  where sr.device_id = sd.devEui 
			    and tidal_volume>250
			  group by patient_id,sr.tidal_target) s8
       on s8.patient_id = p.patient_id    
  left join (select patient_id,
			        max(tidal_volume) as max_alltime_volume
			   from SpirometerTelemetryData sd,
			        SpirometerDeviceRegistration sr
			  where sr.device_id = sd.devEui     
			  group by patient_id) s9
       on s9.patient_id = p.patient_id    
  left join (select patient_id,
			        max(tidal_volume)/sr.tidal_target  as max_compliance
			   from SpirometerTelemetryData sd,
			        SpirometerDeviceRegistration sr
			  where sr.device_id = sd.devEui     
			  group by patient_id,sr.tidal_target) s10
       on s10.patient_id = p.patient_id    
  left join (select sr.patient_id,
			        sd.tidal_volume as last_volume_recorded
			   from SpirometerTelemetryData sd,
			        SpirometerDeviceRegistration sr,
			        (select devEui,
			                max(data_received) as max_date
			           from SpirometerTelemetryData
			          group by devEui) md
			  where sr.device_id = sd.devEui 
			    and sd.devEui = md.devEui
			    and sd.data_received = md.max_date) s11
       on s11.patient_id = p.patient_id    
  left join (select sr.patient_id,
			        sd.tidal_volume/sr.tidal_target  as last_volume_compliance
			   from SpirometerTelemetryData sd,
			        SpirometerDeviceRegistration sr,
			        (select devEui,max(data_received) as max_date
			           from SpirometerTelemetryData
			          group by devEui) md
			  where sr.device_id = sd.devEui 
			    and sd.devEui = md.devEui
			    and sd.data_received = md.max_date) s12
       on s12.patient_id = p.patient_id    
  left join (select patient_id,
			        count(data_received) as last_hour_attempt 
			   from SpirometerTelemetryData sd,
			        SpirometerDeviceRegistration sr 
			  where sr.device_id = sd.devEui 
			    and data_received > now() - interval 1 hour
			    and tidal_volume>250
			  group by patient_id) s13
       on s13.patient_id = p.patient_id    
  left join (select patient_id,
			        count(data_received) as last_hour_success
		  	   from SpirometerTelemetryData sd,
			        SpirometerDeviceRegistration sr
			  where sr.device_id = sd.devEui 
			    and sd.tidal_volume >= sr.tidal_target 
			    and data_received > now() - interval 1 hour
			  group by patient_id) s14
       on s14.patient_id = p.patient_id    
  left join (select patient_id,
			        avg(tidal_volume) as last_hour_average_volume 
			   from SpirometerTelemetryData sd,
			        SpirometerDeviceRegistration sr 
			  where sr.device_id = sd.devEui 
			    and data_received > now() - interval 1 hour
			    and tidal_volume>250
			  group by patient_id) s16
       on s16.patient_id = p.patient_id  
  left join (select patient_id,
			        avg(tidal_volume)/sr.tidal_target  as last_hour_average_volume_compliance 
			   from SpirometerTelemetryData sd,
			        SpirometerDeviceRegistration sr 
			  where sr.device_id = sd.devEui 
			    and data_received > now() - interval 1 hour
			    and tidal_volume>250
			  group by patient_id,sr.tidal_target) s17
       on s17.patient_id = p.patient_id;


