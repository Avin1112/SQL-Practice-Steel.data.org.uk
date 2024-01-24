use practice2 ; 

show tables ; 

-- What are the details of all cars purchased in the year 2022?

select * from sales s inner join cars c on s.car_id = c.car_id where year(s.purchase_date) = 2022 ; 

-- What is the total number of cars sold by each salesperson ?

-- Method 1

select salesman_id , count(car_id) as "Total Cars Sold" from sales group by salesman_id ;   

-- Method 2

With table1 as
     (select s.salesman_id , sp.name , s.car_id from sales s inner join salespersons sp on s.salesman_id = sp.salesman_id ) ,
     table2 as
     (select salesman_id , name , count(car_id) as "Total Cars Sold" from table1 group by salesman_id )
select * from table2 ; 


-- What is the total revenue generated by each salesperson?

select salesman_id , count(car_id) as "Total Cars Sold" , sum(cost_$) as "Total Revenue Generated" from
         ( select s.salesman_id , c.car_id , c.cost_$ from sales s inner join cars c on s.car_id = c.car_id ) table1
	group by salesman_id ; 

-- What are the details of the cars sold by each salesperson?

# Method 1

select s.sale_id as "Transaction ID", s.salesman_id as "Salespeson ID" , 
	   s.purchase_date as "Purchased Date" , c.car_id as "Car ID" , c.make as "Car Maker", 
       c.type as "Car Type" , c.style as "Car Style" , c.cost_$ as "Car Cost ( $ )"
from sales s inner join cars c on s.car_id = c.car_id ; 

# Method 2

select s.sale_id as "Transaction ID" , s.salesman_id as "Salespeson ID" , sp.name as "Salespeson Name" , s.purchase_date as "Purchased Date" , 
    c.car_id as "Car ID" , c.make as "Car Maker" , c.type as "Car Type" , c.style as "Car Style" , c.cost_$ as "Car Cost ( $ )"
from sales s inner join cars c on s.car_id = c.car_id 
			 inner join salespersons sp on sp.salesman_id = s.salesman_id ; 
    
    
-- What is the total revenue generated by each car type ?

select type , sum(cost_$) as "Total Revenue Generated" from
							( select c.type , c.cost_$
							  from sales sal inner join cars c on sal.car_id = c.car_id ) table1
group by type ; 


-- What are the details of the cars sold in the year 2021 by salesperson 'Emily Wong'?

with table1 as 
     ( select s.salesman_id , sp.name , c.car_id  , c.make  , 
			  c.type , c.style  , s.purchase_date , c.cost_$ 
              from sales s inner join cars c on s.car_id = c.car_id
                         inner join salespersons sp on sp.salesman_id = s.salesman_id )
select salesman_id as "Salespeson ID" , name as "Salespeson Name"  , 
	   car_id as "Car ID" , make as "Car Maker" , 
       type as "Car Type" , style as "Car Style" , cost_$ as "Car Cost ( $ )"
       from table1 
where name = 'emily wong' and year(purchase_date) = 2021 ; 

-- What is the total revenue generated by the sales of hatchback cars ?

with table1 as
     ( select s.sale_id , c.style , c.cost_$ from sales s right join cars c on s.car_id = c.car_id )
select style , count(sale_id) as "Total Units Sold", sum(cost_$) as "Total Revenue Generated" from table1 where style = 'hatchback'; 

-- What is the total revenue generated by the sales of SUV cars in the year 2022? 

-- Method 1

with table1 as 
     ( select s.sale_id , s.purchase_date , c.style , c.cost_$ from sales s inner join cars c on s.car_id = c.car_id )
select style as "Car Style" , count(sale_id) as "Total Units Sold", sum(cost_$) as "Total Revenue Generated" 
from table1 where year(purchase_date) = 2022 and style = 'suv' ; 

-- Method 2

with table1 as 
       ( select s.sale_id , s.purchase_date , c.make , c.type , c.style , c.cost_$ from sales s inner join cars c on s.car_id = c.car_id )
select make as "Car Maker" , type as "Car Type" , count(sale_id) as "Total Units Sold", sum(cost_$) as "Total Revenue Generated" 
from table1 where year(purchase_date) = 2022 and style = 'suv' group by make , type  ;    


-- What is the name and city of the salesperson who sold the most number of cars in the year 2023 ?

-- Method 1
with table1 as 
     ( select s.sale_id , s.salesman_id , s.purchase_date , sp.name , sp.city
       from sales s left join salespersons sp on sp.salesman_id = s.salesman_id )
select salesman_id as "Salesperson ID", name as "Salesperson Name", city as "City", 
	   count(sale_id) as "Total Units Sold" from table1 where year(purchase_date) = 2023 
group by salesman_id order by count(sale_id) desc limit 1; 

-- Method 2

with table1 as 
	 ( select salesman_id , count(sale_id) from sales where year(purchase_date) = 2023 
	    group by salesman_id order by count(sale_id ) desc limit 1 )
select t1.salesman_id as "Salesperson ID" , t1.`count(sale_id)` as "Highest Cars Sold 2023" , 
       sp.name as "Salesperson Name", sp.city as "Salesperson Name"
from table1 t1 inner join salespersons sp on t1.salesman_id = sp.salesman_id ; 


-- What is the name and age of the salesperson who generated the highest revenue in the year 2022?

-- Method 1

with table1 as
	 ( select s.sale_id , s.salesman_id , s.purchase_date , c.car_id , c.cost_$ from sales s left join cars c on s.car_id = c.car_id ) ,
     table2 as
     ( select salesman_id , count(sale_id) as "Units Sold", sum(cost_$) as "Revenue Generated" from table1 
       where year(purchase_date) = 2022 group by salesman_id 
       order by sum(cost_$) desc limit 1 )
select t2.salesman_id as "Salesperson ID" , sp.name as "Salesperson Name", sp.age as "Age" , t2.`Units Sold` , t2.`Revenue Generated` 
from table2 t2 left join salespersons sp on sp.salesman_id = t2.salesman_id ;

-- Method 2

with table1 as 
     ( select s.sale_id , s.salesman_id , s.purchase_date , c.cost_$ , sp.name , sp.age 
         from sales s left join cars c on s.car_id = c.car_id 
			          left join salespersons sp on sp.salesman_id = s.salesman_id ) ,
	 table2 as 
     ( select salesman_id  as "Salesperson ID" , name as "Salesperson Name" , age as "Age" , 
       count(sale_id) as "Units Sold" , sum(cost_$) as "Revenue Generated" from table1 where year(purchase_date) = 2022 
       group by salesman_id order by sum(cost_$) desc limit 1)
select * from table2 ;

                      







































    
    





