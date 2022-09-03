echo "Usage: 'import_nwind.sh project_id', e.g. 'import_nwind.sh qwiklabs-gcp-01-0024968f50b7'"
#create demos dataset
bq mk   --dataset   --label event:northwind --label epoch:coronavirus2020  $1:demos

#create and load customers table
bq mk --schema=customer_id:STRING,company_name:STRING,contact_name:STRING,contact_title:STRING,address:STRING,city:STRING,region:STRING,postal_code:STRING,country:STRING,phone:STRING,fax:STRING --table $1:demos.customers

bq load --source_format=CSV --field_delimiter="\t" $1:demos.customers ./customers_tab.csv "customer_id:STRING,company_name:STRING,contact_name:STRING,contact_title:STRING,address:STRING, city:STRING,region:STRING,postal_code:STRING,country:STRING,phone:STRING,fax:STRING"

#create and load the orders table
bq mk  --schema=order_id:integer,customer_id:string,employee_id:integer,order_date:datetime,required_date:datetime,shipped_date:datetime,ship_via:integer,freight:float,ship_name:string,ship_address:string,ship_city:string,ship_region:string,ship_postal_code:string,ship_country:string  --table $1:demos.orders

bq load --source_format=CSV --field_delimiter="\t" --skip_leading_rows=1 $1:demos.orders ./orders_tab.csv "order_id:integer,customer_id:string,employee_id:integer,order_date:datetime,required_date:datetime,shipped_date:datetime,ship_via:integer,freight:float,ship_name:string,ship_address:string,ship_city:string,ship_region:string,ship_postal_code:string,ship_country:string"

#create and load the order_details table
bq mk  --schema=order_id:integer,product_id:integer,unit_price:float,quantity:integer,discount:float,product_name:string  --table $1:demos.order_details

bq load --source_format=CSV --field_delimiter="\t" --skip_leading_rows=1 $1:demos.order_details ./order_details_tab.csv "order_id:integer,product_id:integer,unit_price:float,quantity:integer,discount:float,product_name:string"

#create and load the regions table
bq mk  --schema=city:string,country:string,region:string  --table $1:demos.regions

bq load --source_format=CSV --field_delimiter="\t" --skip_leading_rows=1 $1:demos.regions ./regions_tab.csv "city:string,country:string,region:string"

#create and load the employees table
bq mk  --schema=employee_id:integer,last_name:string,first_name:string,title:string,title_of_courtesy:string,birth_date:timestamp,hire_date:timestamp,address:string,city:string,region:string,postal_code:string,country:string,home_phone:string,extension:string,reports_to:integer,photo_path:string  --table $1:demos.employees

bq load --source_format=CSV --field_delimiter="\t" --skip_leading_rows=1 $1:demos.employees ./employees_tab.csv "employee_id:integer,last_name:string,first_name:string,title:string,title_of_courtesy:string,birth_date:timestamp,hire_date:timestamp,address:string,city:string,region:string,postal_code:string,country:string,home_phone:string,extension:string,reports_to:integer,photo_path:string"

#create and load the products table
bq mk  --schema=product_id:integer,product_name:string,supplier_id:integer,category_id:integer,quantity_per_unit:string,unit_price:float,units_in_stock:integer,units_on_order:integer,reorder_level:integer,discontinued:boolean  --table $1:demos.products

bq load --source_format=CSV --field_delimiter="\t" --skip_leading_rows=1 $1:demos.products ./products_tab.csv "product_id:integer,product_name:string,supplier_id:integer,category_id:integer,quantity_per_unit:string,unit_price:float,units_in_stock:integer,units_on_order:integer,reorder_level:integer,discontinued:boolean"

#create and load the suppliers table
bq mk  --schema=supplier_id:integer,company_name:string,contact_name:string,contact_title:string,address:string,city:string,region:string,postal_code:string,country:string,phone:string,fax:string  --table $1:demos.suppliers

bq load --source_format=CSV --field_delimiter="\t" --skip_leading_rows=1 $1:demos.suppliers ./suppliers_tab.csv "supplier_id:integer,company_name:string,contact_name:string,contact_title:string,address:string,city:string,region:string,postal_code:string,country:string,phone:string,fax:string"

#create a bucket for the BigQuery ipython notebook
gsutil mb gs://$1-bq

#upload file to the bucket - you will download it into the Notebook VM
gsutil cp ./Bigquery_functions.ipynb gs://$1-bq
	
